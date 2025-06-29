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
    this.onSubmit,
    this.fillColor,
    this.fontColor,
    this.bordered,
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
  final void Function(String?)? onSubmit;
  final Color? fillColor;
  final Color? fontColor;
  final bool? bordered;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    OutlineInputBorder border1({Color? color, double width = 0.5}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: width,
          color: color ?? (Get.isDarkMode ? cs.surface : Colors.grey.shade300), // Fake shadow color
        ),
      );
    }

    OutlineInputBorder border2({Color? color, double width = 0.5}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: width,
          color: color ?? Colors.transparent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? const Color(0xFFf9eaee),
          focusedBorder: bordered ?? false ? border1(width: 2) : border2(),
          disabledBorder: bordered ?? false ? border1(width: 1.5) : border2(),
          enabledBorder: bordered ?? false ? border1(width: 1.5) : border2(),
          border: bordered ?? false ? border1(width: 1.5) : border2(),
          errorBorder: border2(color: Colors.red, width: 1),
          focusedErrorBorder: border2(color: Colors.red, width: 2),
          //hintText: "password".tr,
          hintText: label,
          hintStyle: tt.titleSmall!.copyWith(color: fontColor?.withOpacity(0.5) ?? Colors.black.withOpacity(0.5)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: tt.titleSmall!.copyWith(color: fontColor ?? Colors.black),
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmit,
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
  bool floatingPointNumber = false,
  int lowerRange = 0,
  int upperRange = 1000000000000000000,
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

  if (wholeNumber) {
    final RegExp numericRegExp = RegExp(r'^[0-9]+$');
    if (!numericRegExp.hasMatch(val)) return "enter a whole number".tr;
    int num = int.parse(val);
    if (num > upperRange) return "${"cannot be greater".tr} ${"than".tr} $upperRange";
    if (num < lowerRange) return "${"cannot be less".tr} ${"than".tr} $lowerRange";
  }

  if (floatingPointNumber) {
    if (double.tryParse(val) == null) return "enter a whole number".tr;
  }

  if (val.length < min) return "${"cannot be shorter".tr} ${"than".tr} $min ${"characters".tr}";
  if (val.length > max) return "${"cannot be longer".tr} ${"than".tr} $max ${"characters".tr}";

  if (pass != rePass) return "passwords don't match".tr;

  if (english) {
    final RegExp englishRegExp = RegExp(r'^[a-zA-Z\d_\-\s]+$');
    if (!englishRegExp.hasMatch(val)) return "must be english".tr; // todo doesnt accept empty spaces (test)
  }

  return null;
}
