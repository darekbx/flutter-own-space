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
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/reader/bloc/reader.dart';
import 'package:ownspace/reader/bloc/source.dart';
import 'package:ownspace/reader/model/newsitem.dart';

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
                _readerBloc.add(ListFeed(Source.HACKADAY));
                return _showStatus("Loading...");
              } else if (state is Error) {
                return _showStatus("Error, while loading supply: ${state.message}");
              } else if (state is Loaded) {
                return _showList(state.items);
              }
            },
          ),
        )
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _showList(List<NewsItem> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          NewsItem item = items[index];
          return
            InkWell(
                child: ListTile(
                  //leading: TODO: source icon

                  title: Text(item.title),
                  subtitle: Text(item.shortText),
                  trailing: Text(item.date),
                ),
                onTap: () {

                }
            );
        }
    );
  }
}
