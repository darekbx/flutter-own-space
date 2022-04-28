import 'package:flutter/material.dart';

class CommonWidgets {

  static handleFuture(
      AsyncSnapshot<dynamic> snapshot, Function(dynamic) callback) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return loadingView();
      default:
        if (snapshot.hasError) {
          return error("${snapshot.error}");
        } else {
          if (snapshot.data == null) {
            return error("Error :( ");
          } else {
            return callback(snapshot.data);
          }
        }
    }
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child:CircularProgressIndicator());
      }
    );
  }

  static loadingView() => Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(height: 20, child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(child: CircularProgressIndicator(), width: 16, height: 16)
          ])));

  static error(String errorMessage) => Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      ));
}
