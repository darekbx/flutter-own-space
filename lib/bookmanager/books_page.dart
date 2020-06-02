
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/bookmanager/bloc/book.dart';
import 'package:ownspace/bookmanager/books/books_widget.dart';
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text("")
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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
    if (_selectedIndex == 0) {
      return BooksWidget();
    }

    return Container();
  }
}