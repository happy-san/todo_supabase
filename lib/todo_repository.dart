import 'package:supabase/supabase.dart';
import 'package:realtime_client/realtime_client.dart';

class TodoRepository {
  var todos = <String>[];
  final SupabaseClient client;

  RealtimeSubscription _sub;

  TodoRepository({this.client}) {
    _initTodo();
    addSub();
  }

  Future<void> _initTodo() async {
    ((await client.from('todos').select('task').execute()).data as List)
        .forEach((element) {
      todos.add((element as Map).cast<String, dynamic>()['task']);
    });
    print('Init\n$todos}');
  }

  Future<void> addSub() async {
    _sub = client.from('todos').on(SupabaseEventTypes.all, (x) {
      switch (x.eventType) {
        case 'INSERT':
          final newTask = (x.newRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.newRecord} ');
          todos.add(newTask);
          break;

        case 'DELETE':
          final oldTask = (x.oldRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.oldRecord}');
          todos.removeWhere((todo) => todo.compareTo(oldTask) == 0);
          break;

        case 'UPDATE':
          final newTask = (x.newRecord as Map).cast<String, dynamic>()['task'],
              oldTask = (x.oldRecord as Map).cast<String, dynamic>()['task'];

          print('${x.table}.${x.eventType} ${x.oldRecord} -> ${x.newRecord} ');
          final index = todos.indexOf(oldTask);
          if (index != -1) {
            todos[index] = newTask;
          } else {
            todos.add(newTask);
          }
          break;
      }
      print(todos);
    }).subscribe((String event, {String errorMsg}) {
      print('event: $event error: $errorMsg');
    });
  }

  void removeSub() {
    client.removeSubscription(_sub);
  }
}
