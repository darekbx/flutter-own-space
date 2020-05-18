import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/notepad/notepadpage.dart';
import 'package:ownspace/tasks/taskspage.dart';
import 'package:ownspace/weight/weightpage.dart';

class ApplicationsPage extends StatefulWidget {

  ApplicationsPage({Key key}) : super(key: key);

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: 200.0,
                      child: Padding(
                          padding: EdgeInsets.all(16.0), child: statusCard())
                      ),
                  Container(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0
                          ),
                          child: applicationsCard()
                      )
                  ),
                ],
              ),
            )
        ));
  }

  Card statusCard() {
    return Card(
        elevation: 4.0,
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Monday, 04 May 2020\n\nBooks: 100\nDots: 15 (all 4000)\nToday's sugar: 11.5g\nLast weight: 60.2kg", style: TextStyle(color: Colors.white)),
        )
    );
  }

  Card applicationsCard() {
    return Card(
        elevation: 4.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Applications')
              ),
              Divider(color: Colors.black38, height: 1),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(children: <Widget>[
                      menuItem("icons/ic_news.png", "News reader", right: true, bottom: true),
                      menuItem("icons/ic_sugar.png", "Sugar", right: true, bottom: true),
                      menuItem("icons/ic_news.png", "Dots", bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_books.png", "Books", right: true, bottom: true),
                      menuItem("icons/ic_weight.png", "Weight",
                          callback: () { redirect(WeightPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_fuel.png", "Fuel", bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_notepad.png" , "Notepad",
                          callback: () { redirect(NotepadPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_tasks.png", "Tasks",
                          callback: () { redirect(TasksPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_password_vault.png", "Password vault", bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_time_capsule.png", "Time Capsule", right: true),
                      menuItem("icons/ic_backup.png", "Backup", right: true),
                      menuItem("icons/ic_backup.png", "", hidden: true),
                    ]),
                  ],),
              )
            ])
    );
  }

  void redirect(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget menuItem(String assetName, String text,
      {Function callback, left: false, right: false, top: false, bottom: false, hidden: false}) {
    if (hidden) {
      return Spacer();
    }
    BorderSide defaultBorder = BorderSide(color: Colors.black38, width: 0.5);
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                  right: right ? defaultBorder : BorderSide.none,
                  bottom: bottom ? defaultBorder : BorderSide.none,
                  top: top ? defaultBorder : BorderSide.none,
                  left: left ? defaultBorder : BorderSide.none
              ),
            ),
            alignment: Alignment.center,
            child: InkWell(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset(assetName, width: 40, height: 40)
                      ),
                      Text(text, style: TextStyle(fontSize: 12))
                    ],
                  )),
              onTap: () { callback(); },
            )
        )
    );
  }
}