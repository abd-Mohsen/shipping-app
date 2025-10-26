import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSelector extends StatelessWidget {
  final TimeOfDay? time;
  final void Function(TimeOfDay) selectTimeCallback;

  const TimeSelector({
    super.key,
    required this.time,
    required this.selectTimeCallback,
  });

  // 🔹 Custom formatter to show Morning/Night instead of AM/PM
  String _formatCustomTime(BuildContext context, TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final isMorning = time.period == DayPeriod.am;

    // You can translate or localize these if needed, e.g. "morning".tr
    return "$hour:$minute ${isMorning ? 'morning'.tr : 'evening'.tr}";
  }

  Future<void> _showCupertinoTimePickerDialog(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time?.hour ?? now.hour,
      time?.minute ?? now.minute,
    );

    DateTime tempDateTime = initialDateTime;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "desired time".tr,
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false, // ✅ 12-hour format
              onDateTimeChanged: (DateTime newDateTime) {
                tempDateTime = newDateTime;
              },
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                "cancel".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                selectTimeCallback(
                  TimeOfDay(hour: tempDateTime.hour, minute: tempDateTime.minute),
                );
              },
              child: Text(
                "ok".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          await _showCupertinoTimePickerDialog(context);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Icon(Icons.watch_later_outlined, color: cs.primary),
            ),
            Text(
              "desired time".tr,
              style: tt.labelMedium!.copyWith(color: cs.onSurface),
            ),
          ],
        ),
        subtitle: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: time != null
                ? Text(
                    _formatCustomTime(context, time!), // ✅ Custom formatter
                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  )
                : Text(
                    "select time".tr,
                    style: tt.titleSmall!.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
