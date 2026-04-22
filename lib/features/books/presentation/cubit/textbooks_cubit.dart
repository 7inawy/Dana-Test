import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/repo/textbooks_repo.dart';
import 'textbooks_state.dart';

class TextBooksCubit extends Cubit<TextBooksState> {
  final TextBooksRepo repo;

  TextBooksCubit(this.repo) : super(const TextBooksInitial());

  Future<void> load() async {
    emit(const TextBooksLoading());
    try {
      final books = await repo.getTextBooks();
      emit(TextBooksLoaded(books));
    } catch (e) {
      emit(TextBooksError(ErrorMapper.message(e)));
    }
  }

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      emit(const TextBooksSearchLoaded([]));
      return;
    }
    emit(const TextBooksLoading());
    try {
      final results = await repo.search(q);
      emit(TextBooksSearchLoaded(results));
    } catch (e) {
      emit(TextBooksError(ErrorMapper.message(e)));
    }
  }
}
