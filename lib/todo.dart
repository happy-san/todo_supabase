class Todo {
  String task;
  bool status;

  Todo(this.task, this.status);

  Todo.fromMap(Map<String, dynamic> map) {
    task = map['task'];
    status = map['status'];
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other.runtimeType is Todo && this.task == other.task);

  @override
  int get hashCode => task.hashCode;

  Map<String, dynamic> toMap() => {'task': task, 'status': status};

  @override
  String toString() {
    return 'Task: $task, Status $status';
  }
}
