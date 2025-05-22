import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'constants.dart';

//todo find a way to cancel all running requests after logging out
//todo handle handshake exception when ssl is expired
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

      handleSessionExpired(response.statusCode, canRefresh);

      if (response.statusCode >= 500) kServerErrorSnackBar();

      //handleError(response.statusCode, responseBody); //see if you ever need it in get requests
      return response.statusCode == 200 ? responseBody : null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } on SocketException {
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
    bool toMyServer = true,
  }) async {
    print("sending to ${toMyServer ? "$_hostIP/" : ""}$endPoint");
    if (auth) print("Token $accessToken");
    print('Request body: ${jsonEncode(body)}');
    try {
      var response = await client
          .post(
            Uri.parse("${toMyServer ? "$_hostIP/" : ""}$endPoint"),
            headers: !auth
                ? headers
                : {
                    ...headers,
                    "Authorization": "Token $accessToken",
                  },
            body: jsonEncode(body),
          )
          .timeout(kTimeOutDuration2);
      String responseBody = utf8.decode(latin1.encode(response.body));
      print("$responseBody =========== ${response.statusCode}");

      handleSessionExpired(response.statusCode, canRefresh);

      if (response.statusCode >= 500) kServerErrorSnackBar();

      handleError(response.statusCode, responseBody);
      return (response.statusCode == 200 || response.statusCode == 201) ? responseBody : null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } on SocketException {
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
    print("sending to $_hostIP/$endPoint");
    if (auth) print("Token $accessToken");
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

      handleSessionExpired(response.statusCode, canRefresh);

      if (response.statusCode >= 500) kServerErrorSnackBar();

      String responseBody = utf8.decode(latin1.encode(response.body));
      print(responseBody + "===========" + response.statusCode.toString());

      handleError(response.statusCode, responseBody);
      return (response.statusCode == 200 || response.statusCode == 201) ? responseBody : null;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } on SocketException {
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

      handleSessionExpired(response.statusCode, canRefresh);

      print("${response.body}===========${response.statusCode}");

      if (response.statusCode >= 500) kServerErrorSnackBar();

      handleError(response.statusCode, response.body);
      return response.statusCode == 204 || response.statusCode == 200;
    } on TimeoutException {
      if (showTimeout) kTimeOutSnackBar();
      return false;
    } on SocketException {
      if (showTimeout) kTimeOutSnackBar();
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String?> requestWithFiles(
    String endPoint,
    Map<String, File?> images,
    Map<String, String> body, {
    bool auth = false,
    bool canRefresh = true,
    bool showTimeout = true,
    bool utf8Decode = true,
    String methodType = "POST",
  }) async {
    print("sending to $_hostIP/$endPoint");
    if (auth) print("Token $accessToken");
    print(body);
    try {
      var request = http.MultipartRequest(
        methodType,
        Uri.parse("$_hostIP/$endPoint"),
      );

      request.headers.addAll({
        ...headers,
        if (auth) "Authorization": "Token $accessToken",
      });

      body.removeWhere((k, v) => v == "");

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

      var response = await request.send().timeout(kTimeOutDurationLong);
      String responseBody = await response.stream.bytesToString();
      if (utf8Decode) responseBody = utf8.decode(latin1.encode(responseBody));
      print("$responseBody===========${response.statusCode}");

      handleSessionExpired(response.statusCode, canRefresh);

      if (response.statusCode >= 500) kServerErrorSnackBar();

      handleError(response.statusCode, responseBody);
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
    } on SocketException {
      if (showTimeout) kTimeOutSnackBar();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void handleError(int statusCode, String json) {
    if (statusCode < 400 || statusCode >= 500) return; //check if this is integer division
    Map<String, dynamic> response = jsonDecode(json);
    String title = "";
    String content = "";
    if (response.containsKey("error")) {
      title = "error";
      content = response["error"];
    } else if (response.containsKey("message")) {
      title = "error";
      content = response["message"];
    } else {
      title = response.keys.first;
      content = response.values.first.first;
    }

    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title.tr, style: TextStyle(color: Colors.black)),
          content: Text(content.tr, style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "ok",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        barrierDismissible: false);

    // {"phone_number":["This field must be unique."]}
  }

  //todo: test
  void handleSessionExpired(int statusCode, bool canRefresh) {
    if (!canRefresh || statusCode != 401) return;
    _getStorage.remove("token");
    _getStorage.remove("role");
    Get.dialog(kSessionExpiredDialog(), barrierDismissible: false);
  }
}
