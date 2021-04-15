class Todo {
  final String task;
  bool status;

  Todo(String t, bool s)
      : assert(t.isNotEmpty),
        task = t,
        status = s;

  factory Todo.fromMap(Map<String, dynamic> map) =>
      Todo(map['task'], map['status']);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Todo && this.hashCode == other.hashCode);

  @override
  int get hashCode => task.toLowerCase().hashCode;

  Map<String, dynamic> toMap() => {'task': task, 'status': status};

  @override
  String toString() => 'Task: $task, Status: $status';
}
