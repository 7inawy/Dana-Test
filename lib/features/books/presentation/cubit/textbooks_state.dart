import '../../data/model/book_Model.dart';

sealed class TextBooksState {
  const TextBooksState();
}

class TextBooksInitial extends TextBooksState {
  const TextBooksInitial();
}

class TextBooksLoading extends TextBooksState {
  const TextBooksLoading();
}

class TextBooksLoaded extends TextBooksState {
  final List<BookModel> books;
  const TextBooksLoaded(this.books);
}

class TextBooksSearchLoaded extends TextBooksState {
  final List<BookModel> results;
  const TextBooksSearchLoaded(this.results);
}

class TextBooksError extends TextBooksState {
  final String message;
  const TextBooksError(this.message);
}
