import 'package:another_stepper/another_stepper.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend/services/completeTask.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({
    super.key,
    required this.subTask,
    required this.done,
    required String this.uId,
    required String this.coId,
    required String this.chId,
    required String this.liveID,
  });
  final String uId;
  final String coId;
  final String chId;
  final List<dynamic> subTask;
  final int done;
  final String liveID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  double currentPercent = 0.0;
  Duration _parseDuration(String timeSpent) {
    final parts = timeSpent.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  late CustomTimerController _controller;
  Duration? duration;
  @override
  void initState() {
    duration = _parseDuration(widget.subTask[_currentIndex]['timeSpent']);
    _controller = CustomTimerController(
        vsync: this,
        begin: duration!,
        end: Duration(),
        initialState: CustomTimerState.reset,
        interval: CustomTimerInterval.milliseconds);

    _currentIndex = widget.done;
    currentPercent = _currentIndex / widget.subTask.length;
    // TODO: implement initState
    super.initState();
  }

  void setComplete() async {
    var res = await completeTask(
        token: widget.uId,
        communityID: widget.coId,
        channelID: widget.chId,
        taskID: widget.liveID,
        subID: widget.subTask[_currentIndex]["_id"]);
    print(res);
  }

  void onFinished() async {
    setState(() {
      if (_currentIndex < widget.subTask.length - 1) {
        _currentIndex++;
        duration = _parseDuration(widget.subTask[_currentIndex]['timeSpent']);
        _controller.begin = duration!;
      }
      setComplete();
    });
    if (currentPercent < 1) {
      currentPercent += (1 / widget.subTask.length);
    }
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    // print("Reneder $_currentIndex $duration");
    _controller.state.addListener(() {
      if (_controller.state.value == CustomTimerState.finished) {
        onFinished();
      }
    });
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
            percent: currentPercent,
            // center: const Text("50.0% Completed"),
            barRadius: Radius.circular(8),
            progressColor: Colors.blue,
          ),
          Text(
            "${currentPercent * 100}% Completed",
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
              activeIndex: _currentIndex,
              stepperList: [
                for (var index = 0; index < widget.subTask.length; index++)
                  StepperData(
                    // WHat i can do is make an interactive icon like start and pause and when the task finishes show tick mark and move to next one.
                    title: StepperText(widget.subTask[index]["name"]),
                  ),
              ],
              stepperDirection: Axis.vertical,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTimer(
            controller: _controller,
            builder: (state, time) {
              // Build the widget you want!🎉
              return Text(
                  "${time.hours}:${time.minutes}:${time.seconds}.${time.milliseconds}",
                  style: TextStyle(fontSize: 24.0));
            },
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedButton(
                text: "Start",
                color: Colors.green,
                onPressed: () => _controller.start(),
              ),
              RoundedButton(
                text: "Pause",
                color: Colors.blue,
                onPressed: () => _controller.pause(),
              ),
              RoundedButton(
                text: "Reset",
                color: Colors.red,
                onPressed: () => _controller.reset(),
              ),
              RoundedButton(
                text: "Finish",
                color: Colors.red,
                onPressed: () {
                  onFinished();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onPressed;

  RoundedButton({required this.text, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text, style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: onPressed,
    );
  }
}
