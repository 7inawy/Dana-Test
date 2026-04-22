import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';
import '../../../../core/api/response_unwrap.dart';
import '../model/book_Model.dart';

class TextBooksService {
  final Dio dio;

  TextBooksService(this.dio);

  Future<List<BookModel>> getTextBooks() async {
    final res = await dio.get(ApiEndpoint.textBooks);
    final list = ResponseUnwrap.unwrapList(res.data);
    return list
        .whereType<Map>()
        .map((e) => BookModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<BookModel> getById(String id) async {
    final res = await dio.get('${ApiEndpoint.bookById}$id');
    final map = ResponseUnwrap.unwrapMap(res.data);
    return BookModel.fromJson(map.cast<String, dynamic>());
  }

  Future<List<BookModel>> search(String query) async {
    final res = await dio.get(
      ApiEndpoint.textBooksSearch,
      queryParameters: {'q': query},
    );
    final list = ResponseUnwrap.unwrapList(res.data);
    return list
        .whereType<Map>()
        .map((e) => BookModel.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
