import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class DateSelector extends StatelessWidget {
  final DateTime? date;
  final void Function(DateTime) selectDateCallback;
  const DateSelector({
    super.key,
    required this.date,
    required this.selectDateCallback,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            currentDate: date,
          );
          selectDateCallback(newDate!);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Icon(Icons.date_range, color: cs.primary),
            ),
            Text(
              "desired day".tr,
              style: tt.labelMedium!.copyWith(color: cs.onSurface),
            ),
          ],
        ),
        // leading: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 6),
        //   child: Icon(Icons.date_range, color: cs.onSurface),
        // ),
        subtitle: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: date != null
                ? Text(
                    Jiffy.parseFromDateTime(date!).format(pattern: "d / M / y"),
                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  )
                : Text(
                    "select date".tr,
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
