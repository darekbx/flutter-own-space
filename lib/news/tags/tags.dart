import 'package:flutter/material.dart';
import 'package:ownspace/news/api/api.dart';
import 'package:ownspace/news/commonwidgets.dart';
import 'package:ownspace/news/repository/localstorage.dart';
import 'package:ownspace/news/repository/news_database_provider.dart';
import 'tag.dart';

class Tags extends StatefulWidget {
  Tags();

  Function reload;

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {

  var _localStorage = LocalStorage();
  var _apiKey;
  var _tagFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  void _loadApiKey() async {
    var apiKey = await _localStorage.getApiKey();
    setState(() {
      _apiKey = apiKey;
    });
  }

  void _addTagDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add new tag"),
            content:
            FutureBuilder(
              future: Api(_apiKey).loadPopularTags(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                return CommonWidgets.handleFuture(snapshot, (json) {
                  return Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return snapshot.data.map((item) => "$item").where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode, VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          decoration: InputDecoration(hintText: "Tag name without #"),
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                            //_tagFieldController.text = value; TODO remove or uncomment?
                          },
                        );
                      },
                      onSelected: (String selection) {
                        _tagFieldController.text = selection;
                      }
                    //controller: _tagFieldController,
                    //decoration: InputDecoration(hintText: "Tag name without #"),
                  );
                });
              },
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
