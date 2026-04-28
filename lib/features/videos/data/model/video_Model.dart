import '../../../../core/config/app_config.dart';

class VideoModel {
  final String id;
  final String title;
  final String duration;
  final String imageUrl;
  final String? description;
  final int? views;
  final String? videoUrl;

  const VideoModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
    this.description,
    this.views,
    this.videoUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      duration: json['time']?.toString() ?? '',
      imageUrl: json['cover']?.toString() ?? '',
      description: json['description']?.toString(),
      views: int.tryParse(json['views']?.toString() ?? ''),
      videoUrl: json['link']?.toString(),
    );
  }

  /// Best-effort resolution for `cover` values returned by the backend.
  ///
  /// Many deployments return relative paths like `/uploads/foo.jpg` (or `uploads/foo.jpg`).
  /// The API base URL is typically `https://host.tld/api`, while static assets are served
  /// from `https://host.tld/...`, so we strip the trailing `/api` when present.
  String get resolvedImageUrl {
    final raw = imageUrl.trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    final base = AppConfig.apiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final assetHost = base.replaceFirst(RegExp(r'/api$'), '');
    final normalizedPath = raw.startsWith('/') ? raw : '/$raw';
    return '$assetHost$normalizedPath';
  }
}

class VideoSection {
  final String title;
  final List<VideoModel> videos;

  const VideoSection({required this.title, required this.videos});
}
