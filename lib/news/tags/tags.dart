import 'package:flutter/material.dart';
import 'package:ownspace/news/commonwidgets.dart';
import 'package:ownspace/news/repository/news_database_provider.dart';
import 'tag.dart';

class Tags extends StatefulWidget {
  Tags();

  Function reload;

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  var _tagFieldController = TextEditingController();

  void _addTagDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add new tag"),
            content: TextField(
              controller: _tagFieldController,
              decoration: InputDecoration(hintText: "Tag name without #"),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("Add"),
                  onPressed: () {
                    setState(() {
                      _addTag(_tagFieldController.text);
                      _tagFieldController.clear();
                    });
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  void _addTag(String tag) async {
    await NewsDatabaseProvider.instance.addTag(tag);
    if (widget.reload != null) {
      widget.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 8),
          child: FutureBuilder(
            future: NewsDatabaseProvider.instance.fetchTags(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return CommonWidgets.handleFuture(snapshot, (json) {
                return ListView.builder(
                  itemCount: (json as List<String>).length,
                  itemBuilder: (BuildContext context, index) =>
                      _tagItem((json as List<String>)[index]),
                );
              });
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTagDialog(context),
        tooltip: 'Add tag',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _tagItem(String tagName) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Tag(tagName),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16), child: Divider())
        ]);
  }
}
