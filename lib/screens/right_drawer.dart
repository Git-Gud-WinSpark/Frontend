import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/task_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RightDrawer extends ConsumerStatefulWidget {
  const RightDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RightDrawerState();
}

class _RightDrawerState extends ConsumerState<RightDrawer> {
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
          Padding(
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
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        child: ListTile(
                          title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Task 1'),
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return TaskScreen();
                              }));
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Task 2'),
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
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
