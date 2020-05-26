import 'package:flutter/material.dart';
import 'package:ownspace/news/repository/localstorage.dart';
import 'entryhelper.dart';
import 'dart:convert';
import 'package:ownspace/news/api/api.dart';
import 'package:ownspace/news/commonwidgets.dart';

class ItemsList extends StatefulWidget {
  final dynamic data;
  final String tagName;
  final entryHelper = EntryHelper();

  ItemsList(this.data, this.tagName);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  ScrollController _scrollController;
  var _localStorage = LocalStorage();
  var _apiKey;
  var _nextPageData;
  List<dynamic> _itemsList;

  @override
  void initState() {
    _itemsList = widget.data["data"] as List<dynamic>;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() async {
    var apiKey = await _localStorage.getApiKey();
    setState(() {
      _apiKey = apiKey;
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadNextPage();
    }
  }

  void _loadNextPage() async {
    CommonWidgets.showLoadingDialog(context);
    var data = getData();
    var pagination = data["pagination"];
    if (pagination != null && pagination["next"] != null) {
      var nextPageData = await Api(_apiKey).loadUrl(pagination["next"]);
      setState(() {
        _nextPageData = JsonDecoder().convert(nextPageData);
        _itemsList.addAll(_nextPageData["data"] as List<dynamic>);
        Navigator.pop(context);
      });
    }
  }

  dynamic getData() => _nextPageData != null ?_nextPageData : widget.data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("#${widget.tagName}")),
        body: Padding(
            padding: EdgeInsets.only(top: 8),
            child: ListView.separated(
              controller: _scrollController,
              separatorBuilder: (BuildContext context, index) =>
                  Divider(color: Colors.black),
              itemCount: _itemsList.length,
              itemBuilder: (BuildContext context, index) =>
                  _buildItem(context, _itemsList[index]),
            )));
  }

  Widget _buildItem(BuildContext context, dynamic row) {
    var type = row["type"];
    if (type == "entry") {
      return widget.entryHelper.buildEntry(context, row["entry"]);
    } else if (type == "link") {
      return widget.entryHelper.buildLink(context, row["link"]);
    }
    return Text("Unknown type");
  }
}
