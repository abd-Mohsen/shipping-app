import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startTime;

  const CountdownTimer({required this.startTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late DateTime _endTime;
  String _timeLeft = "10:00";

  @override
  void initState() {
    super.initState();
    _endTime = widget.startTime.add(Duration(minutes: 10));
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remaining = _endTime.difference(now);

      if (remaining <= Duration(seconds: 0)) {
        setState(() {
          _timeLeft = "0:0";
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
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Text(
      _timeLeft,
      style: tt.titleSmall!.copyWith(color: cs.onPrimary),
    );
  }
}
