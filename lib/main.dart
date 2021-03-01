import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import 'supabase.dart' as supabase;

void main() async => runApp(MyApp());

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var _countriesSub;
  final _client = supabase.client;

  void _addSubs() {
    if (_client != null) {
      _countriesSub = _client.from('countries').on(SupabaseEventTypes.all, (x) {
        switch (x.eventType) {
          case 'INSERT':
            print(
                'on countries.insert: ${x.table} ${x.eventType} ${x.newRecord} ');
            break;

          case 'DELETE':
            print(
                'on countries.delete: ${x.table} ${x.eventType} ${x.oldRecord}');
            break;

          case 'UPDATE':
            print(
                'on countries.update: ${x.table} ${x.eventType} ${x.oldRecord} -> ${x.newRecord} ');
            break;
        }
      }).subscribe((String event, {String errorMsg}) {
        print('event: $event error: $errorMsg');
      });
    } else {
      print('client is null');
    }
  }

  void _removeSubs() {
    if (_client != null) {
      _client.removeSubscription(_countriesSub);
    } else {
      print('client is null');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        detachedCallBack: () => _removeSubs(),
        resumeCallBack: () => _addSubs()));

    _addSubs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final Function resumeCallBack;
  final Function detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('''
=============================================================
               $state
=============================================================
''');

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}
