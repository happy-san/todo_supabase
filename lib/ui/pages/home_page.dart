import 'package:flutter/material.dart';

import '../../core/service_locator.dart';
import '../../core/todo_repository.dart';

import '../../ui/todo_card.dart';
import '../../ui/new_todo_dialog.dart';

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
      body: RefreshIndicator(
        onRefresh: () async => await _repo.initTodo(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1,
            ),
          ),
          itemBuilder: (ctx, i) {
            final task = _repo.todos[i].task,
                isLast = i == _repo.todos.length - 1;

            return Builder(
              builder: (context) => Dismissible(
                key: Key(task),
                onDismissed: (direction) async {
                  await _repo.deleteTodo(task);

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("$task deleted"),
                    duration: Duration(milliseconds: 750),
                  ));
                },
                background: Container(
                  margin: isLast
                      ? const EdgeInsets.only(
                          left: 10.0,
                          top: 5.0,
                          right: 10.0,
                          bottom: 80,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: GestureDetector(
                  onTap: () => _repo.updateStatus(_repo.todos[i]),
                  child: TodoCard(
                    status: _repo.todos[i].status,
                    task: _repo.todos[i].task,
                    isLast: isLast,
                  ),
                ),
              ),
            );
          },
          itemCount: _repo.todos.length,
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            if (!Navigator.of(context).canPop()) {
              showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  child: NewTodoDialog());
            }
          },
          child: const Icon(Icons.add),
        ),
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
