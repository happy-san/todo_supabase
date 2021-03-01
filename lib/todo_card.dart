import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final String task;
  final bool status;

  const TodoCard({Key key, this.task, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      color: Colors.blueGrey[200],
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, top: 8.0, right: 10.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                task,
                style: TextStyle(
                    decorationStyle: status ? null : TextDecorationStyle.dashed,
                    fontSize: 24),
              ),
            ),
            Icon(status ? Icons.alarm_off_rounded : Icons.alarm_on_rounded),
          ],
        ),
      ),
    );
  }
}
