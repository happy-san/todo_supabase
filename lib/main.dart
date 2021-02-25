import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import 'supabase.dart' as supabase;

void main() async {
  final client = SupabaseClient(supabase.url, supabase.key);

  // query data
  final response = await client
      .from('countries')
      .select()
      .order('name', ascending: true)
      .execute();
  if (response.error == null) {
    print('response.data: ${response.data}');
  }
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final SupabaseClient client;

  MyApp({this.client});

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
        client: client,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final SupabaseClient client;

  MyHomePage({Key key, this.title, this.client}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var _subOnCountriesDelete;
  var _subOnCountriesInsert;

  void _addSubs() {
    _subOnCountriesDelete =
        widget.client.from('countries').on(SupabaseEventTypes.delete, (x) {
      print('on countries.delete: ${x.table} ${x.eventType} ${x.oldRecord}');
    }).subscribe((String event, {String errorMsg}) {
      print('event: $event error: $errorMsg');
    });
    _subOnCountriesInsert =
        widget.client.from('countries').on(SupabaseEventTypes.insert, (x) {
      print('on countries.insert: ${x.table} ${x.eventType}${x.newRecord} ');
    }).subscribe((String event, {String errorMsg}) {
      print('event: $event error: $errorMsg');
    });
  }

  void _removeSubs() {
    widget.client.removeSubscription(_subOnCountriesDelete);
    widget.client.removeSubscription(_subOnCountriesInsert);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        detachedCallBack: () => _removeSubs(),
        resumeCallBack: () {
          print('resume...');
          _addSubs();
        }));
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
    print('''
=============================================================
               $state
=============================================================
''');
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
