import 'package:flutter/material.dart';

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
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final bool? obscure;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscure ?? false,
        maxLines: maxLines,
        minLines: maxLines,
        decoration: InputDecoration(
          //filled: true,
          fillColor: const Color(0xFFf9eaee),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 1.5, color: cs.onSurface),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 1.5, color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 1.5, color: cs.onSurface),
          ),
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
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          //hintText: "password".tr,
          hintText: label,
          hintStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: tt.titleSmall!.copyWith(color: cs.onSurface),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}