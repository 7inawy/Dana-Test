import '../../../../core/config/app_config.dart';
import 'package:flutter/widgets.dart';

class VideoModel {
  final String id;
  final String title;
  final String? titleAr;
  final String? titleEn;
  final String duration;
  final String imageUrl;
  final String? description;
  final int? views;
  final String? videoUrl;

  const VideoModel({
    required this.id,
    required this.title,
    this.titleAr,
    this.titleEn,
    required this.duration,
    required this.imageUrl,
    this.description,
    this.views,
    this.videoUrl,
  });

  static String? _readLangValue(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static ({String? ar, String? en, String? base}) _parseTitle(
    Map<String, dynamic> json,
  ) {
    final t = json['title'];

    String? ar;
    String? en;
    String? base;

    if (t is Map) {
      final map = t.cast<dynamic, dynamic>();
      ar = _readLangValue(map['ar'] ?? map['ar-EG'] ?? map['ar_sa']);
      en = _readLangValue(map['en'] ?? map['en-US'] ?? map['en_GB']);
    } else if (t != null) {
      base = t.toString();
    }

    // Common alternative keys
    ar ??= _readLangValue(json['title_ar'] ?? json['titleAr']);
    en ??= _readLangValue(json['title_en'] ?? json['titleEn']);
    base ??= _readLangValue(json['name'] ?? json['videoTitle']);

    return (ar: ar?.trim().isEmpty ?? true ? null : ar!.trim(), en: en?.trim().isEmpty ?? true ? null : en!.trim(), base: base?.trim().isEmpty ?? true ? null : base!.trim());
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final parsedTitle = _parseTitle(json);
    return VideoModel(
      id: json['_id']?.toString() ?? '',
      title: parsedTitle.ar ?? parsedTitle.base ?? parsedTitle.en ?? '',
      titleAr: parsedTitle.ar,
      titleEn: parsedTitle.en,
      duration: json['time']?.toString() ?? '',
      imageUrl: json['cover']?.toString() ?? '',
      description: json['description']?.toString(),
      views: int.tryParse(json['views']?.toString() ?? ''),
      videoUrl: json['link']?.toString(),
    );
  }

  String titleForLocale(Locale locale) {
    final lang = locale.languageCode.toLowerCase();
    if (lang == 'ar') return titleAr ?? title;
    if (lang == 'en') return titleEn ?? title;
    return title;
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
