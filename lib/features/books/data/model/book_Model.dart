// ============================================================
// MODEL
// ============================================================
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../l10n/app_localizations.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String? description;
  final List<BookChapter> chapters;
  final int? pagesCount;
  final String? publishYear;
  final String? link;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.description,
    this.chapters = const [],
    this.pagesCount,
    this.publishYear,
    this.link,
  });

  int get pageCount =>
      chapters.isNotEmpty ? chapters.length : (pagesCount ?? 0);

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final chaptersJson = json['chapters'];
    final parsedChapters = chaptersJson is List
        ? chaptersJson
              .whereType<Map>()
              .map((e) => e.cast<String, dynamic>())
              .map(
                (e) => BookChapter(
                  title: e['title']?.toString() ?? '',
                  body: (e['body'] ?? e['content'] ?? e['text'] ?? '')
                      .toString(),
                ),
              )
              .toList()
        : const <BookChapter>[];

    int? parsedPagesCount;
    for (final key in const <String>[
      'pagesCount',
      'pageCount',
      'pages',
      'numberOfPages',
      'page_count',
    ]) {
      final v = json[key];
      if (v is num) {
        parsedPagesCount = v.toInt();
        break;
      }
      if (v is String) {
        final n = int.tryParse(v.trim());
        if (n != null) {
          parsedPagesCount = n;
          break;
        }
      }
      if (v is List) {
        parsedPagesCount = v.length;
        break;
      }
    }

    return BookModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      imageUrl: (json['cover'] ?? '').toString(),
      description: json['description']?.toString(),
      link: json['link']?.toString(),
      chapters: parsedChapters,
      pagesCount: parsedPagesCount,
      publishYear: null,
    );
  }
}

class BookChapter {
  final String title;
  final String body;

  const BookChapter({required this.title, required this.body});
}

List<BookModel> getFeaturedBooks(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    BookModel(
      id: '',
      title: l10n.bookSensoryIntegrationTitle,
      author: l10n.bookSensoryIntegrationAuthor,
      imageUrl: AppAssets.book_3,
      publishYear: '2020',
      description: l10n.bookSensoryIntegrationDesc,
      chapters: [
        BookChapter(
          title: l10n.bookSensoryChapter1Title,
          body: l10n.bookSensoryChapter1Body,
        ),
        BookChapter(
          title: l10n.bookSensoryChapter2Title,
          body: l10n.bookSensoryChapter2Body,
        ),
      ],
    ),
    BookModel(
      id: '',
      title: l10n.bookAsyncChildTitle,
      author: l10n.bookAsyncChildAuthor,
      imageUrl: AppAssets.book_two,
      publishYear: '2021',
      description: l10n.bookAsyncChildDesc,
      chapters: [
        BookChapter(
          title: l10n.bookAsyncChapter1Title,
          body: l10n.bookAsyncChapter1Body,
        ),
        BookChapter(
          title: l10n.bookAsyncChapter2Title,
          body: l10n.bookAsyncChapter2Body,
        ),
      ],
    ),
    BookModel(
      id: '',
      title: l10n.bookSensorySignalsTitle,
      author: l10n.bookSensorySignalsAuthor,
      imageUrl: AppAssets.book_one,
      publishYear: '2022',
      description: l10n.bookSensorySignalsDesc,
      chapters: [
        BookChapter(
          title: l10n.bookSensorySignalsChapter1Title,
          body: l10n.bookSensorySignalsChapter1Body,
        ),
        BookChapter(
          title: l10n.bookSensorySignalsChapter2Title,
          body: l10n.bookSensorySignalsChapter2Body,
        ),
      ],
    ),
  ];
}

List<BookModel> getGuideBooks(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    BookModel(
      id: '',
      title: l10n.bookSensorySignalsTitle,
      author: l10n.bookGuide1Author,
      imageUrl: AppAssets.book_4,
      publishYear: '2022',
      description: l10n.bookGuide1Desc,
      chapters: [
        BookChapter(
          title: l10n.bookGuide1Chapter1Title,
          body: l10n.bookGuide1Chapter1Body,
        ),
        BookChapter(
          title: l10n.bookGuide1Chapter2Title,
          body: l10n.bookGuide1Chapter2Body,
        ),
      ],
    ),
    BookModel(
      id: '',
      title: l10n.bookBodyLanguageTitle,
      author: l10n.bookBodyLanguageAuthor,
      imageUrl: AppAssets.book_5,
      publishYear: '2021',
      description: l10n.bookBodyLanguageDesc,
      chapters: [
        BookChapter(
          title: l10n.bookBodyLanguageChapter1Title,
          body: l10n.bookBodyLanguageChapter1Body,
        ),
      ],
    ),
    BookModel(
      id: '',
      title: l10n.bookAngerTitle,
      author: l10n.bookAngerAuthor,
      imageUrl: AppAssets.book_6,
      publishYear: '2023',
      description: l10n.bookAngerDesc,
      chapters: [
        BookChapter(
          title: l10n.bookAngerChapter1Title,
          body: l10n.bookAngerChapter1Body,
        ),
      ],
    ),
    BookModel(
      id: '',
      title: l10n.bookEmotionsTitle,
      author: l10n.bookEmotionsAuthor,
      imageUrl: AppAssets.book_7,
      publishYear: '2022',
      description: l10n.bookEmotionsDesc,
      chapters: [
        BookChapter(
          title: l10n.bookEmotionsChapter1Title,
          body: l10n.bookEmotionsChapter1Body,
        ),
      ],
    ),
  ];
}

List<BookModel> getAllBooks(BuildContext context) => [
  ...getFeaturedBooks(context),
  ...getGuideBooks(context),
];
