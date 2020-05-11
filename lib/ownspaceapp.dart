import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'applications/applicationspage.dart';

class OwnSpaceApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Own Space',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ApplicationsPage(),
    );
  }
}