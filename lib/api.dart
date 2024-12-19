import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'constants.dart';

//todo (later): show different snackbar if there is a server error "5--"
//todo (later): show different snackbar if there is a user error "422"
//todo (later): replace ugly dialogs with snackbars
class Api {
  var client = http.Client();
  final String _hostIP = "$kHostIP/api";
  final _getStorage = GetStorage();
  String get accessToken => _getStorage.read("token");

  Map<String, String> headers = {
    "Accept": "Application/json",
    "Content-Type": "application/json",
    "sent-from": "mobile",
  };

  Future<String?> getRequest(
    String endPoint, {
    bool auth = false,
    bool canRefresh = true,
    bool showTimeout = true,
  }) async {
    try {
      var response = await client
          .get(
            Uri.parse("$_hostIP/$endPoint"),
            headers: !auth ? headers : {...headers, "Authorization": "Bearer $accessToken"},
          )
          .timeout(kTimeOutDuration);
      print(response.body + "===========" + response.statusCode.toString());
      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }
      return response.statusCode == 200 ? response.body : null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> postRequest(
    String endPoint,
    Map<String, dynamic> body, {
    bool auth = false,
    bool canRefresh = true,
    bool showTimeout = true,
  }) async {
    try {
      var response = await client
          .post(
            Uri.parse("$_hostIP/$endPoint"),
            headers: !auth
                ? headers
                : {
                    ...headers,
                    "Authorization": "Bearer $accessToken",
                  },
            body: jsonEncode(body),
          )
          .timeout(kTimeOutDuration);
      print(response.body);
      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }
      return (response.statusCode == 200 || response.statusCode == 201) ? response.body : null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> putRequest(
    String endPoint,
    Map<String, dynamic> body, {
    bool auth = false,
    bool canRefresh = true,
    bool showTimeout = true,
  }) async {
    try {
      var response = await client
          .put(
            Uri.parse("$_hostIP/$endPoint"),
            headers: !auth
                ? headers
                : {
                    ...headers,
                    "Authorization": "Bearer $accessToken",
                  },
            body: jsonEncode(body),
          )
          .timeout(kTimeOutDuration2);
      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }
      print(response.body);
      return (response.statusCode == 200 || response.statusCode == 201) ? response.body : null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> deleteRequest(
    String endPoint, {
    bool auth = false,
    bool canRefresh = true,
    bool showTimeout = true,
  }) async {
    try {
      var response = await client
          .delete(
            Uri.parse("$_hostIP/$endPoint"),
            headers: !auth ? headers : {...headers, "Authorization": "Bearer $accessToken"},
          )
          .timeout(kTimeOutDuration2);

      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return false;
      }
      print(response.body + "===========" + response.statusCode.toString());
      return response.statusCode == 204;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String?> postRequestWithImage(String endPoint, List<String> images, Map<String, String> body,
      {bool auth = false, bool canRefresh = true, bool showTimeout = true}) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$_hostIP/$endPoint"),
      );

      request.headers.addAll({
        ...headers,
        if (auth) "Authorization": "Bearer $accessToken",
      });

      request.fields.addAll(body);

      for (var imagePath in images) {
        File imageFile = File(imagePath);
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'images[]',
          stream,
          length,
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }

      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
