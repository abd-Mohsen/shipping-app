import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    this.keyboardType,
    required this.label,
    this.obscure,
    this.textInputAction,
    required this.prefixIcon,
    this.suffixIcon,
    required this.validator,
    required this.onChanged,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final bool? obscure;
  final TextInputAction? textInputAction;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf9eaee),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 1),
          ),
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
          hintStyle: tt.titleSmall!.copyWith(color: Colors.black.withOpacity(0.5)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: tt.titleSmall!.copyWith(color: Colors.black),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

String? validateInput(
  String val,
  int min,
  int max,
  String type, {
  String pass = "",
  String rePass = "",
  bool canBeEmpty = false,
  bool english = false,
  bool wholeNumber = false,
  int lowerRange = 0,
  int upperRange = 10000000000,
}) {
  if (val.trim().isEmpty && !canBeEmpty) return "cannot be empty".tr;

  if (type == "username") {
    if (!GetUtils.isUsername(val)) return "invalid user name".tr;
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) return "invalid email".tr;
  }
  if (type == "phone") {
    final RegExp numericRegExp = RegExp(r'^[0-9]+$');
    if (!numericRegExp.hasMatch(val)) return "invalid phone".tr;
  }
  if (val.length < min) return "${"cannot be shorter".tr} ${"than".tr} $min ${"characters".tr}";
  if (val.length > max) return "${"cannot be longer".tr} ${"than".tr} $max ${"characters".tr}";

  if (pass != rePass) return "passwords don't match".tr;

  if (english) {
    final RegExp englishRegExp = RegExp(r'^[a-zA-Z\d_\-]+$');
    if (!englishRegExp.hasMatch(val)) return "must be english".tr;
  }

  if (wholeNumber) {
    final RegExp numericRegExp = RegExp(r'^[0-9]+$');
    if (!numericRegExp.hasMatch(val)) return "enter a whole number".tr;
    int num = int.parse(val);
    if (num > upperRange) return "${"cannot be greater".tr} ${"than".tr} $upperRange";
    if (num < lowerRange) return "${"cannot be less".tr} ${"than".tr} $lowerRange";
  }

  return null;
}
