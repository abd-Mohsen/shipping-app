import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final String pageName;
  const AuthBackground({
    super.key,
    required this.child,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    String topImage = pageName != "otp" ? "assets/images/auth_top1.png" : "assets/images/auth_top2.png";
    String bottomImage = "assets/images/login_bottom.png";

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Get.dialog(kCloseAppDialog());
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        //resizeToAvoidBottomInset: false,
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
              if (pageName != "register")
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
