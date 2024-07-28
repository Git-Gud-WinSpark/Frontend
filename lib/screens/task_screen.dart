import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Total Progress",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          LinearPercentIndicator(
            alignment: MainAxisAlignment.center,
            width: 300,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: 0.5,
            // center: const Text("50.0% Completed"),
            barRadius: Radius.circular(8),
            progressColor: Colors.blue,
          ),
          Text(
            "50.0% Completed",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Checklist",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: AnotherStepper(
              activeIndex: 2,
              stepperList: [
                StepperData(
                  // WHat i can do is make an interactive icon like start and pause and when the task finishes show tick mark and move to next one.
                  title: StepperText("Step 1"),
                ),
                StepperData(
                  title: StepperText("Step 2"),
                ),
                StepperData(
                  title: StepperText("Step 3"),
                ),
                StepperData(
                  title: StepperText("Step 4"),
                ),
              ],
              stepperDirection: Axis.vertical,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TimerCountdown(
            format: CountDownTimerFormat.daysHoursMinutesSeconds,
            endTime: DateTime.now().add(
              Duration(
                days: 5,
                hours: 14,
                minutes: 27,
                seconds: 34,
              ),
            ),
            onEnd: () {
              print("Timer finished");
            },
          ),
        ],
      ),
    );
  }
}
