import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/tasks.dart';
import 'package:frontend/screens/task_screen.dart';
import 'package:frontend/services/getLiveTask.dart';
import 'package:frontend/widgets/add_task_form.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RightDrawer extends ConsumerStatefulWidget {
  const RightDrawer(
      {super.key,
      required String this.uId,
      required String this.coId,
      required String this.chId});
  final String uId;
  final String coId;
  final String chId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RightDrawerState();
}

class _RightDrawerState extends ConsumerState<RightDrawer> {
  List<Map<String, dynamic>> task = [];

  void fetchTasks() async {
    var response = await getTasks(
      token: widget.uId,
      communityID: widget.coId,
      channelID: widget.chId,
    );
    print(response);
    setState(() {
      print((response["LiveTasks"] as List));
      if ((response["LiveTasks"] as List).isNotEmpty) {
        task = List<Map<String, dynamic>>.from(
            response["LiveTasks"][0]["liveTask"]);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        //add icon for productivity
        leading: IconButton(
          icon: const Icon(Icons.trending_up),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Productivity'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          task.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Live Tasks',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: task.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(task[index]["name"]),
                                        LinearPercentIndicator(
                                          width: 150,
                                          lineHeight: 10,
                                          percent: 0.5,
                                          progressColor: Colors.blue,
                                        ),
                                      ]),
                                  subtitle: const Text('Description'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return TaskScreen(
                                            subTask: task[index]["subtask"]);
                                      }));
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enter Task Details'),
                            content: Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TaskForm(
                                  uId: widget.uId,
                                  coId: widget.coId,
                                  chId: widget.chId),
                            ),
                          );
                        },
                      );

                      if (result != null) {
                        setState(() {
                          task = result;
                          print(task);
                        });
                      }
                    },
                    child: Center(
                      child: const Text("Click to Add some tasks"),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
