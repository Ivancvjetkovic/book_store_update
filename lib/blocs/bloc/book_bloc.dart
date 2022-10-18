import 'package:book_store/blocs/bloc/book_event.dart';
import 'package:book_store/blocs/bloc/book_state.dart';
import 'package:book_store/http_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final HttpService bookRepository;
  BookBloc({
    required this.bookRepository,
  }) : super(initialState()) {
    on<BookLoadEvent>(_load);
  }

  static BookState initialState() {
    return BookState(
      status: BookStateStatus.initial,
      books: [],
      quantity: 10,
    );
  }

  Future<void> _load(BookLoadEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(status: BookStateStatus.loading));

    if (event.quantity != null) emit(state.copyWith(quantity: event.quantity));

    final result =
        await bookRepository.getBooks(quantity: event.quantity ?? 10);

    // ignore: unnecessary_null_comparison
    if (result != null) {
      emit(state.copyWith(
        status: BookStateStatus.loadedSuccess,
        books: result,
      ));
    } else {
      emit(state.copyWith(status: BookStateStatus.loadedError));
    }
  }
}
