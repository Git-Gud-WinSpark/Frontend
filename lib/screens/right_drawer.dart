import 'package:calendar_view/calendar_view.dart';
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
  List<int> completedTasks = [];

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
        task.forEach((element) {
          int count = 0;
          element['subtask'].forEach((subElement) {
            if (subElement['status']) {
              count++;
            }
          });
          completedTasks.add(count);
        });
      }
      print(task);
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
    return
        // CalendarControllerProvider(
        //   controller: EventController(),
        // child: MaterialApp(
        //   theme: ThemeData(
        //     colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF8476)),
        //     appBarTheme: AppBarTheme(
        //       backgroundColor: Color.fromARGB(255, 9, 13, 86),
        //       foregroundColor: Colors.white,
        //     ),
        //     useMaterial3: true,
        //     scaffoldBackgroundColor: Color.fromARGB(255, 5, 7, 44),
        //   ),
        //   home:
        Scaffold(
      appBar: AppBar(
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
          Expanded(
              child: Container(
            margin: EdgeInsets.all(16),
            child: MonthView(
              showBorder: true,
              cellAspectRatio: 0.5,
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          task.isNotEmpty
              ? Expanded(
                  flex: 1,
                  child: Padding(
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
                                Future.delayed(Durations.medium3, () {
                                  CalendarControllerProvider.of(context)
                                      .controller
                                      .add(
                                        CalendarEventData(
                                          title: task[index]["name"],
                                          date: DateTime.parse(
                                            task[index]["completionTime"],
                                          ),
                                        ),
                                      );
                                });
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
                                            animation: true,
                                            width: 150,
                                            lineHeight: 10,
                                            percent:
                                                index < completedTasks.length
                                                    ? completedTasks[index] /
                                                        (task[index]["subtask"]
                                                                as List)
                                                            .length
                                                    : 0.0,
                                            progressColor: Colors.blue,
                                          ),
                                        ]),
                                    subtitle: const Text('Description'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TaskScreen(
                                            subTask: task[index]["subtask"],
                                            done: index < completedTasks.length
                                                ? completedTasks[index]
                                                : 0,
                                            uId: widget.uId,
                                            chId: widget.chId,
                                            coId: widget.coId,
                                            liveID: task[index]["_id"],
                                          );
                                        }));
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
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
                      print("aob");
                      print(result);
                      if (result != null) {
                        setState(() {
                          task = result;
                          print(task);
                        });
                      }
                    },
                    child: Center(
                      child: const Text(
                        "Click to Add some tasks",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
        ],
      ),
      //   ),
      // ),
    );
  }
}
