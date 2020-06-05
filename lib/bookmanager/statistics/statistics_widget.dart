

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/bookmanager/bloc/book.dart';
import 'package:ownspace/bookmanager/model/year_summary.dart';
import 'package:ownspace/bookmanager/statistics/statistics_chart_painter.dart';

class StatisticsWidget extends StatefulWidget {

  StatisticsWidget({Key key}) : super(key: key);

  @override
  StatisticsWidgetState createState() => StatisticsWidgetState();
}

class StatisticsWidgetState extends State<StatisticsWidget> {

  BookBloc _bookBloc;

  @override
  void initState() {
    _bookBloc = BookBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _bookBloc,
        child: BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialState) {
                _bookBloc.add(LoadYearSummary());
                return _showStatus("Loading...");
              } else if (state is Error) {
                return _showStatus("Error, while loading books: ${state.message}");
              } else if (state is YearSummaryFinished) {
                return _buildView(state.summary);
              }
            }
        )
    );
  }

  Widget _buildView(List<YearSummary> books) {
    return Column(
      children: <Widget>[
        Container(
            width: double.infinity,
            height: 100,
            child: CustomPaint(painter: StatisticsChartPainter(books))
        ),
        Expanded(
            child:
            Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[

                      Padding(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${books[index].year}"),

                            Row(
                              children: <Widget>[
                                Text("${books[index].count}"),
                                Text(" / "),
                                Text(" ${books[index].englishCount}", style: TextStyle(color: Colors.blue))
                              ],
                            ),
                          ],
                        )
                        , padding: EdgeInsets.all(8),
                      ),
                      Divider(color: Colors.black, height: 1, thickness: 0.15)
                    ],
                  );
                },

              ),
            )
        )
      ],
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}