import 'package:flutter/material.dart';

class MySearchField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final Widget icon;
  final void Function(String?)? onSubmit;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onTapField;

  const MySearchField({
    super.key,
    required this.label,
    required this.textEditingController,
    required this.icon,
    this.onSubmit,
    this.onTapOutside,
    this.onTapField,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: TextField(
        controller: textEditingController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          constraints: const BoxConstraints(maxHeight: 50),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: icon,
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
              style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer.withOpacity(0.5)),
            ),
          ),
        ),
        style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer),
        onSubmitted: onSubmit,
        onTap: onTapField,
        onTapOutside: onTapOutside,
      ),
    );
  }
}
