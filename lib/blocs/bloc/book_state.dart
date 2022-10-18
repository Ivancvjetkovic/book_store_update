import 'package:book_store/book_model.dart';

enum BookStateStatus {
  initial,
  loading,
  loadedSuccess,
  loadedError,
}

class BookState {
  BookStateStatus? status;
  List<Book>? books;
  int? quantity;

  BookState({
    this.status,
    this.books,
    this.quantity,
  });

  BookState copyWith({
    BookStateStatus? status,
    List<Book>? books,
    int? quantity,
  }) =>
      BookState(
        status: status ?? this.status,
        books: books ?? this.books,
        quantity: quantity ?? this.quantity,
      );
}
