import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadImageService {
  Future<XFile?> downloadImage(String imageUrl) async {
    if (imageUrl.endsWith("null")) return null;
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));

      // Get the document directory path
      final documentDirectory = await getTemporaryDirectory();

      // Generate a unique filename using the image URL's hash code
      final uniqueFileName = 'image_${imageUrl.hashCode}.jpg';

      // Create a file in the temporary directory with the unique filename
      final file = File('${documentDirectory.path}/$uniqueFileName');

      // Write the image bytes to the file
      file.writeAsBytesSync(response.bodyBytes);

      // Create an XFile from the file
      return XFile(file.path);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
