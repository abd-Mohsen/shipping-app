import 'package:flutter/material.dart';

class DrawerCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  final Widget? trailing;
  final Color? textColor;
  final bool? isMarked;

  const DrawerCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
    this.textColor,
    this.isMarked,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return ListTile(
      leading: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(100),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: cs.surface,
          foregroundColor: cs.primary,
          child: Icon(icon, size: 22),
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: tt.labelMedium!.copyWith(color: textColor ?? cs.onSurface),
          ),
          if (isMarked ?? false)
            //Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: CircleAvatar(
            //     backgroundColor: kNotificationColor,
            //     radius: 5,
            //   ),
            // ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.error,
                  color: Color(0xFFF1C68B),
                )),
        ],
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            color: cs.primary,
            size: 16,
          ),
      onTap: onTap,
    );
  }
}
