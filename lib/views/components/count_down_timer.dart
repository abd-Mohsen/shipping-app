import 'dart:async';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final DateTime startTime;
  final Duration countdownDuration;
  final TextStyle textStyle;
  final VoidCallback? onFinished; // ✅ Callback when timer finishes

  const CountDownTimer({
    super.key,
    required this.startTime,
    required this.countdownDuration,
    required this.textStyle,
    this.onFinished,
  });

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration remaining = Duration.zero;
  Timer? _timer;
  bool _finishedCalled = false;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    final endTime = widget.startTime.add(widget.countdownDuration);
    final now = DateTime.now();
    setState(() {
      remaining = endTime.difference(now);
      if (remaining.isNegative) {
        remaining = Duration.zero;
      }
    });

    // Call callback exactly once when finished
    if (remaining == Duration.zero && !_finishedCalled) {
      _finishedCalled = true;
      widget.onFinished?.call();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemaining();
      if (remaining == Duration.zero) {
        _timer?.cancel();
      }
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (remaining == Duration.zero) {
      return const SizedBox.shrink(); // disappears when finished
    }
    return Text(
      _formatDuration(remaining),
      style: widget.textStyle,
    );
  }
}
