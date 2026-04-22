import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../../../../core/api/response_unwrap.dart';
import '../model/video_Model.dart';

class VideosService {
  final Dio dio;

  VideosService(this.dio);

  Future<List<VideoModel>> getVideos() async {
    final res = await dio.get(ApiEndpoint.videos);
    final list = ResponseUnwrap.unwrapList(res.data);
    return list
        .whereType<Map>()
        .map((e) => VideoModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<VideoModel> getVideoById(String id) async {
    final res = await dio.get('${ApiEndpoint.videoById}$id');
    final map = ResponseUnwrap.unwrapMap(res.data);
    return VideoModel.fromJson(map.cast<String, dynamic>());
  }

  Future<List<VideoModel>> search(String query) async {
    final res = await dio.get(
      ApiEndpoint.videosSearch,
      queryParameters: {'q': query},
    );
    final list = ResponseUnwrap.unwrapList(res.data);
    return list
        .whereType<Map>()
        .map((e) => VideoModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
