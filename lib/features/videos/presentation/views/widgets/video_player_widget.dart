import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../data/model/video_Model.dart';
import '../../utils/video_playback_coordinator.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel video;

  const VideoPlayerWidget({super.key, required this.video});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  static const YoutubePlayerFlags _kYoutubeFlags = YoutubePlayerFlags(
    autoPlay: false,
    mute: false,
  );

  static const Duration _kYoutubeProgressDebounce = Duration(milliseconds: 250);
  static const Duration _kSeekStep = Duration(seconds: 10);

  static const double _kOuterWidth = 392;
  static const double _kOuterHeight = 256;
  static const double _kErrorHorizontalPadding = 16;
  static const double _kErrorGap = 12;
  static const double _kProgressBarHeight = 3;
  static const double _kControlsHorizontalPadding = 16;
  static const double _kControlsVerticalPadding = 10;
  static const double _kControlsGap = 12;
  static const double _kIconSize = 24;
  static const FontWeight _kControlsFontWeight = FontWeight.w500;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  WebViewController? _webViewController;
  bool _useWebView = false;
  bool _webViewLoading = false;
  bool _initStarted = false;
  String? _initError;
  bool _wasPlaying = false;
  final ValueNotifier<_YoutubeProgress> _youtubeProgress =
      ValueNotifier(const _YoutubeProgress.zero());
  Timer? _ytProgressDebounce;

  YoutubePlayerController? get _yt => _youtubeController;

  String get _url => (widget.video.videoUrl ?? '').trim();

  static final RegExp _youtubeIdPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');

  @override
  void dispose() {
    _ytProgressDebounce?.cancel();
    _youtubeProgress.dispose();
    _disposePlayers();
    super.dispose();
  }

  String? _sanitizeYouTubeId(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null;

    // Sometimes backend sends malformed embed like:
    // ".../embed/RQuqTaq9ooEsi=Aaut_..." (missing '?'), so strip any extra suffix.
    final stripped = v.split('?').first.split('&').first;
    if (_youtubeIdPattern.hasMatch(stripped)) return stripped;

    // As a fallback, extract the first 11-char token-like substring.
    final match = RegExp(r'[a-zA-Z0-9_-]{11}').firstMatch(stripped);
    return match?.group(0);
  }

  String? _extractYouTubeId(String url) {
    final u = url.trim();
    if (u.isEmpty) return null;
    final uri = Uri.tryParse(u);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();

    // Standard patterns.
    final fromPkg =
        _sanitizeYouTubeId(YoutubePlayer.convertUrlToId(u));
    if (fromPkg != null && fromPkg.isNotEmpty) return fromPkg;

    // https://youtu.be/<id>
    if (host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
      return _sanitizeYouTubeId(uri.pathSegments.first);
    }

    // https://www.youtube-nocookie.com/embed/<id>
    final segments = uri.pathSegments;
    final embedIndex = segments.indexOf('embed');
    if (embedIndex != -1 && embedIndex + 1 < segments.length) {
      return _sanitizeYouTubeId(segments[embedIndex + 1]);
    }

    // https://www.youtube.com/shorts/<id>
    final shortsIndex = segments.indexOf('shorts');
    if (shortsIndex != -1 && shortsIndex + 1 < segments.length) {
      return _sanitizeYouTubeId(segments[shortsIndex + 1]);
    }

    // As a last resort, accept a `v` query param.
    final v = uri.queryParameters['v'];
    final sanitizedV = _sanitizeYouTubeId(v);
    if (sanitizedV != null && sanitizedV.isNotEmpty) return sanitizedV;

    return null;
  }

  bool get _isYouTube {
    final u = _url.toLowerCase();
    return u.contains('youtube.com') ||
        u.contains('youtu.be') ||
        u.contains('youtube-nocookie.com');
  }

  bool _looksLikeDirectVideoUrl(Uri uri) {
    final p = uri.path.toLowerCase();
    return p.endsWith('.mp4') ||
        p.endsWith('.m3u8') ||
        p.endsWith('.mov') ||
        p.endsWith('.webm') ||
        p.endsWith('.mkv');
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      _disposePlayers();
      _initStarted = false;
      _initError = null;
      _useWebView = false;
      _webViewLoading = false;
      _init();
    }
  }

  Future<void> _init() async {
    if (_initStarted) return;
    _initStarted = true;

    final url = _url;
    if (url.isEmpty) {
      setState(() => _initError = 'Video link is not available');
      return;
    }

    try {
      if (_isYouTube) {
        final videoId = _extractYouTubeId(url);
        if (videoId == null || videoId.isEmpty) {
          setState(() => _initError = 'Invalid YouTube link');
          return;
        }
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: _kYoutubeFlags,
        );
        _youtubeController!.addListener(_handleYoutubeTick);
        if (mounted) setState(() {});
        return;
      }

      final uri = Uri.tryParse(url);
      if (uri == null) {
        setState(() => _initError = 'Invalid video link');
        return;
      }

      // Prefer native playback for direct video streams/files. If initialization
      // fails (or the URL is likely a normal webpage), fall back to an in-app WebView.
      final shouldTryNativeFirst = _looksLikeDirectVideoUrl(uri);
      if (shouldTryNativeFirst) {
        final controller = VideoPlayerController.networkUrl(uri);
        _videoController = controller;
        await controller.initialize();
        controller.addListener(_handleNativeVideoPlaybackChange);
        _chewieController = ChewieController(
          videoPlayerController: controller,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          allowPlaybackSpeedChanging: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary_default_light,
            bufferedColor: AppColors.border_card_default_light,
            handleColor: AppColors.primary_default_light,
            backgroundColor: AppColors.border_card_default_light,
          ),
        );
        if (mounted) setState(() {});
        return;
      }

      _useWebView = true;
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) setState(() => _webViewLoading = true);
            },
            onPageFinished: (_) {
              if (mounted) setState(() => _webViewLoading = false);
            },
            onWebResourceError: (_) {
              if (mounted) {
                setState(() => _initError = 'Failed to load page');
              }
            },
          ),
        )
        ..loadRequest(uri);
      if (mounted) setState(() {});
    } catch (e) {
      // If native init fails, try WebView as a last resort (useful for embed pages).
      if (!mounted) return;
      final uri = Uri.tryParse(url);
      if (uri == null) {
        setState(() => _initError = 'Failed to load video');
        return;
      }
      _disposePlayers();
      _useWebView = true;
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => _webViewLoading = true),
            onPageFinished: (_) => setState(() => _webViewLoading = false),
            onWebResourceError: (_) => setState(() => _initError = 'Failed to load page'),
          ),
        )
        ..loadRequest(uri);
      setState(() {});
    }
  }

  void _disposePlayers() {
    final vc = _videoController;
    if (vc != null) {
      vc.removeListener(_handleNativeVideoPlaybackChange);
      VideoPlaybackCoordinator.clearVideo(vc);
    }
    final yc = _youtubeController;
    if (yc != null) {
      yc.removeListener(_handleYoutubeTick);
      VideoPlaybackCoordinator.clearYoutube(yc);
    }
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
    _youtubeController?.dispose();
    _youtubeController = null;
    _webViewController = null;
  }

  void _handleYoutubeTick() {
    final c = _yt;
    if (c == null || !mounted) return;

    if (c.value.isPlaying) {
      VideoPlaybackCoordinator.setActiveYoutube(c);
    }

    // YouTube controller notifies very frequently; throttle UI updates.
    if (_ytProgressDebounce?.isActive ?? false) return;
    _ytProgressDebounce = Timer(_kYoutubeProgressDebounce, () {
      final ctrl = _yt;
      if (ctrl == null || !mounted) return;
      _youtubeProgress.value = _YoutubeProgress(
        position: ctrl.value.position,
        duration: ctrl.metadata.duration,
        isPlaying: ctrl.value.isPlaying,
      );
    });
  }

  void _handleNativeVideoPlaybackChange() {
    final c = _videoController;
    if (c == null) return;

    final isPlaying = c.value.isPlaying;
    if (isPlaying && !_wasPlaying) {
      _wasPlaying = true;
      VideoPlaybackCoordinator.setActiveVideo(c);
      return;
    }
    if (!isPlaying && _wasPlaying) {
      _wasPlaying = false;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _seekBackward() {
    final c = _yt;
    if (c == null) return;
    final p = _youtubeProgress.value.position;
    final newPosition = p - _kSeekStep;
    c.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _seekForward() {
    final c = _yt;
    if (c == null) return;
    final p = _youtubeProgress.value.position;
    final d = _youtubeProgress.value.duration;
    final newPosition = p + _kSeekStep;
    c.seekTo(newPosition > d ? d : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final player = _buildPlayer(context, isDark: isDark);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radius_lg),
          child: SizedBox(
            width: _kOuterWidth.w,
            height: _kOuterHeight.h,
            child: player,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayer(BuildContext context, {required bool isDark}) {
    if (_initError != null) {
      return _ErrorView(
        message: _initError!,
        horizontalPadding: _kErrorHorizontalPadding,
        gap: _kErrorGap,
      );
    }

    final ytController = _youtubeController;
    if (ytController != null) {
      return _YoutubePlayerView(
        controller: ytController,
        progress: _youtubeProgress,
        isDark: isDark,
        onSeekBackward: _seekBackward,
        onSeekForward: _seekForward,
        onTogglePlayPause: () {
          final c = _yt;
          if (c == null) return;
          if (c.value.isPlaying) {
            c.pause();
          } else {
            VideoPlaybackCoordinator.setActiveYoutube(c);
            c.play();
          }
        },
        formatDuration: _formatDuration,
        progressBarHeight: _kProgressBarHeight,
        controlsHorizontalPadding: _kControlsHorizontalPadding,
        controlsVerticalPadding: _kControlsVerticalPadding,
        controlsGap: _kControlsGap,
        iconSize: _kIconSize,
        controlsFontWeight: _kControlsFontWeight,
      );
    }

    final chewie = _chewieController;
    if (chewie != null) {
      return Chewie(controller: chewie);
    }

    if (_useWebView && _webViewController != null) {
      return _WebViewStack(
        controller: _webViewController!,
        loading: _webViewLoading,
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final double horizontalPadding;
  final double gap;

  const _ErrorView({
    required this.message,
    required this.horizontalPadding,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.medium12TextBody(context),
            ),
            SizedBox(height: gap.h),
          ],
        ),
      ),
    );
  }
}

class _WebViewStack extends StatelessWidget {
  final WebViewController controller;
  final bool loading;

  const _WebViewStack({required this.controller, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _YoutubePlayerView extends StatelessWidget {
  final YoutubePlayerController controller;
  final ValueNotifier<_YoutubeProgress> progress;
  final bool isDark;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final VoidCallback onTogglePlayPause;
  final String Function(Duration) formatDuration;
  final double progressBarHeight;
  final double controlsHorizontalPadding;
  final double controlsVerticalPadding;
  final double controlsGap;
  final double iconSize;
  final FontWeight controlsFontWeight;

  const _YoutubePlayerView({
    required this.controller,
    required this.progress,
    required this.isDark,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onTogglePlayPause,
    required this.formatDuration,
    required this.progressBarHeight,
    required this.controlsHorizontalPadding,
    required this.controlsVerticalPadding,
    required this.controlsGap,
    required this.iconSize,
    required this.controlsFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radius_lg),
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: false,
            ),
          ),
        ),
        _YoutubeProgressBar(
          progress: progress,
          height: progressBarHeight,
          isDark: isDark,
          onTapDown: (details) {
            final total = progress.value.duration;
            if (total.inMilliseconds <= 0) return;
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            final dx = details.localPosition.dx / box.size.width;
            final seekTo = total * dx;
            controller.seekTo(seekTo);
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: controlsHorizontalPadding.w,
            vertical: controlsVerticalPadding.h,
          ),
          child: ValueListenableBuilder<_YoutubeProgress>(
            valueListenable: progress,
            builder: (context, p, _) {
              return _YoutubeControlsRow(
                progress: p,
                isDark: isDark,
                onSeekBackward: onSeekBackward,
                onSeekForward: onSeekForward,
                onTogglePlayPause: onTogglePlayPause,
                formatDuration: formatDuration,
                gap: controlsGap,
                iconSize: iconSize,
                fontWeight: controlsFontWeight,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _YoutubeProgressBar extends StatelessWidget {
  final ValueNotifier<_YoutubeProgress> progress;
  final double height;
  final bool isDark;
  final GestureTapDownCallback onTapDown;

  const _YoutubeProgressBar({
    required this.progress,
    required this.height,
    required this.isDark,
    required this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      child: SizedBox(
        height: height.h,
        child: ValueListenableBuilder<_YoutubeProgress>(
          valueListenable: progress,
          builder: (context, p, _) {
            return LinearProgressIndicator(
              value: p.duration.inSeconds > 0
                  ? (p.position.inSeconds / p.duration.inSeconds)
                  : 0,
              backgroundColor: isDark
                  ? AppColors.border_card_default_dark
                  : AppColors.border_card_default_light,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.primary_default_light,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _YoutubeControlsRow extends StatelessWidget {
  final _YoutubeProgress progress;
  final bool isDark;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final VoidCallback onTogglePlayPause;
  final String Function(Duration) formatDuration;
  final double gap;
  final double iconSize;
  final FontWeight fontWeight;

  const _YoutubeControlsRow({
    required this.progress,
    required this.isDark,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onTogglePlayPause,
    required this.formatDuration,
    required this.gap,
    required this.iconSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark
        ? AppColors.text_heading_dark
        : AppColors.text_heading_light;
    final textColor =
        isDark ? AppColors.text_body_dark : AppColors.text_body_light;

    return Row(
      textDirection: Directionality.of(context),
      children: [
        GestureDetector(
          onTap: onSeekBackward,
          child: Icon(Icons.replay_10, size: iconSize.sp, color: iconColor),
        ),
        SizedBox(width: gap.w),
        GestureDetector(
          onTap: onTogglePlayPause,
          child: Icon(
            progress.isPlaying ? Icons.pause : Icons.play_arrow,
            size: iconSize.sp,
            color: iconColor,
          ),
        ),
        SizedBox(width: gap.w),
        GestureDetector(
          onTap: onSeekForward,
          child: Icon(Icons.forward_10, size: iconSize.sp, color: iconColor),
        ),
        const Spacer(),
        Text(
          '${formatDuration(progress.position)} / ${formatDuration(progress.duration)}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _YoutubeProgress {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  const _YoutubeProgress({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  const _YoutubeProgress.zero()
      : position = Duration.zero,
        duration = Duration.zero,
        isPlaying = false;
}
