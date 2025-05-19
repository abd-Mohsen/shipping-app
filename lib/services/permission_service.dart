import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      print("already granted permission");
    } else if (status.isDenied) {
      await permission.request().isGranted ? print("permission granted") : print("permission denied");
    } else {
      print("permission granted forever.."); // todo: show dialog
    }
  }
}
