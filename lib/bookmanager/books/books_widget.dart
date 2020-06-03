
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/bookmanager/bloc/book.dart';
import 'package:ownspace/bookmanager/books/book_dialog.dart';
import 'package:ownspace/bookmanager/model/book.dart';

class BooksWidget extends StatefulWidget {

  BooksWidget({Key key}) : super(key: key);

  @override
  BooksWidgetState createState() => BooksWidgetState();
}

class BooksWidgetState extends State<BooksWidget> {

  final double _flagWidth = 4;
  final double _flagHeight = 48;

  TextEditingController _searchController;
  String _searchQuery;
  int _index = 1;
  BookBloc _bookBloc;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    _bookBloc = BookBloc();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  void addBook(Book book) {
    _bookBloc.add(AddBook(book));
  }

  Widget _buildBody() {
    return BlocProvider(
        create: (context) => _bookBloc,
        child: BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialState) {
                _bookBloc.add(ListBooks());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                _bookBloc.add(ListBooks());
                return _showStatus("Finished");
              } else if (state is Error) {
                return _showStatus("Error, while loading task: ${state.message}");
              } else if (state is ListFinished) {
                return _buildList(state.books);
              }
            })
    );
  }

  Widget _buildList(List<Book> books) {

    if (books.isEmpty) {
      return Center(
        child: Text("Nothing found"),
      );
    }

    _index = books.length;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              height: 44,
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 4),
                    hintText: "Search",
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))
                ),
                controller: _searchController,
              )),
        ),
        Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 8, right: 8),
              itemCount: books.length,

              itemBuilder: (context, index) {
                Book book = books[index];
                int nextYear = index + 1 < books.length ? books[index + 1].year : null;
                if (_searchQuery != null && _searchQuery.length > 1) {
                  var hasAuthor = book.author.toLowerCase().contains(_searchQuery);
                  var hasTitle = book.title.toLowerCase().contains(_searchQuery);
                  if (hasAuthor || hasTitle) {
                    return _buildListItem(book, queryToMark: _searchQuery);
                  } else {
                    return Container();
                  }
                } else {
                  return _buildListItem(book, nextYear: nextYear);
                }
              },
            )
        )
      ],
    );
  }

  Widget _buildListItem(Book book, {int nextYear: null, String queryToMark: null}) {
    Divider divider = Divider(color: Colors.black, height: 1, thickness: 0.15);

    if (nextYear != null && nextYear != book.year) {
      divider = Divider(color: Colors.red, height: 1, thickness: 0.75);
    }

    Widget authorWidget = Text(book.author, style: TextStyle(fontWeight: FontWeight.bold));
    Widget titleWidget = Text(book.title);

    if (queryToMark != null) {
      if (book.author.toLowerCase().contains(queryToMark)) {
        authorWidget = createMarkedText(book.author, queryToMark, isBold: true);
      }
      if (book.title.toLowerCase().contains(queryToMark)) {
        titleWidget = createMarkedText(book.title, queryToMark);
      }
    }

    return InkWell(
        onLongPress: () => _deleteDialog(book),
        onTap: () => _displayAddBookDialog(book),
        child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _createIsKindleContainer(book),
                          createOpinionContainer(book),
                          _createIsInEnglishContainer(book),
                          Container(width: 6)
                        ]
                    ),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            authorWidget,
                            titleWidget,
                          ],
                        )),
                    Column(
                      children: <Widget>[
                        Text("${_index--}.", style: TextStyle(fontSize: 12)),
                        Container(height: 8),
                        Text("${book.year}", style: TextStyle(fontSize: 9))
                      ],
                    ),
                  ]
              ),
              divider,
            ])
    );
  }

  Widget createMarkedText(String text, String queryToMark, {bool isBold: false}) {
    int start = text.toLowerCase().indexOf(queryToMark);
    int end = start + queryToMark.length;
    
    String prefix = text.substring(0, start);
    String toMark = text.substring(start, end);
    String sufix = text.substring(end);
    
    return Text.rich(
      TextSpan(
        style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        text: prefix,
        children: <TextSpan>[
          TextSpan(text: toMark, style: TextStyle(color: Colors.orange)),
          TextSpan(text: sufix),
        ],
      ),
    );
  }

  Container _createIsInEnglishContainer(Book book) {
    return book.isInEnglish()
        ? Container(width: _flagWidth, height: _flagHeight, color: Color.fromARGB(255, 0, 36, 125))
        : _defaultContainer();
  }

  Container createOpinionContainer(Book book) {
    if (book.isGood()) {
      return Container(width: _flagWidth,
          height: _flagHeight,
          color: Color.fromARGB(255, 68, 147, 142));
    }
    else if (book.isBest()) {
      return Container(width: _flagWidth,
          height: _flagHeight,
          color: Color.fromARGB(255, 255, 77, 75));
    }
    else {
      return _defaultContainer();
    }
  }

  Container _createIsKindleContainer(Book book) {
    return book.isFromKindle()
        ? Container(width: _flagWidth, height: _flagHeight, color: Color.fromARGB(255, 143, 193, 98))
        : _defaultContainer();
  }

  Container _defaultContainer() => Container(width: _flagWidth);

  void _displayAddBookDialog(Book book) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BookDialog(book: book, onBookAdd: (book) {
            debugPrint("Update book ${book.id} ${book.title}");
            _bookBloc.add(UpdateBook(book));
          });
        }
    );
  }

  void _deleteDialog(Book book) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Delete book: ${book.author} (${book.title})?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _bookBloc.add(DeleteBook(book));
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}