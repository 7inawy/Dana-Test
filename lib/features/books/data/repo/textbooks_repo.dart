import '../model/book_Model.dart';
import '../services/textbooks_service.dart';

class TextBooksRepo {
  final TextBooksService service;

  TextBooksRepo(this.service);

  Future<List<BookModel>> getTextBooks() => service.getTextBooks();

  Future<BookModel> getById(String id) => service.getById(id);

  Future<List<BookModel>> search(String q) => service.search(q);
}
