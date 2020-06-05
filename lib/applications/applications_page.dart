import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ownspace/applications/bloc/summary.dart';
import 'package:ownspace/backup/backup_page.dart';
import 'package:ownspace/bookmanager/books_page.dart';
import 'package:ownspace/fuel/fuel_page.dart';
import 'package:ownspace/news/readerpage.dart';
import 'package:ownspace/notepad/notepad_page.dart';
import 'package:ownspace/passwordvault/authorize/authorizepage.dart';
import 'package:ownspace/sugar/sugar_page.dart';
import 'package:ownspace/tasks/tasks_page.dart';
import 'package:ownspace/weight/weight_page.dart';

class ApplicationsPage extends StatefulWidget {

  static final IS_IMPORT_VISIBLE = false;

  ApplicationsPage({Key key}) : super(key: key);

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {

  SummaryBloc _summaryBloc;

  @override
  void initState() {
    _summaryBloc = SummaryBloc();
    super.initState();
  }

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
          child: BlocProvider(
            create: (context) => _summaryBloc,
            child: _createSummaryBody()
          )
        )
    );
  }

  Widget _createSummaryBody() {
    var datetime = DateTime.now();
    var dateString = DateFormat("EEEE, dd MMMM yyyy").format(datetime);

    return BlocBuilder<SummaryBloc, SummaryState>(
      builder: (context, state) {
        if (state == SummaryLoaded || state.toString() == "SummaryLoaded") {
          var summary = (state as SummaryLoaded).summary;
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$dateString", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                Row(children: <Widget>[
                  Text("Today's sugar: ", style: TextStyle(color: Colors.white)),
                  Text("${summary.todaysSugar}g", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
                ]),
                Row(children: <Widget>[
                  Text("Dots: ", style: TextStyle(color: Colors.white)),
                  Text("${summary.dotsCount}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
                ]),
                Row(children: <Widget>[
                  Text("Books: ", style: TextStyle(color: Colors.white)),
                  Text("${summary.booksCount}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
                ]),
                Row(children: <Widget>[
                  Text("Last weights: ", style: TextStyle(color: Colors.white)),
                  Text("${summary.lastWeights.join("kg / ")}kg", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
                ]),
              ]
          );
        } else if (state == Error || state.toString() == "Error") {
          return _showStatus("Error");
        } else if (state == Loading || state.toString() == "Loading") {
          return _showStatus("Loading");
        } else if (state == InitialSummaryState || state.toString() == "InitialSummaryState") {
          _summaryBloc.add(LoadSummary());
          return _showStatus("Loading");
        }
        return _showStatus("unknown $state");
      },
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
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
                      menuItem("icons/ic_news.png", "News reader",
                          callback: () { redirect(ReaderPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_sugar.png", "Sugar",
                          callback: () { redirect(SugarPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_news.png", "Dots", bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_books.png", "Books",
                          callback: () { redirect(BooksPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_weight.png", "Weight",
                          callback: () { redirect(WeightPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_fuel.png", "Fuel",
                          callback: () { redirect(FuelPage()); },
                          bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_notepad.png" , "Notepad",
                          callback: () { redirect(NotepadPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_tasks.png", "Tasks",
                          callback: () { redirect(TasksPage()); },
                          right: true, bottom: true),
                      menuItem("icons/ic_password_vault.png", "Password vault",
                          callback: () { redirect(AuthorizePage()); },
                          bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_allegro.png", "Allegro Observer", right: true),
                      menuItem("icons/ic_time_capsule.png", "Time Capsule", right: true),
                      menuItem("icons/ic_backup.png", "Backup",
                        callback: () { redirect(BackupPage()); },),
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
              color: callback == null ? Colors.black12 : null,
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
                      Text(text, style: TextStyle(fontSize: 11))
                    ],
                  )),
              onTap: () { callback(); },
            )
        )
    );
  }
}