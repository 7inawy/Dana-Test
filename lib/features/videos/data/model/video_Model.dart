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
}

class VideoSection {
  final String title;
  final List<VideoModel> videos;

  const VideoSection({required this.title, required this.videos});
}
