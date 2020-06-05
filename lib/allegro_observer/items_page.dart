import 'package:flutter/material.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/allegro/model/listing_wrapper.dart';
import 'package:ownspace/allegro_observer/allegro/model/items_wrapper.dart';
import 'package:ownspace/allegro_observer/allegro/model/item.dart';
import 'package:ownspace/allegro_observer/allegro/allegro_search.dart';
import 'package:ownspace/allegro_observer/forward_page.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({Key key, this.filter}) : super(key: key);

  final Filter filter;

  @override
  State<StatefulWidget> createState() => _ItemsPageSate();
}

class _ItemsPageSate extends State<ItemsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
      ),
      body: FutureBuilder(
          future: AllegroSearch().search(widget.filter, onlyNew: true),
          builder: (BuildContext context,
              AsyncSnapshot<ListingWrapper> snapshot) {
            return _handleShapshot(context, snapshot);
          }),
    );
  }

  Widget _handleShapshot(BuildContext context,
      AsyncSnapshot<ListingWrapper> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.data == null) {
          return _buildError("Error :( ?");
        } else {
          return _buildListView(context, snapshot.data.items);
        }
    }
  }

  _buildListView(BuildContext context, ItemsWrapper wrapper) {
    List<Item> items = [];
    items.addAll(wrapper.regular);
    items.addAll(wrapper.promoted);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: _buildListItem(context, items[index], index),
            ),
            Divider(height: 2.0),
          ],
        );
      },
    );
  }

  _buildListItem(BuildContext context, Item item, int index) {
    String image = "";
    if (item.images != null && item.images.length > 0) {
      image = item.images[0].url;
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              ForwardPage(url: item.url)));
        },
        child:
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: 80.0,
                      height: 80.0
                  )
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Text(
                              "${item.name}",
                              overflow: TextOverflow.ellipsis
                          )
                      ),
                      Text(
                          "${item.priceFormatted()}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis
                      ),
                      Padding(padding: EdgeInsets.only(top: 38.0)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                "[${item.id}]",
                                style: TextStyle(fontSize: 12.0)),
                            Text(
                                "${index+1}.",
                                style: TextStyle(fontSize: 12.0))
                          ])
                    ],
                  ))
            ]
        )
    );
  }

  _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError(String errorMessage) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(errorMessage),
    );
  }
}