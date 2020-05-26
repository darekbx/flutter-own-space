import 'package:flutter/material.dart';
import 'package:ownspace/news/repository/news_database_provider.dart';
import 'package:ownspace/news/commonwidgets.dart';
import 'package:ownspace/news/model/savedlink.dart';
import 'package:ownspace/news/items/entryhelper.dart';
import 'package:ownspace/news/items/item.dart';

class SavedLinks extends StatefulWidget {
  SavedLinks();

  final EntryHelper entryHelper = EntryHelper();

  @override
  _SavedLinksState createState() => _SavedLinksState();
}

class _SavedLinksState extends State<SavedLinks> {
  int count = 0;
  var _links = List<SavedLink>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(16),
            child: FutureBuilder(
              future: _fetchSavedLinks(),
              builder: (BuildContext contet, AsyncSnapshot<dynamic> snapshot) {
                return CommonWidgets.handleFuture(snapshot, (data) {
                  _links = data;
                  if (_links.length == 0) {
                    return Center(child: Text("Empty list"));
                  } else {
                    return _buildItemsList(context);
                  }
                });
              },
            )));
  }

  Widget _buildItemsList(BuildContext context) {
    return ListView.builder(
      itemCount: _links.length,
      itemBuilder: (BuildContext context, index) =>
          _buildItem(context, _links[index]),
    );
  }

  Widget _buildItem(BuildContext context, SavedLink link) {
    var image = link.imageUrl;
    if (image != null) {
      image = widget.entryHelper.prepareImage(image);
    }
    return InkWell(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(link.title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Image.network(image),
            Padding(
                padding: EdgeInsets.only(top: 8),
                child:
                    widget.entryHelper.handleHtml(context, link.description)),
            Divider()
          ]),
      onTap: () => _openLink(link),
      onLongPress: () => _removeLink(link),
    );
  }

  _openLink(SavedLink link) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Item(link.linkId, "link");
    }));
  }

  _removeLink(SavedLink link) async {
    await NewsDatabaseProvider.instance.delete(link.id);
    var links = await _fetchSavedLinks();
    setState(() {
      _links = links;
    });
  }

  _fetchSavedLinks() async => await NewsDatabaseProvider.instance.list();
}
