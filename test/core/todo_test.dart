import 'package:test/test.dart';

import 'package:todo_supabase/core/todo.dart';

void main() {
  Todo todo, todoFromMap;

  group('Todo', () {
    setUp(() {
      todo = Todo('task', false);
      todoFromMap = Todo.fromMap({'task': 'tAsk', 'status': true});
    });

    test('has a task', () {
      expect(todo.task, equals('task'));
      expect(todoFromMap.task, equals('tAsk'));
    });

    test('has a status', () {
      expect(todo.status, isFalse);
      expect(todoFromMap.status, isTrue);
    });

    test('toString()', () {
      expect(todo.toString(), equals('Task: task, Status: false'));
      expect(todoFromMap.toString(), equals('Task: tAsk, Status: true'));
    });

    test('toMap()', () {
      final map1 = todo.toMap(), map2 = todoFromMap.toMap();
      expect(map1['task'], equals('task'));
      expect(map1['status'], equals(false));
      expect(map2['task'], equals('tAsk'));
      expect(map2['status'], equals(true));
    });
  });

  group('Validation:', () {
    test('Doesn\'t accept null task or status', () {
      expect(() {
        Todo(null, true);
      }, throwsA((isA<AssertionError>())));
      expect(() {
        Todo('task', null);
      }, throwsA((isA<AssertionError>())));
      expect(() {
        Todo.fromMap({'task': null, 'status': true});
      }, throwsA((isA<AssertionError>())));
      expect(() {
        Todo.fromMap({'task': 'task', 'status': null});
      }, throwsA((isA<AssertionError>())));
    });

    test('Doesn\'t accept empty task', () {
      expect(() {
        Todo('', true);
      }, throwsA((isA<AssertionError>())));
      expect(() {
        Todo.fromMap({'task': '', 'status': true});
      }, throwsA((isA<AssertionError>())));
    });

    test('Todos with similar task are equal', () {
      expect(todo, equals(Todo('Task', false)));
      expect(todo, equals(Todo.fromMap({'task': 'tAsk', 'status': true})));
    });
  });
}
