import '../model/video_Model.dart';
import '../services/videos_service.dart';

class VideosRepo {
  final VideosService service;

  VideosRepo(this.service);

  Future<List<VideoModel>> getVideos() => service.getVideos();

  Future<VideoModel> getVideoById(String id) => service.getVideoById(id);

  Future<List<VideoModel>> search(String query) => service.search(query);
}
