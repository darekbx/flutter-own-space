/**
 * Universal reader for:
 *  - Hackaday (https://hackaday.com/blog/feed/)
 *  - News y combinator (https://news.ycombinator.com/rss)
 *  - Tu Stolica (https://tustolica.pl/rss)
 *  - Others
 *
 * Each source interhits by common interface.
 *
 * Common model:
 *  - Source name
 *  - Title
 *  - Url
 *  - ImageUrl?
 *  - Short text?
 *
 * List is containing news from all sources, with scroll to next page
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/reader/bloc/reader.dart';
import 'package:ownspace/reader/model/newsitem.dart';
import 'package:ownspace/sugar/own_space_date_utils.dart';

class NewsReaderPage extends StatefulWidget {
  NewsReaderPage({Key key}) : super(key: key);

  @override
  _NewsReaderPageState createState() => _NewsReaderPageState();
}

class _NewsReaderPageState extends State<NewsReaderPage> {
  ReaderBloc _readerBloc;

  @override
  void initState() {
    _readerBloc = ReaderBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Reader")),
        body: BlocProvider(
          create: (context) => _readerBloc,
          child: BlocBuilder<ReaderBloc, ReaderState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialState) {
                _readerBloc.add(ListFeed());
                return _showStatus("Loading...");
              } else if (state is LoadingStep) {
                return _showStatus("Loading ${state.step}...");
              } else if (state is Error) {
                return _showStatus("Error, while loading: ${state.message}");
              } else if (state is Loaded) {
                return _showList(state.items);
              } else {
                return _showStatus("Unknown error, while loading");
              }
            },
          ),
        ));
  }

  Widget _showStatus(String status) {
    return Center(
      child:
          Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _showList(List<NewsItem> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          NewsItem item = items[index];
          return InkWell(
              child: ListTile(
                  title: Stack(children: [
                    if (item.imageUrl != null) Image.network(item.imageUrl),
                    Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Image.asset(item.sourceIconAsset,
                            width: 30, height: 30))
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text(OwnSpaceDateUtils.formatDateTime(item.date),
                          style:
                          TextStyle(color: Colors.black45, fontSize: 12)),
                      Text(item.shortText,
                          style: TextStyle(color: Colors.black87, fontSize: 14))
                    ],
                  )),
              onTap: () {
                launchURL(item.url);
              });
        });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
