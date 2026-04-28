import '../../data/model/video_Model.dart';

sealed class VideosState {
  const VideosState();
}

class VideosInitial extends VideosState {
  const VideosInitial();
}

class VideosLoading extends VideosState {
  const VideosLoading();
}

class VideosLoaded extends VideosState {
  final List<VideoModel> videos;
  const VideosLoaded(this.videos);
}

class VideosSearchLoaded extends VideosState {
  final List<VideoModel> results;
  const VideosSearchLoaded(this.results);
}

class VideosError extends VideosState {
  final String message;
  const VideosError(this.message);
}
