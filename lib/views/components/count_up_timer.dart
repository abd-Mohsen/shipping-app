import 'dart:async';
import 'package:flutter/material.dart';

class CountUpTimer extends StatefulWidget {
  final Duration startDuration;
  final TextStyle textStyle;

  const CountUpTimer({super.key, required this.startDuration, required this.textStyle});

  @override
  _CountUpTimerState createState() => _CountUpTimerState();
}

class _CountUpTimerState extends State<CountUpTimer> {
  late Duration elapsed;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    elapsed = widget.startDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsed += const Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(elapsed),
      style: widget.textStyle,
    );
  }
}
