import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({
    super.key,
    required this.child,
    this.topImage = "assets/images/main_top.png",
    this.bottomImage = "assets/images/login_bottom.png",
  });

  final String topImage, bottomImage;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Get.dialog(kCloseAppDialog());
      },
      child: Scaffold(
        backgroundColor: cs.background,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  topImage,
                  width: 120,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(bottomImage, width: 120),
              ),
              SafeArea(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
