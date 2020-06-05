
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/applications/applications_page.dart';
import 'package:ownspace/bookmanager/bloc/book.dart';
import 'package:ownspace/bookmanager/books/book_dialog.dart';
import 'package:ownspace/bookmanager/books/books_widget.dart';
import 'package:ownspace/bookmanager/charge_log/charge_log_widget.dart';
import 'package:ownspace/bookmanager/statistics/statistics_widget.dart';
import 'package:ownspace/bookmanager/to_read/to_read_dialog.dart';
import 'package:ownspace/bookmanager/to_read/to_read_widget.dart';
import 'package:ownspace/common/bloc/appbar_bloc.dart';

class BooksPage extends StatefulWidget {

  BooksPage({Key key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {

  GlobalKey<BooksWidgetState> _keyBooksWidget = GlobalKey();
  GlobalKey<ToReadWidgetState> _keyToReadWidget = GlobalKey();
  GlobalKey<ChargeLogWidgetState> _keyChargeLogWidget = GlobalKey();

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
            _selectedIndex < 3 ? FloatingActionButton(
                child: Icon(Icons.add),
                heroTag: "add_button",
                onPressed: () {
                  if (_selectedIndex == 0) {
                    _displayAddBookDialog();
                  } else if (_selectedIndex == 1) {
                    _displayAddToReadDialog();
                  } else if (_selectedIndex == 2) {
                    _keyChargeLogWidget.currentState.addEntry();
                  }
                }) : Container(),
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
            title: Text("", style: TextStyle(fontSize: 1)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            title: Text("", style: TextStyle(fontSize: 1)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full),
            title: Text("", style: TextStyle(fontSize: 1)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text("", style: TextStyle(fontSize: 1))
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
    if (ApplicationsPage.IS_IMPORT_VISIBLE) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            FloatingActionButton(
                child: Icon(Icons.import_export),
                heroTag: "import_button",
                onPressed: () => _displayImportDialog())
          ]);
    }
    return SizedBox();
  }

  void _displayAddBookDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BookDialog(onBookAdd: (book) {
            _keyBooksWidget.currentState.addBook(book);
          });
        }
    );
  }

  void _displayAddToReadDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ToReadDialog(onToReadAdd: (toRead) {
            _keyToReadWidget.currentState.addEntry(toRead);
          });
        }
    );
  }

  void _displayImportDialog() {
    Widget importView = Expanded(child:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Importing..."),
        CircularProgressIndicator()
      ],
    ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: BlocProvider(
                create: (context) => _bookBloc,
                child: BlocBuilder<BookBloc, BookState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return importView;
                      } else if (state is InitialState) {
                        _bookBloc.add(ImportBooks());
                        return importView;
                      } else if (state is Finished) {
                        return Text("Done");
                      } else if (state is Error) {
                        return Text("Error, while loading task: ${state.message}");
                      }
                      return importView;
                    })
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
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
      return BooksWidget(key: _keyBooksWidget);
    } else if (_selectedIndex == 1) {
      return ToReadWidget(key: _keyToReadWidget);
    } else if (_selectedIndex == 2) {
      return ChargeLogWidget(key: _keyChargeLogWidget);
    } else if (_selectedIndex == 3) {
      return StatisticsWidget();
    }
    return Container();
  }
}