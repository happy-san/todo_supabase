import 'package:flutter/material.dart';

import '../core/todo_repository.dart';
import '../core/service_locator.dart';

class NewTodoDialog extends StatefulWidget {
  @override
  _NewTodoDialogState createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends State<NewTodoDialog> {
  final _repo = sl<TodoRepository>();
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode1, focusNode2, focusNode3;
  TextEditingController textEditingController1,
      textEditingController2,
      textEditingController3;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();

    Future.delayed(Duration(milliseconds: 200))
        .then((value) => focusNode1.requestFocus());
  }

  @override
  void dispose() {
    super.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: Colors.blue[50],
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            // Task 1
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                focusNode: focusNode1,
                controller: textEditingController1,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintText: 'Enter a task',
                ),
                validator: _validateTask,
                onFieldSubmitted: (_) => focusNode2.requestFocus(),
                textInputAction: TextInputAction.next,
              ),
            ),
            // Task 2
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                focusNode: focusNode2,
                controller: textEditingController2,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintText: 'Another one',
                ),
                validator: _validateTask,
                onFieldSubmitted: (_) => focusNode3.requestFocus(),
                textInputAction: TextInputAction.next,
              ),
            ),
            // Task 3
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                focusNode: focusNode3,
                controller: textEditingController3,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintText: 'More than enough',
                ),
                validator: _validateTask,
                onFieldSubmitted: (_) => _createNewTodos(),
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _createNewTodos,
          child: Text('Ok'),
        ),
      ],
    );
  }

  void _createNewTodos() async {
    if (_formKey.currentState.validate()) {
      await _createTodo(textEditingController1.value.text);
      await _createTodo(textEditingController2.value.text);
      await _createTodo(textEditingController3.value.text);

      Navigator.of(context).pop();
    }
  }

  Future<void> _createTodo(String text) async {
    if (text.isNotEmpty) {
      print('Creating Todo: $text');
      await _repo.createTodo(text);
    }
  }

  String _validateTask(String task) =>
      task.length < 100 ? null : 'Way too long!';
}
