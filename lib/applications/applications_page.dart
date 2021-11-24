import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/allegro_observer/filters_page.dart';
import 'package:ownspace/applications/bloc/summary.dart';
import 'package:ownspace/applications/currencies/currency_widget.dart';
import 'package:ownspace/applications/currencies/domain/currencies.dart';
import 'package:ownspace/applications/currencies/gold_widget.dart';
import 'package:ownspace/applications/model/summary.dart';
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

  static const IS_IMPORT_VISIBLE = false;

  ApplicationsPage({Key key}) : super(key: key);

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {

  SummaryBloc _summaryBloc;
  supply.SupplyBloc _supplyBloc;

  double _valueUsd = 0;
  double _valueEur = 0;
  double _valueGold = 0;

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
          return applicationsCard(state.summary);
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

  Widget applicationsCard(ApplicationsSummary summary) {
    return Card(
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
                            TimeKeeper().canOpenNews().then((canOpen) async {
                              if (canOpen) {
                                await redirect(ReaderPage());
                                _summaryBloc.add(LoadSummary());
                              }
                            });
                          },
                          right: true, bottom: true, canOpen: summary.canOpenNews ? 1 : 0),
                      menuItem("icons/ic_sugar.png",
                          "Sugar (${summary.todaysSugar.toStringAsFixed(1)})",
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
                      menuItem(
                          "icons/ic_books.png", "Books (${summary.booksCount})",
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
                            TimeKeeper().canOpenAllegro().then((canOpen) async {
                              if (canOpen) {
                                await redirect(FiltersPage());
                                _summaryBloc.add(LoadSummary());
                              }
                            });
                          },
                          right: true, bottom: true, canOpen: summary.canOpenAllegro ? 1 : 0),
                      menuItem("icons/ic_time_capsule.png", "Time Capsule",
                          right: true, bottom: true, callback: () {
                            openTimeMachine();
                          }),
                      menuItem("icons/ic_backup.png", "Backup",
                          callback: () {
                            redirect(BackupPage());
                          }, bottom: true),
                    ]),
                    Row(children: <Widget>[
                      menuItem(
                        "", "USD ${_valueUsd.toStringAsFixed(2)}zł",
                        right: true,
                        icon: CurrencyWidget(from: Currency.USD,
                            to: Currency.PLN,
                            sign: "\$",
                            color: Colors.lightBlue,
                            callback: (value) {
                              setState(() {
                                _valueUsd = value;
                              });
                            }),
                      ),
                      menuItem(
                          "", "EUR ${_valueEur.toStringAsFixed(2)}zł",
                          right: true,
                          icon: CurrencyWidget(from: Currency.EUR,
                              to: Currency.PLN,
                              sign: "€",
                              color: Colors.lightGreen,
                              callback: (value) {
                                setState(() {
                                  _valueEur = value;
                                });
                              })
                      ),
                      menuItem(
                          "", "Gold ${_valueGold.toStringAsFixed(2)}zł",
                          icon: GoldWidget(
                              sign: "Au",
                              color: Color.fromARGB(255, 255, 215, 0),
                              callback: (value) {
                                setState(() {
                                  _valueGold = value;
                                });
                              })
                      ),
                    ]),
                  ],),
              )
            ])
    );
  }

  Widget _currencyIcon(String sign, Color color) {
    return Container(
      alignment: Alignment.center,
      child: Text(
          sign,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle
      ),
    );
  }

  Future redirect(Widget page) async {
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
      {Function callback, left: false, right: false, top: false, bottom: false, hidden: false, int canOpen = -1, Widget icon}) {
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
                child: Stack(children: <Widget>[
                  _displayCanOpenState(canOpen),
                  Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: icon ??
                                Image.asset(assetName, width: 40, height: 40)
                        ),
                        Text(text, style: TextStyle(
                            fontSize: 11, color: Colors.white70))
                      ])
                ]),
              ),
              onTap: callback != null ? () {
                callback();
              } : null,
            )
        )
    );
  }

  Widget _displayCanOpenState(int canOpen) {
    if (canOpen == -1) return Container();
    var dotSize = 12.0;
    if (canOpen == 1) {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            shape: BoxShape.circle,
            color: Colors.green
          ),
          width: dotSize,
          height: dotSize,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        width: dotSize,
        height: dotSize,
      );
    }
  }
}
