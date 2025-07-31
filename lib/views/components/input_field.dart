import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.keyboardType,
    required this.label,
    this.obscure,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor,
    required this.validator,
    required this.onChanged,
    this.onTapOutside,
    this.minLines,
    this.maxLines,
    this.floatingLabelBehavior,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final bool? obscure;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Color? iconColor;
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final void Function(String?) onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    OutlineInputBorder border({Color? color, double width = 0.5}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: width,
          color: color ?? (Get.isDarkMode ? cs.surface : Colors.grey.shade400), // Fake shadow color
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscure ?? false,
        maxLines: maxLines,
        minLines: minLines ?? 1,
        decoration: InputDecoration(
          filled: true,
          fillColor: cs.secondaryContainer,
          focusedBorder: border(width: 2),
          enabledBorder: border(width: 1.5),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          labelText: label,
          labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Icon(
              prefixIcon,
              color: iconColor ?? cs.primary,
              size: 22,
            ),
          ),
          suffixIcon: suffixIcon,
          floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.never,
        ),
        style: tt.titleSmall!.copyWith(color: cs.onSurface),
        validator: validator,
        onChanged: onChanged,
        onTapOutside: onTapOutside,
      ),
    );
  }
}
