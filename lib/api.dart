import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'constants.dart';

//todo (later): show different snackbar if there is a server error "5--"
//todo (later): show different snackbar if there is a user error "422" (register and login), show msg from backend
//todo (later): replace ugly dialogs with snackbars
class Api {
  var client = http.Client();
  final String _hostIP = "$kHostIP/en/api";
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
    bool toMyServer = true,
    bool utf8Decode = true,
  }) async {
    print("sending to ${toMyServer ? "$_hostIP/" : ""}$endPoint");
    print("Token $accessToken");
    try {
      var response = await client
          .get(
            Uri.parse("${toMyServer ? "$_hostIP/" : ""}$endPoint"),
            headers: !auth ? headers : {...headers, "Authorization": "Token $accessToken"},
          )
          .timeout(kTimeOutDuration);

      String responseBody = utf8Decode ? utf8.decode(latin1.encode(response.body)) : response.body;
      print("$responseBody =========== ${response.statusCode}");

      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }
      return response.statusCode == 200 ? responseBody : null;
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
    print("sending to $_hostIP/$endPoint");
    if (auth) print("Token $accessToken");
    try {
      var response = await client
          .post(
            Uri.parse("$_hostIP/$endPoint"),
            headers: !auth
                ? headers
                : {
                    ...headers,
                    "Authorization": "Token $accessToken",
                  },
            body: jsonEncode(body),
          )
          .timeout(kTimeOutDuration);
      String responseBody = utf8.decode(latin1.encode(response.body));
      print("$responseBody =========== ${response.statusCode}");
      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }
      return (response.statusCode == 200 || response.statusCode == 201) ? responseBody : null;
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
                    "Authorization": "Token $accessToken",
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
      String responseBody = utf8.decode(latin1.encode(response.body));
      print(responseBody + "===========" + response.statusCode.toString());

      return (response.statusCode == 200 || response.statusCode == 201) ? responseBody : null;
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
            headers: !auth ? headers : {...headers, "Authorization": "Token $accessToken"},
          )
          .timeout(kTimeOutDuration2);

      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return false;
      }
      print("${response.body}===========${response.statusCode}");
      return response.statusCode == 204 || response.statusCode == 200;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String?> postRequestWithImages(
    String endPoint,
    Map<String, File?> images,
    Map<String, String> body, {
    bool auth = false,
    bool canRefresh = true,
    bool showTimeout = true,
    bool utf8Decode = true,
  }) async {
    print("sending to $_hostIP/$endPoint");
    if (auth) print("Token $accessToken");
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$_hostIP/$endPoint"),
      );

      request.headers.addAll({
        ...headers,
        if (auth) "Authorization": "Token $accessToken",
      });

      request.fields.addAll(body);

      for (var entry in images.entries) {
        String imageField = entry.key;
        File? imageFile = entry.value;
        if (imageFile == null) continue;
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          imageField,
          stream,
          length,
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send().timeout(kTimeOutDuration);
      String responseBody = await response.stream.bytesToString();
      if (utf8Decode) responseBody = utf8.decode(latin1.encode(responseBody));
      print("$responseBody===========${response.statusCode}");

      if (canRefresh && response.statusCode == 401) {
        _getStorage.remove("token");
        _getStorage.remove("role");
        Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
        return null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      }
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
      // });
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
