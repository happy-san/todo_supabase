import 'package:flutter/material.dart';

import 'todo_repository.dart';
import 'service_locator.dart';
import 'todo_card.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final _repo = sl<TodoRepository>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        detachedCallBack: () => _repo.removeSub(),
        resumeCallBack: () => _repo.addSub()));

    _repo.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: 1,
          ),
        ),
        itemBuilder: (ctx, i) => TodoCard(
          key: Key(_repo.todos[i].task),
          status: _repo.todos[i].status,
          task: _repo.todos[i].task,
        ),
        itemCount: _repo.todos.length,
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final Function resumeCallBack;
  final Function detachedCallBack;

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
}
