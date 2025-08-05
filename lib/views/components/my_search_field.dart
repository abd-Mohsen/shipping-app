import 'package:flutter/material.dart';

class MySearchField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final Widget icon;
  final void Function(String?)? onSubmit;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onTapField;
  final void Function()? onTapSuffix;
  final void Function(String?)? onChanged;

  const MySearchField({
    super.key,
    required this.label,
    required this.textEditingController,
    required this.icon,
    this.onSubmit,
    this.onTapOutside,
    this.onTapField,
    this.onTapSuffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            blurRadius: 2, // Soften the shadow
            spreadRadius: 1, // Extend the shadow
            offset: const Offset(1, 1), // Shadow direction (x, y)
          ),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          constraints: const BoxConstraints(maxHeight: 43),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: icon,
          ),
          suffixIcon: onTapSuffix == null
              ? null
              : GestureDetector(
                  onTap: onTapSuffix,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.close, color: cs.primaryContainer),
                  ),
                ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          //fillColor: Color.lerp(cs.primary.withOpacity(0.5), Colors.white, 0.5),
          fillColor: cs.secondaryContainer,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              label,
              style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer.withValues(alpha: 0.6)),
            ),
          ),
        ),
        style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer),
        onSubmitted: onSubmit,
        onTap: onTapField,
        onTapOutside: onTapOutside,
        onChanged: onChanged,
      ),
    );
  }
}
