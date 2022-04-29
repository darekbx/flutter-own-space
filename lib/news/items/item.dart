import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ownspace/news/api/api.dart';
import 'package:ownspace/news/repository/localstorage.dart';
import 'package:ownspace/news/commonwidgets.dart';
import 'entryhelper.dart';

class Item extends StatefulWidget {
  final int itemId;
  final String type;
  final entryHelper = EntryHelper();

  Item(this.itemId, this.type);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  var _localStorage = LocalStorage();
  var _apiKey;
  var _apiSecret;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    var future;
    var title;
    if (widget.type == "entry") {
      title = "Entry id: ${widget.itemId}";
      future = Api(_apiKey, _apiSecret).loadEntry(widget.itemId);
    } else {
      title = "Link id: ${widget.itemId}";
      future = Api(_apiKey, _apiSecret).loadLink(widget.itemId);
    }
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Padding(
          padding: EdgeInsets.only(top: 8),
          child: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return CommonWidgets.handleFuture(snapshot, (jsonString) {
                var json = JsonDecoder().convert(jsonString);
                return _buildCommentsList(context, json["data"]);
              });
            })));
  }

  Widget _buildHeader(BuildContext context, dynamic data) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.entryHelper
              .buildItem(context, data, widget.type, hideComments: true),
          Divider(color: Colors.black)
        ]);
  }

  Widget _buildCommentsList(BuildContext context, dynamic data) {
    var comments = data["comments"];
    if (comments == null || comments.length == 0) {
      return Center(child: Text("No comments"));
    }
    return ListView.builder(
        itemCount: comments.length + 1,
        itemBuilder: (BuildContext context, index) {
          if (index == 0) {
            return _buildHeader(context, data);
          }

          var comment = comments[index - 1];
          return _buildSingleComment(comment);
        });
  }

  Widget _buildSingleComment(dynamic comment) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          child: Text(comment["date"],
                              style: TextStyle(color: Colors.black45))),
                      Text(comment["author"]["login"],
                          style: TextStyle(color: Colors.black45))
                    ],
                  )),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.entryHelper.createEmbed(comment["embed"]),
                    widget.entryHelper.handleHtml(context, comment["body"])
                  ]),
              Divider(color: Colors.black45)
            ]));
  }
}
