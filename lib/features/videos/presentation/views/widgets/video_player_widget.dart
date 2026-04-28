import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  WebViewController? _webViewController;
  bool _useWebView = false;
  bool _webViewLoading = false;
  bool _initStarted = false;
  String? _initError;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _wasPlaying = false;

  String get _url => (widget.video.videoUrl ?? '').trim();

  static final RegExp _youtubeIdPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');

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
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
        _youtubeController!.addListener(() {
          if (!mounted) return;
          final c = _youtubeController!;
          if (c.value.isPlaying) {
            VideoPlaybackCoordinator.setActiveYoutube(c);
          }
          setState(() {
            _currentPosition = c.value.position;
            _totalDuration = c.metadata.duration;
          });
        });
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
    final c = _youtubeController;
    if (c == null) return;
    final newPosition = _currentPosition - const Duration(seconds: 10);
    c.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _seekForward() {
    final c = _youtubeController;
    if (c == null) return;
    final newPosition = _currentPosition + const Duration(seconds: 10);
    c.seekTo(newPosition > _totalDuration ? _totalDuration : newPosition);
  }

  @override
  void dispose() {
    _disposePlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final player = _initError != null
        ? Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _initError!,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.medium12TextBody(context),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          )
        : (_youtubeController != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Video
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.radius_lg),
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: false,
                      ),
                    ),
                  ),

                  // Progress bar (tap to seek)
                  GestureDetector(
                    onTapDown: (details) {
                      if (_totalDuration.inMilliseconds <= 0) return;
                      final box = context.findRenderObject() as RenderBox?;
                      if (box == null) return;
                      final dx = details.localPosition.dx / box.size.width;
                      final seekTo = _totalDuration * dx;
                      _youtubeController!.seekTo(seekTo);
                    },
                    child: SizedBox(
                      height: 3.h,
                      child: LinearProgressIndicator(
                        value: _totalDuration.inSeconds > 0
                            ? (_currentPosition.inSeconds /
                                _totalDuration.inSeconds)
                            : 0,
                        backgroundColor: isDark
                            ? AppColors.border_card_default_dark
                            : AppColors.border_card_default_light,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary_default_light,
                        ),
                      ),
                    ),
                  ),

                  // Controls row
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        GestureDetector(
                          onTap: _seekBackward,
                          child: Icon(
                            Icons.replay_10,
                            size: 24.sp,
                            color: isDark
                                ? AppColors.text_heading_dark
                                : AppColors.text_heading_light,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            final c = _youtubeController!;
                            if (c.value.isPlaying) {
                              c.pause();
                            } else {
                              VideoPlaybackCoordinator.setActiveYoutube(c);
                              c.play();
                            }
                            setState(() {});
                          },
                          child: Icon(
                            _youtubeController!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 24.sp,
                            color: isDark
                                ? AppColors.text_heading_dark
                                : AppColors.text_heading_light,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: _seekForward,
                          child: Icon(
                            Icons.forward_10,
                            size: 24.sp,
                            color: isDark
                                ? AppColors.text_heading_dark
                                : AppColors.text_heading_light,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.text_body_dark
                                : AppColors.text_body_light,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : (_chewieController != null
                ? Chewie(controller: _chewieController!)
                : (_useWebView && _webViewController != null
                    ? Stack(
                        children: [
                          WebViewWidget(controller: _webViewController!),
                          if (_webViewLoading)
                            const Center(child: CircularProgressIndicator()),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()))));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radius_lg),
          child: SizedBox(
            width: 392.w,
            height: 256.h,
            child: player,
          ),
        ),
      ],
    );
  }
}
