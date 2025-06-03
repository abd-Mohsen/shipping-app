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

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () async {
          TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          selectTimeCallback(newTime!);
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
        // leading: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 6),
        //   child: Icon(Icons.watch_later_outlined, color: cs.onSurface),
        // ),
        subtitle: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: time != null
                ? Text(
                    time!.format(context),
                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  )
                : Text(
                    "select time".tr,
                    style: tt.titleSmall!.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(width: 0.7, color: cs.onSurface),
        //   borderRadius: BorderRadius.circular(20),
        // ),
      ),
    );
  }
}
