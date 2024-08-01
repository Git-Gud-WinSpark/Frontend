import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/tasks.dart';
import 'package:frontend/services/storeTasks.dart';

class TaskForm extends StatefulWidget {
  const TaskForm(
      {super.key,
      required String this.uId,
      required String this.coId,
      required String this.chId});
  final String uId;
  final String coId;
  final String chId;
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _taskNameController = TextEditingController();
  final _completionTimeController = TextEditingController();
  bool _taskStatus = false;
  List<Subtask> _subtasks = [];
  List<Task> _tasks = [];

  final _subtaskNameController = TextEditingController();
  final _timeSpentController = TextEditingController();
  bool _subtaskStatus = false;

  void _addSubtask() {
    setState(() {
      _subtasks.add(Subtask(
        name: _subtaskNameController.text,
        status: _subtaskStatus,
        timeSpent: _timeSpentController.text,
      ));
      _subtaskNameController.clear();
      _timeSpentController.clear();
      _subtaskStatus = false;
    });
  }

  void _addTask() {
    setState(() {
      _tasks.add(Task(
        name: _taskNameController.text,
        status: _taskStatus,
        completionTime: _completionTimeController.text,
        subtask: List.from(_subtasks),
      ));
      _taskNameController.clear();
      _completionTimeController.clear();
      _taskStatus = false;
      _subtasks.clear();
    });
  }

  void _cancelTask() {
    setState(() {
      _taskNameController.clear();
      _completionTimeController.clear();
      _taskStatus = false;
      _subtasks.clear();
      _subtaskNameController.clear();
      _timeSpentController.clear();
      _subtaskStatus = false;
    });
  }

  void _submitForm() async {
    dynamic tasks = _tasks.map((task) => task.toJson()).toList();
    Navigator.of(context).pop(tasks);
    var res = await storeTasks(
        token: widget.uId,
        communityID: widget.coId,
        channelID: widget.chId,
        tasks: tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Form',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(labelText: 'Task Name'),
                  ),
                  Row(
                    children: [
                      Text('Task Status'),
                      Checkbox(
                        value: _taskStatus,
                        onChanged: (value) {
                          setState(() {
                            _taskStatus = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      labelText: 'Completion Time',
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 10)),
                    initialPickerDateTime: DateTime.now(),
                    onChanged: (DateTime? value) {
                      _completionTimeController.text =
                          value?.toIso8601String() ?? '';
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Subtasks', style: TextStyle(fontSize: 18)),
                  TextField(
                    controller: _subtaskNameController,
                    decoration: InputDecoration(labelText: 'Subtask Name'),
                  ),
                  Row(
                    children: [
                      Text('Subtask Status'),
                      Checkbox(
                        value: _subtaskStatus,
                        onChanged: (value) {
                          setState(() {
                            _subtaskStatus = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: _timeSpentController,
                    decoration:
                        InputDecoration(labelText: 'Time Spent (hh:mm:ss)'),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      final timeParts = value.split(':');
                      if (timeParts.length == 3) {
                        final hours = int.tryParse(timeParts[0]);
                        final minutes = int.tryParse(timeParts[1]);
                        final seconds = int.tryParse(timeParts[2]);
                        if (hours != null &&
                            minutes != null &&
                            seconds != null) {
                          final time =
                              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                          _timeSpentController.text = time;
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: _addSubtask,
                    child: Text('Add Subtask'),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _addTask,
                        child: Text('Submit Task'),
                      ),
                      TextButton(
                        onPressed: _cancelTask,
                        child: Text('Cancel Task'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${task.status}'),
                                Text('Completion Time: ${task.completionTime}'),
                                Text('Subtasks:'),
                                ...task.subtask.map<Widget>((subtask) {
                                  return Text(
                                      '- ${subtask.name} (Status: ${subtask.status}, Time Spent: ${subtask.timeSpent})');
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit Form'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel Button'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
