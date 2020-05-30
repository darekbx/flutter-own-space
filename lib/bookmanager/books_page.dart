
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/bookmanager/bloc/book.dart';
import 'package:ownspace/common/bloc/appbar_bloc.dart';

class BooksPage extends StatefulWidget {

  final IS_IMPORT_VISIBLE = true;

  BooksPage({Key key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {

  BookBloc _bookBloc;
  AppBarBloc _appBarBloc;

  @override
  void initState() {
    _bookBloc = BookBloc();
    _appBarBloc = AppBarBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle()),
      floatingActionButton:
      Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildImportButton()
          ]),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: _buildBody()
      ),
    );
  }

  Widget _buildImportButton() {
    if (widget.IS_IMPORT_VISIBLE) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            FloatingActionButton(
                child: Icon(Icons.import_export),
                heroTag: "import_button",
                onPressed: () async {
                  _bookBloc.add(ImportBooks());
                })
          ]);
    }
    return SizedBox();
  }

  Widget _buildTitle() {
    return StreamBuilder<Object>(
        stream: _appBarBloc.titleStream,
        initialData: "Books",
        builder: (context, value) {
          return Text("${value.data}");
        }
    );
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

                _appBarBloc.updateTitle("Count: ${state.books.length}");
                return _showStatus("List Finished?");
              }
            })
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}