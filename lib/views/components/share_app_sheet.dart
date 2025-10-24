import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareAppSheet extends StatelessWidget {
  const ShareAppSheet({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    String directDownloadLink = "https://shipping.adadevs.com/en/download/app/";
    String playStoreLink = "";
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              //margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0, top: 24),
              child: Text(
                "share this app".tr,
                style: tt.titleLarge!.copyWith(color: cs.onSurface),
              ),
            ),
            // QR code with truck icon in the middle
            QrImageView(
              data: directDownloadLink,
              size: 200,
              backgroundColor: Colors.white,
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(50, 50),
              ),
              //embeddedImage: const AssetImage('assets/images/truck-icon.png'),
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: cs.primary,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: cs.primary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0),
              child: Text(
                "to share, scan the QR code above".tr,
                style: tt.labelMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
              ),
            ),

            // Divider
            Divider(color: cs.onSurface.withValues(alpha: 0.6)),

            // share the link
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.shareNodes,
                color: Colors.blue,
              ),
              title: Text(
                "share direct download link".tr,
                style: tt.titleSmall!.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                await Share.share(
                  '${"make your shipments easier and smarter with Kamiyon, to download click on the link below".tr}:'
                  '\n\n$directDownloadLink',
                  subject: "Kamiyon App".tr,
                );
                Get.back();
              },
            ),

            // ListTile for Play Store link
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.googlePlay,
                color: Colors.green,
              ),
              title: Text(
                "View in Play Store".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                final uri = Uri.parse(playStoreLink);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  print("Could not open the link");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
