import 'package:flutter/material.dart';
import 'package:to_do_list/home_layout/home_layout.dart';
import 'package:to_do_list/shared/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: primaryIconColor,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
