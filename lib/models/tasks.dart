class Subtask {
  String name;
  bool status;
  String timeSpent;

  Subtask({required this.name, required this.status, required this.timeSpent});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'timeSpent': timeSpent,
    };
  }
}

class Task {
  String name;
  bool status;
  String completionTime;
  List<Subtask> subtask;

  Task({required this.name, required this.status, required this.completionTime, required this.subtask});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'completionTime': completionTime,
      'subtask': subtask.map((e) => e.toJson()).toList(),
    };
  }
}