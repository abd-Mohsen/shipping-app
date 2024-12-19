import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shipment/controllers/register_controller.dart';
import 'package:get/get.dart';

import 'components/auth_background.dart';
import 'components/auth_field.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    RegisterController rC = Get.put(RegisterController());

    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Register".toUpperCase(),
                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                  ),
                ),
                Row(
                  children: [
                    //const Spacer(),
                    Expanded(
                      flex: 3,
                      //todo: replace png with svg to save space
                      child: Hero(
                        tag: "auth_image",
                        child: SizedBox(
                          height: 200,
                          child: CarouselView(
                            //todo: replace with the package, and add worm
                            backgroundColor: Colors.transparent,
                            itemSnapping: true,
                            itemExtent: MediaQuery.of(context).size.width,
                            children: List.generate(
                              4,
                              (i) => Column(
                                children: [
                                  SizedBox(height: 150, child: Image.asset('assets/images/${rC.roles[i]}.png')),
                                  Text(
                                    rC.roles[i],
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //const Spacer(),
                  ],
                ),
                //const SizedBox(height: 8),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Form(
                    key: rC.registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AuthField(
                          controller: rC.firstName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          label: "first name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.person, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rC.firstName.text, 4, 50, "");
                          },
                          onChanged: (val) {
                            if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                          },
                        ),
                        AuthField(
                          controller: rC.middleName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          label: "middle name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.person, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rC.middleName.text, 4, 50, "");
                          },
                          onChanged: (val) {
                            if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                          },
                        ),
                        AuthField(
                          controller: rC.lastName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          label: "last name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.person, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rC.lastName.text, 4, 50, "");
                          },
                          onChanged: (val) {
                            if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                          },
                        ),
                        AuthField(
                          controller: rC.phone,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          label: "phone",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.phone_android, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rC.phone.text, 4, 50, "phone");
                          },
                          onChanged: (val) {
                            if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                          },
                        ),
                        GetBuilder<RegisterController>(
                          builder: (controller) {
                            return AuthField(
                              controller: rC.password,
                              obscure: !controller.passwordVisible,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              label: "password",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.lock, color: cs.primary),
                              ),
                              suffixIcon: controller.passwordVisible
                                  ? GestureDetector(
                                      onTap: () => controller.togglePasswordVisibility(false),
                                      child: Icon(CupertinoIcons.eye_slash_fill, color: cs.primary),
                                    )
                                  : GestureDetector(
                                      onTap: () => controller.togglePasswordVisibility(true),
                                      child: Icon(CupertinoIcons.eye_fill, color: cs.primary),
                                    ),
                              validator: (val) {
                                return validateInput(rC.password.text, 4, 50, "password",
                                    pass: rC.password.text, rePass: rC.rePassword.text);
                              },
                              onChanged: (val) {
                                if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                              },
                            );
                          },
                        ),
                        GetBuilder<RegisterController>(
                          builder: (controller) {
                            return AuthField(
                              controller: rC.rePassword,
                              obscure: !controller.rePasswordVisible,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              label: "re enter password",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.lock, color: cs.primary),
                              ),
                              suffixIcon: controller.rePasswordVisible
                                  ? GestureDetector(
                                      onTap: () => controller.toggleRePasswordVisibility(false),
                                      child: Icon(CupertinoIcons.eye_slash_fill, color: cs.primary),
                                    )
                                  : GestureDetector(
                                      onTap: () => controller.toggleRePasswordVisibility(true),
                                      child: Icon(CupertinoIcons.eye_fill, color: cs.primary),
                                    ),
                              validator: (val) {
                                return validateInput(rC.rePassword.text, 4, 50, "password",
                                    pass: rC.password.text, rePass: rC.rePassword.text);
                              },
                              onChanged: (val) {
                                if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        GetBuilder<RegisterController>(
                          builder: (controller) {
                            return ElevatedButton(
                              onPressed: () {
                                controller.register();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: controller.isLoading
                                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                        : Text(
                                            "register".toUpperCase(),
                                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
