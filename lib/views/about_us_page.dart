import 'package:flutter/material.dart';
import 'package:get/get.dart';

//todo take data from api
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  /// if possible, add url launcher for the phone an email. and add website when ready.
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'About app'.tr,
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 24),
            child: Hero(
              tag: "logo",
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/logo_light.jpg",
                    height: MediaQuery.sizeOf(context).width / 2,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "تم تطوير هذا البرنامج لصالح شركة , جميع الحقوق محفوظة.",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: cs.primary),
            title: Text(
              "2222222",
              style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fax, color: cs.primary),
            title: Text(
              "2222222",
              style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language, color: cs.primary),
            title: Text(
              "example.sy",
              style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: cs.primary),
            title: Text(
              "contact@example.com",
              style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
            ),
          ),
          Divider(
            color: cs.onSurface,
            indent: 75,
            endIndent: 75,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 12, left: 12, top: 24, bottom: 12),
          //   child: Text(
          //     "للاستفسار يرجى التواصل مع المطور",
          //     style: tt.titleMedium!.copyWith(color: cs.onSurface),
          //   ),
          // ),
          // ListTile(
          //   leading: Icon(Icons.phone_android, color: cs.primary),
          //   // title: Text(
          //   //   "موبايل",
          //   //   style: tt.titleMedium!.copyWith(color: cs.onSurface),
          //   // ),
          //   title: Text(
          //     "0000000000",
          //     style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
          //   ),
          // ),
          // ListTile(
          //   leading: Icon(Icons.email, color: cs.primary),
          //   // title: Text(
          //   //   "بريد الكتروني",
          //   //   style: tt.titleMedium!.copyWith(color: cs.onSurface),
          //   // ),
          //   title: Text(
          //     "example@gmail.com",
          //     style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
