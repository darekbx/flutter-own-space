import 'package:flutter/material.dart';
import 'package:ownspace/allegro_observer/allegro/allegro_categories.dart';
import 'package:ownspace/allegro_observer/allegro/model/category_wrapper.dart';
import 'package:ownspace/allegro_observer/allegro/model/category.dart';

class CategoryChoosePage extends StatefulWidget {
  CategoryChoosePage({Key key, this.openedCategory = null, this.index = 0})
      :super(key: key);

  final Category openedCategory;
  final int index;

  @override
  State<StatefulWidget> createState() => _CategoryChooseState();
}

class _CategoryChooseState extends State<CategoryChoosePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: _buildTitle()
        ),
        body: FutureBuilder(
            future: _buildCategoryFuture(),
            builder: (BuildContext context,
                AsyncSnapshot<CategoryWrapper> snapshot) {
              return _handleFuture(context, snapshot);
            })
    );
  }

  Widget _handleFuture(BuildContext context,
      AsyncSnapshot<CategoryWrapper> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return _buildListView(context, snapshot);
          }
        }
    }
  }

  _buildTitle() {
    if (widget.openedCategory == null) {
      return Text("Choose category");
    } else {
      return Text(widget.openedCategory.name);
    }
  }

  _buildCategoryFuture() {
    if (widget.openedCategory == null) {
      return AllegroCategories().getMainCategories();
    } else {
      return AllegroCategories().getCategories(widget.openedCategory.id);
    }
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

  _buildListView(BuildContext context,
      AsyncSnapshot<CategoryWrapper> snapshot) {
    CategoryWrapper wrapper = snapshot.data;
    return ListView.builder(
        itemCount: wrapper.categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: _buildListItem(context, wrapper.categories[index]),
              ),
              Divider(height: 2.0),
            ],
          );
        }
    );
  }

  void _openCategoryPage(BuildContext context, Category category,
      {bool forceLeaf = false}) {
    if (category.leaf || forceLeaf) {
      for (var i = 0; i <= widget.index; i++) {
        Navigator.pop(context, category);
      }
    }
    else {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              CategoryChoosePage(
                  openedCategory: category, index: widget.index + 1))
      );
    }
  }

  _buildListItem(BuildContext context, Category category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: GestureDetector(
                child: Text(category.name),
                onTap: () {
                  _openCategoryPage(context, category);
                })
        ),
        GestureDetector(
            child: _buildLeafIcon(category),
            onTap: () {
              _openCategoryPage(context, category, forceLeaf: true);
            })
      ],
    );
  }

  _buildLeafIcon(Category category) {
    if (category.leaf) {
      return Container();
    } else {
      return Icon(Icons.list);
    }
  }
}