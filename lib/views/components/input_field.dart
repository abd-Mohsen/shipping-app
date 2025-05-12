import 'package:flutter/material.dart';

//todo: try to decrease field height
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
    required this.validator,
    required this.onChanged,
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
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final void Function(String?) onChanged;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    border() {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 0.5, color: cs.surface),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType ?? TextInputType.text,
          obscureText: obscure ?? false,
          maxLines: maxLines,
          minLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            //fillColor: const Color(0xFFf9eaee),
            fillColor: cs.secondaryContainer,
            focusedBorder: border(),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(width: 1.5, color: Colors.transparent),
            ),
            enabledBorder: border(),
            // border: const OutlineInputBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(32)),
            //   borderSide: BorderSide(width: 1),
            // ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(width: 1, color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(width: 1.5, color: Colors.red),
            ),
            //hintText: "password".tr,
            labelText: label,
            labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
            // hintText: label,
            // hintStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(
                prefixIcon,
                color: cs.primary,
                size: 22,
              ),
            ),
            suffixIcon: suffixIcon,
            floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.never,
          ),
          style: tt.titleSmall!.copyWith(color: cs.onSurface),
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
