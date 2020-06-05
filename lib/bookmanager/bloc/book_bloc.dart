import 'package:bloc/bloc.dart';
import 'package:ownspace/bookmanager/bloc/book_event.dart';
import 'package:ownspace/bookmanager/bloc/book_state.dart';
import 'package:ownspace/bookmanager/model/book.dart';
import 'package:ownspace/bookmanager/repository/books_repository.dart';

class BookBloc extends Bloc<BookEvent, BookState> {

  BooksRepository _booksRepository = BooksRepository();

  @override
  BookState get initialState => InitialState();

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    try {
      if (event is ListBooks) {
        List<Book> books = await _booksRepository.fetchBooks();
        yield ListFinished(books);
      } else if (event is AddBook) {
        yield Loading();
        await _booksRepository.addBook(event.book);
        yield Finished();
      } else if (event is DeleteBook) {
        yield Loading();
        await _booksRepository.deleteBook(event.book);
        yield Finished();
      } else if (event is UpdateBook) {
        yield Loading();
        await _booksRepository.updateBook(event.book);
        yield Finished();
      } else if (event is ImportBooks) {
        yield Loading();
        await _booksRepository.import();
        yield Finished();
      } else if (event is LoadYearSummary) {
        yield Loading();
        var result = await _booksRepository.yearStatistics();
        yield YearSummaryFinished(result);
      }
    } on Exception catch (e) {
      yield Error(e.toString());
    }
  }
}