import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/allegro_observer/filters_page.dart';
import 'package:ownspace/applications/bloc/summary.dart';
import 'package:ownspace/applications/time_keeper.dart';
import 'package:ownspace/backup/backup_page.dart';
import 'package:ownspace/bookmanager/books_page.dart';
import 'package:ownspace/fuel/fuel_page.dart';
import 'package:ownspace/news/readerpage.dart';
import 'package:ownspace/notepad/notepad_page.dart';
import 'package:ownspace/passwordvault/authorize/authorizepage.dart';
import 'package:ownspace/reader/news_reader_page.dart';
import 'package:ownspace/sugar/sugar_page.dart';
import 'package:ownspace/supplies/bloc/supply.dart' as supply;
import 'package:ownspace/tasks/tasks_page.dart';
import 'package:ownspace/weight/weight_page.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class ApplicationsPage extends StatefulWidget {

  static final IS_IMPORT_VISIBLE = false;

  ApplicationsPage({Key key}) : super(key: key);

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {

  SummaryBloc _summaryBloc;
  supply.SupplyBloc _supplyBloc;

  @override
  void initState() {
    _summaryBloc = SummaryBloc();
    _supplyBloc = supply.SupplyBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0
                          ),
                          child: mainCard()
                      )
                  ),
                ],
        ));
  }

  Widget mainCard() {
    return BlocProvider(
        create: (context) => _summaryBloc,
        child: _createCard()
    );
  }

  Widget _createCard() {
    return BlocBuilder<SummaryBloc, SummaryState>(
      builder: (context, state) {
        if (state is SummaryLoaded) {
          _supplyBloc.add(supply.FetchLowSupplies());
          var summary = (state as SummaryLoaded).summary;
          return applicationsCard(
              summary.todaysSugar.toStringAsFixed(1),
              "${summary.booksCount}"
          );
        } else if (state is Error) {
          return _showStatus("Error");
        } else if (state is Loading) {
          return _showStatus("Loading");
        } else if (state is InitialSummaryState) {
          _summaryBloc.add(LoadSummary());
          return _showStatus("Loading");
        }
        return _showStatus("unknown $state");
      },
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.white60, fontSize: 14)),
    );
  }

  Card applicationsCard(String todaysSugar, String booksCount) {
    return Card(
        elevation: 4.0,
        color: Colors.black,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(color: Colors.black38, height: 1),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(children: <Widget>[
                      menuItem("icons/ic_news.png", "News reader",
                          callback: () {
                            TimeKeeper().canOpenNews().then((canOpen) {
                              if (canOpen) {
                                redirect(ReaderPage());
                              }
                            });
                          },
                          right: true, bottom: true),
                      menuItem("icons/ic_sugar.png", "Sugar ($todaysSugar)",
                          callback: () {
                            redirect(SugarPage());
                          },
                          right: true, bottom: true),
                      menuItem("icons/ic_rss.png", "Reader",
                          callback: () {
                            redirect(NewsReaderPage());
                          },
                          bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_books.png", "Books ($booksCount)",
                          callback: () {
                            redirect(BooksPage());
                          },
                          right: true, bottom: true),
                      menuItem("icons/ic_weight.png", "Weight",
                          callback: () {
                            redirect(WeightPage());
                          },
                          right: true, bottom: true),
                      menuItem("icons/ic_fuel.png", "Fuel",
                          callback: () {
                            redirect(FuelPage());
                          },
                          bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_notepad.png", "Notepad",
                          callback: () {
                            redirect(NotepadPage());
                          },
                          right: true, bottom: true),
                      menuItem("icons/ic_tasks.png", "Tasks",
                          callback: () {
                            redirect(TasksPage());
                          },
                          right: true, bottom: true),
                      menuItem("icons/ic_password_vault.png", "Password vault",
                          callback: () {
                            redirect(AuthorizePage());
                          },
                          bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem("icons/ic_allegro.png", "Allegro Observer",
                          callback: () {
                            TimeKeeper().canOpenAllegro().then((canOpen) {
                              if (canOpen) {
                                redirect(FiltersPage());
                              }
                            });
                          },
                          right: true),
                      menuItem("icons/ic_time_capsule.png", "Time Capsule",
                          right: true, callback: () {
                            openTimeMachine();
                          }),
                      menuItem("icons/ic_backup.png", "Backup",
                        callback: () {
                          redirect(BackupPage());
                        },),
                    ]),
                  ],),
              )
            ])
    );
  }

  void redirect(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    //_summaryBloc.add(LoadSummary());
  }

  void openTimeMachine() async {
    await LaunchApp.openApp(
        androidPackageName: 'com.darekbx.sambaclient',
        openStore: false
    );
  }

  Widget menuItem(String assetName, String text,
      {Function callback, left: false, right: false, top: false, bottom: false, hidden: false}) {
    if (hidden) {
      return Spacer();
    }
    BorderSide defaultBorder = BorderSide(color: Colors.white30, width: 0.5);
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
                      Text(text, style: TextStyle(fontSize: 11, color: Colors.white70))
                    ],
                  )),
              onTap: () { callback(); },
            )
        )
    );
  }
}
