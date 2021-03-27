import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final String task;
  final bool status;
  final bool isLast;

  const TodoCard(
      {Key key, this.task = '', this.status = false, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
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
      color: status ? Colors.blueGrey[50] : Colors.blueGrey[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                task,
                style: status
                    ? const TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black38,
                      )
                    : const TextStyle(fontSize: 20),
              ),
            ),
            status
                ? const Icon(
                    Icons.alarm_on_rounded,
                    color: Colors.black38,
                  )
                : const Icon(
                    Icons.access_alarms_rounded,
                  ),
          ],
        ),
      ),
    );
  }
}
