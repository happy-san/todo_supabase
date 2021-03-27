import 'package:flutter/material.dart';

import 'core/service_locator.dart';

import 'ui/pages/home_page.dart';

void main() {
  initServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SupaBase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'SupaBase Demo Home Page',
      ),
    );
  }
}
