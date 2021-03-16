import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';
import 'package:realtime_client/realtime_client.dart';

import 'todo.dart';

class TodoRepository extends ChangeNotifier {
  var todos = <Todo>[];
  final SupabaseClient client;

  RealtimeSubscription _sub;

  TodoRepository({this.client}) {
    _initTodo();
    addSub();
  }

  Future<void> _initTodo() async {
    ((await client.from('todos').select('task, status').execute()).data as List)
        .forEach((element) {
      print(element);
      todos.add(Todo.fromMap((element as Map).cast<String, dynamic>()));
    });
    notifyListeners();
    print('Init\n$todos');
  }

  Future<void> addSub() async {
    _sub = client.from('todos').on(SupabaseEventTypes.all, (x) {
      switch (x.eventType) {
        case 'INSERT':
          print('${x.table}.${x.eventType} ${x.newRecord} ');
          todos.add(Todo.fromMap((x.newRecord as Map).cast<String, dynamic>()));
          break;

        case 'DELETE':
          final oldTask = (x.oldRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.oldRecord}');
          todos.removeWhere((todo) => todo.task.compareTo(oldTask) == 0);
          break;

        case 'UPDATE':
          final oldTask = (x.oldRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.oldRecord} -> ${x.newRecord} ');

          final index =
                  todos.indexWhere((todo) => todo.task.compareTo(oldTask) == 0),
              todo = Todo.fromMap((x.newRecord as Map).cast<String, dynamic>());

          if (index != -1) {
            todos[index].task = todo.task;
            todos[index].status = todo.status;
          } else {
            todos.add(todo);
          }
          break;
      }
      print(todos);
      notifyListeners();
    }).subscribe((String event, {String errorMsg}) {
      print('event: $event error: $errorMsg');
    });
  }

  void removeSub() {
    client.removeSubscription(_sub);
  }
}
