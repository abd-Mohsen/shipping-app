import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

class CompressImageService {
  Future<XFile> compressImage(XFile file, {int maxSizeMB = 2}) async {
    final originalFile = File(file.path);
    final originalSize = await originalFile.length();
    final maxSizeBytes = maxSizeMB * 1024 * 1024;

    print("before compressing: ${originalSize / (1024 * 1024)} mb");

    // If already under max size, return original
    if (originalSize <= maxSizeBytes) return file;

    // Calculate quality ratio (with non-linear adjustment)
    double sizeRatio = maxSizeBytes / originalSize;

    // Non-linear quality calculation (works better for JPEG)
    // These values were determined empirically for good results
    int quality;
    if (sizeRatio > 0.9) {
      quality = 85;
    } else if (sizeRatio > 0.7) {
      quality = 70;
    } else if (sizeRatio > 0.5) {
      quality = 55;
    } else if (sizeRatio > 0.3) {
      quality = 40;
    } else {
      quality = 30;
    }

    XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      file.path + '_compressed.jpg',
      quality: quality,
    );

    final resFile = File(result!.path);
    final resSize = await resFile.length();
    print("after compressing: ${resSize / (1024 * 1024)} mb");

    return result ?? file;
  }
}
