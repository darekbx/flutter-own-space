import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class ForwardPage extends StatelessWidget {
  ForwardPage({Key key, this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    _openUrl(context, url);
    return Scaffold(
        appBar: AppBar(
          title: Text("Opening item..."),
        ),
        body: Center(
            child:
            CircularProgressIndicator()
        )
    );
  }

  _openUrl(BuildContext context, String url) async {
    await Future.delayed(Duration(seconds: 1));
    if (await canLaunch(url)) {
      await launch(url);
    }
    Navigator.pop(context);
  }
}