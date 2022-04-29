import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ownspace/news/repository/localstorage.dart';
import 'package:ownspace/news/api/api.dart';
import 'package:ownspace/news/commonwidgets.dart';
import 'package:ownspace/news/items/entryhelper.dart';
import 'package:ownspace/news/repository/news_database_provider.dart';
import 'package:ownspace/news/model/savedlink.dart';

class NewsFeed extends StatefulWidget {
  final entryHelper = EntryHelper();

  NewsFeed();

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  ScrollController _scrollController;
  var _localStorage = LocalStorage();
  var _forceRefresh = false;
  var _apiKey;
  var _apiSecret;
  var _paginationInfo;
  var _errorMessage;
  List<dynamic> _itemsList;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() async {
    var apiKey = await _localStorage.getApiKey();
    var apiSecret = await _localStorage.getApiSecret();
    setState(() {
      _apiKey = apiKey;
      _apiSecret = apiSecret;
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadNextPage();
    }
  }

  void _loadNextPage() async {
    var startPosition = _scrollController.position.pixels;
    CommonWidgets.showLoadingDialog(context);
    if (_paginationInfo != null && _paginationInfo["next"] != null) {
      var nextPageData = await Api(_apiKey, _apiSecret).loadUrl(_paginationInfo["next"]);
      setState(() {
        _appendToList(nextPageData);

        Future.delayed(Duration(microseconds: 10)).then((a) {
          setState(() {
            _scrollController.jumpTo(startPosition);
          });
        });

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_itemsList == null) {
      return FutureBuilder(
          future: Api(_apiKey, _apiSecret).loadPromotedLinks(forceRefresh: _forceRefresh),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return CommonWidgets.handleFuture(snapshot, (data) {
              _itemsList = List();
              _forceRefresh = false;
              _appendToList(data);
              return _buildList(context);
            });
          });
    } else {
      return _buildList(context);
    }
  }

  _appendToList(String jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      _errorMessage = "Empty data!";
      return;
    }
    var json = JsonDecoder().convert(jsonString);
    if (json["error"] != null) {
      _errorMessage = json["error"]["message_en"];
      return;
    } else {
      _itemsList.addAll(json["data"] as List);
      _paginationInfo = json["pagination"];
      _errorMessage = null;
    }
  }

  Widget _buildList(BuildContext context) {
    if (_errorMessage != null) {
      return _errorView(_errorMessage);
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _itemsList.length,
      itemBuilder: (BuildContext context, index) => InkWell(
            child: widget.entryHelper
                .buildLink(context, _itemsList[index], extended: true),
            onLongPress: () async {
              var link = _itemsList[index];
              _saveLink(link);

              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Link ${link["id"]} added")
              ));
            },
          ),
    );
  }

  Widget _errorView(String message) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(child: Text(message, style: TextStyle(color: Colors.red))),
        FlatButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _forceRefresh = true;
            });
          },
        )
      ]);

  void _saveLink(dynamic link) async {
    var savedLink = SavedLink(
        null, link["id"], link["title"], link["description"], link["preview"]);
    await NewsDatabaseProvider.instance.add(savedLink);
  }
}
