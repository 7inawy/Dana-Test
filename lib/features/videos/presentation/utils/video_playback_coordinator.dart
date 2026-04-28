import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Ensures only one video source plays at a time across the app.
///
/// This is intentionally simple/global because multiple video detail routes
/// can remain in the navigation stack, leaving their controllers alive.
class VideoPlaybackCoordinator {
  static VideoPlayerController? _activeVideo;
  static YoutubePlayerController? _activeYoutube;

  static Future<void> setActiveVideo(VideoPlayerController controller) async {
    if (identical(_activeVideo, controller)) return;

    final prevVideo = _activeVideo;
    final prevYoutube = _activeYoutube;

    _activeVideo = controller;
    _activeYoutube = null;

    try {
      if (prevVideo != null && prevVideo.value.isPlaying) {
        await prevVideo.pause();
      }
    } catch (_) {}

    try {
      if (prevYoutube != null && prevYoutube.value.isPlaying) {
        prevYoutube.pause();
      }
    } catch (_) {}
  }

  static void setActiveYoutube(YoutubePlayerController controller) {
    if (identical(_activeYoutube, controller)) return;

    final prevVideo = _activeVideo;
    final prevYoutube = _activeYoutube;

    _activeVideo = null;
    _activeYoutube = controller;

    try {
      if (prevVideo != null && prevVideo.value.isPlaying) {
        prevVideo.pause();
      }
    } catch (_) {}

    try {
      if (prevYoutube != null && prevYoutube.value.isPlaying) {
        prevYoutube.pause();
      }
    } catch (_) {}
  }

  static void clearVideo(VideoPlayerController controller) {
    if (identical(_activeVideo, controller)) {
      _activeVideo = null;
    }
  }

  static void clearYoutube(YoutubePlayerController controller) {
    if (identical(_activeYoutube, controller)) {
      _activeYoutube = null;
    }
  }
}

