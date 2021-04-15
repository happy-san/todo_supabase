import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';
import 'package:realtime_client/realtime_client.dart';

import 'todo.dart';

class TodoRepository extends ChangeNotifier {
  List<Todo>? todos;
  final SupabaseClient client;

  late RealtimeSubscription _sub;

  TodoRepository(this.client) {
    initTodo();
    addSub();
  }

  Future<void> initTodo() async {
    todos = [];
    notifyListeners();
    ((await client.from('todos').select('task, status').execute()).data
            as List?)
        ?.forEach((element) {
      print(element);
      todos!.add(Todo.fromMap((element as Map).cast<String, dynamic>()));
    });
    notifyListeners();
    print('Init\n$todos');
  }

  Future<void> createTodo(String task) async =>
      await client.from('todos').insert(
        {'task': task, 'status': false},
        upsert: true,
      ).execute();

  Future<void> updateStatus(Todo todo) async => await client
      .from('todos')
      .update({'status': !todo.status})
      .eq('task', todo.task)
      .execute();

  Future<void> deleteTodo(String task) async =>
      await client.from('todos').delete().eq('task', task).execute();

  Future<void> addSub() async {
    _sub = client.from('todos').on(SupabaseEventTypes.all, (x) {
      switch (x.eventType) {
        case 'INSERT':
          print('${x.table}.${x.eventType} ${x.newRecord} ');
          todos!
              .add(Todo.fromMap((x.newRecord as Map).cast<String, dynamic>()));
          break;

        case 'DELETE':
          final oldTask = (x.oldRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.oldRecord}');
          todos!.removeWhere((todo) => todo.task.compareTo(oldTask) == 0);
          break;

        case 'UPDATE':
          final oldTask = (x.oldRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.oldRecord} -> ${x.newRecord} ');

          final index = todos!
                  .indexWhere((todo) => todo.task.compareTo(oldTask) == 0),
              todo = Todo.fromMap((x.newRecord as Map).cast<String, dynamic>());

          if (index != -1) {
            todos![index].status = todo.status;
          } else {
            todos!.add(todo);
          }
          break;
      }
      print(todos);
      notifyListeners();
    }).subscribe((String event, {String? errorMsg}) {
      print('event: $event error: $errorMsg');
    });
  }

  void removeSub() {
    client.removeSubscription(_sub);
  }
}
