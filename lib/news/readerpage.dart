import 'package:flutter/material.dart';
import 'package:ownspace/news/newsfeed/newsfeed.dart';
import 'package:ownspace/news/tags/tags.dart';
import 'package:ownspace/news/savedlinks/savedlinks.dart';
import 'package:ownspace/news/repository/localstorage.dart';
import 'package:ownspace/news/settings/settings.dart';
import 'repository/news_database_provider.dart';
import 'commonwidgets.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key}) : super(key: key);

  final _localStorage = LocalStorage();

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage>
    with SingleTickerProviderStateMixin {
  NewsFeed _newsFeed = NewsFeed();
  SavedLinks _savedLinks = SavedLinks();
  Tags _tags = Tags();

  int _tagsCount = 0;
  int _savedLinksCount = 0;
  List<Tab> _tabs;
  TabController _tabController;

  @override
  void initState() {
    _initializeTabController();
    _tags.reload = () => _reloadCounters();
    _reloadCounters();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reloadCounters() async {
       var tagsCount = await _loadTagsCount();
       var savedLinksCount = await _loadSavedLinksCount();
      setState(() {
        _tagsCount = tagsCount;
        _savedLinksCount = savedLinksCount;
        _loadTabs();
      });
  }

  Future<Widget> _checkApiKeyAndBuild(BuildContext context) async {
    if (await widget._localStorage.getApiKey() == null) {
      return Scaffold(
          appBar: AppBar(
              title: Text("Reader"),
              actions: <Widget>[_buildSettingsAction(context)]),
          body: Center(
              child:
                  Text("No api key, please provide key in settings screen.")));
    } else {
      return _buildPage(context);
    }
  }

  Future<int> _loadTagsCount() async {
    return await NewsDatabaseProvider.instance.countTags();
  }

  Future<int> _loadSavedLinksCount() async {
    var list = await NewsDatabaseProvider.instance.list();
    return list.length;
  }

  void _initializeTabController() {
    _loadTabs();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkApiKeyAndBuild(context),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          return CommonWidgets.handleFuture(snapshot, (data) {
            return data;
          });
        });
  }

  Widget _buildPage(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Reader"),
              actions: <Widget>[_buildSettingsAction(context)],
              bottom: TabBar(controller: _tabController, tabs: _tabs),
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[_newsFeed, _tags, _savedLinks],
            )));
  }

  Widget _buildSettingsAction(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Settings()));
      },
    );
  }

  void _loadTabs() {
    _tabs = <Tab>[
      Tab(text: "News feed"),
      Tab(text: "Tags ($_tagsCount)"),
      Tab(text: "Saved links ($_savedLinksCount)"),
    ];
  }
}
