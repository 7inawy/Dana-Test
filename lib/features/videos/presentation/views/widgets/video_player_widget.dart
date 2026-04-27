import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_raduis.dart';
import '../../../data/model/video_Model.dart';

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

  String get _url => (widget.video.videoUrl ?? '').trim();

  String? _extractYouTubeId(String url) {
    final u = url.trim();
    if (u.isEmpty) return null;
    final uri = Uri.tryParse(u);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();

    // Standard patterns.
    final fromPkg = YoutubePlayerController.convertUrlToId(u);
    if (fromPkg != null && fromPkg.isNotEmpty) return fromPkg;

    // https://youtu.be/<id>
    if (host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }

    // https://www.youtube-nocookie.com/embed/<id>
    final segments = uri.pathSegments;
    final embedIndex = segments.indexOf('embed');
    if (embedIndex != -1 && embedIndex + 1 < segments.length) {
      return segments[embedIndex + 1];
    }

    // https://www.youtube.com/shorts/<id>
    final shortsIndex = segments.indexOf('shorts');
    if (shortsIndex != -1 && shortsIndex + 1 < segments.length) {
      return segments[shortsIndex + 1];
    }

    // As a last resort, accept a `v` query param.
    final v = uri.queryParameters['v'];
    if (v != null && v.isNotEmpty) return v;

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
        _youtubeController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            strictRelatedVideos: true,
          ),
        );
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
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
    _youtubeController?.close();
    _youtubeController = null;
    _webViewController = null;
  }

  @override
  void dispose() {
    _disposePlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            ? YoutubePlayer(
                controller: _youtubeController!,
                aspectRatio: 392 / 256,
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
