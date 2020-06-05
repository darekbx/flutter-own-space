import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ownspace/allegro_observer/create_filter_page.dart';
import 'package:ownspace/allegro_observer/repository/repository.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/counter_widget.dart';
import 'package:ownspace/allegro_observer/items_page.dart';
import 'package:ownspace/allegro_observer/settings_page.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage({Key key}) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {

  final mediumScale = 0.8;
  final smallScale = 0.7;

  Repository repository;
  Future<List<Filter>> _filtersFuture;

  void _openCreateFilter(BuildContext context) async {
    var filter = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFilterPage()));
    if (filter != null) {
      await repository.addFilter(filter);
      _filtersFuture = repository.fetchFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allegro Observer"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage())
                );
              },
            )
        ],
      ),
      body: FutureBuilder(
        future: _filtersFuture = _loadFilters(),
        builder: (BuildContext context, AsyncSnapshot<List<Filter>> snapshot) {
          return _handleFuture(context, snapshot);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openCreateFilter(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Filter>> _loadFilters() async {
    if (repository == null) {
      repository = Repository();
      await repository.open();
    }
    await Future.delayed(Duration(milliseconds: 200));
    return repository.fetchFilters();
  }

  Widget _handleFuture(BuildContext context,
      AsyncSnapshot<List<Filter>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.data == null || snapshot.data.isEmpty) {
          return _buildEmptyView();
        } else {
          return _buildFiltersList(context, snapshot.data);
        }
    }
  }

  Widget _buildFiltersList(BuildContext context, List<Filter> filters) {
    return ListView.builder(
      itemCount: filters.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
                title: _buildListItem(context, filters[index])
            ),
            Divider(height: 2.0),
          ],
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, Filter filter) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  ItemsPage(filter: filter))
          );
        },
        onLongPress: () {
          deleteDialog(context, filter);
        },
        child: Padding(padding: EdgeInsets.all(8),child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("[${filter.category.name}] ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: mediumScale,
                        ),
                        _buildKeyword(filter),
                        _buildCheckboxes(filter)
                      ],
                    ),
                    Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: _buildPrice(filter)
                          )
                        ]
                    )
                  ]
              ),
              _buildCounter(filter)
            ]))
    );
  }

  void _progressDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[CircularProgressIndicator()]
            )
          );
        }
    );

  }

  void deleteDialog(BuildContext context, Filter filter) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Delete filter?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _deleteFilter(filter);
                    Navigator.of(context).pop();
                    setState(() {
                      _filtersFuture = _loadFilters();
                    });
                  }
              )
            ],
          );
        }
    );
  }

  void _deleteFilter(Filter filter) async {
    await repository.deleteFilter(filter.id);
    _filtersFuture = repository.fetchFilters();
  }

  Widget _buildCounter(Filter filter) {
    return CounterWidget(filter);
  }

  Widget _buildKeyword(Filter filter) {
    if (filter.hasKeyword()) {
      return
        Row(
            children: <Widget>[
              Text(
                  "\"${filter.keyword}\"",
                  textScaleFactor: mediumScale
              ),
              Padding(
                  padding: EdgeInsets.only(left: 2.0)
              )
            ]);
    } else {
      return Container();
    }
  }

  Widget _buildPrice(Filter filter) {
    String value = "";
    if (filter.hasPriceFrom() && filter.hasPriceTo()) {
      value =
      "Price from ${filter.priceFromInt()}zł to ${filter.priceToInt()}zł";
    } else if (filter.hasPriceFrom()) {
      value = "Price from ${filter.priceFromInt()}zł";
    } else if (filter.hasPriceTo()) {
      value = "Price to ${filter.priceToInt()}zł";
    } else {
      return Container();
    }
    return Text(value, textScaleFactor: smallScale);
  }

  Widget _buildCheckboxes(Filter filter) {
    String text = filter.searchUsed
        ? "(Used"
        : "(New";
    if (filter.searchNew && filter.searchUsed) {
      if (filter.searchInDescription) {
        text = "(In description";
      }
      else {
        return Container();
      }
    }
    if (filter.searchInDescription) {
      text += ", In description";
    }
    return Text("$text)", textScaleFactor: mediumScale);
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Text("No filters"),
    );
  }
}