import 'package:flutter/material.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../data/model/book_Model.dart';
import '../../cubit/textbooks_cubit.dart';
import '../screens/read_Book_Screen.dart';
import 'book_card_vertical.dart';

class BooksVerticalList extends StatelessWidget {
  final List<BookModel> books;

  const BooksVerticalList({super.key, required this.books});

  Future<void> _openBook(BuildContext context, BookModel book) async {
    final navigator = Navigator.of(context);
    BookModel target = book;

    if (book.id.isNotEmpty && book.chapters.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      try {
        final cubit = sl<TextBooksCubit>();
        target = await cubit.repo.getById(book.id);
      } catch (_) {
        // Fallback to the list item if the details call fails.
      } finally {
        if (navigator.canPop()) navigator.pop();
      }
    }

    await navigator.push(
      MaterialPageRoute(builder: (_) => ReadBookScreen(book: target)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,

      itemBuilder: (context, index) => GestureDetector(
        onTap: () => _openBook(context, books[index]),
        child: BookCardVertical(book: books[index]),
      ),
    );
  }
}
