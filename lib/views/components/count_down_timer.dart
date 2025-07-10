import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startTime;

  CountdownTimer({required this.startTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  String _timeLeft = "10:00";

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final endTime = widget.startTime.add(Duration(minutes: 10));
      final remaining = endTime.difference(now);

      if (remaining.isNegative) {
        setState(() {
          _timeLeft = "00:00";
        });
        _timer.cancel();
      } else {
        final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
        setState(() {
          _timeLeft = "$minutes:$seconds";
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeLeft,
      style: TextStyle(fontSize: 24),
    );
  }
}
