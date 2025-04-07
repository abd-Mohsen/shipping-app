import 'dart:ui';
import 'package:get/get.dart';

class ScreenService extends GetxService {
  late double screenHeightCm;

  Future<ScreenService> init() async {
    //todo(later): this code is deprecated and returns wrong results, copy from letia
    final screenHeightPixels = window.physicalSize.height; // Total height in pixels
    final pixelRatio = window.devicePixelRatio; // Pixel density
    final dpi = pixelRatio * 160; // Dots per inch
    final inches = screenHeightPixels / dpi; // Height in inches
    screenHeightCm = inches * 2.54; // Convert inches to cm
    return this;
  }
}
