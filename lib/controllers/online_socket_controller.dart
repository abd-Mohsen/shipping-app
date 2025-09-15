import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnlineSocketController extends GetxController {
  WebSocket? websocket;
  Timer? timer;
  final GetStorage _getStorage = GetStorage();

  final Duration _initialReconnectDelay = const Duration(seconds: 5);
  bool _isConnecting = false;
  bool _shouldReconnect = true; // 🔑 new flag

  @override
  void onInit() {
    _connectSocket();
    // startPinging();
    super.onInit();
  }

  bool _isWebSocketConnected() {
    return websocket != null && websocket!.readyState == WebSocket.open;
  }

  void _connectSocket() async {
    if (_isConnecting || _isWebSocketConnected()) return;
    _isConnecting = true;

    try {
      await _cleanUpWebSocket();

      String socketUrl = 'wss://shipping.adadevs.com/ws/connected-users/?token=${_getStorage.read("token")}';

      websocket = await WebSocket.connect(socketUrl).timeout(const Duration(seconds: 20));

      websocket!.listen(
        (message) {
          print('Message from server: $message');
        },
        onDone: () {
          _cleanUpWebSocket();
          _scheduleReconnect();
        },
        onError: (error) {
          _cleanUpWebSocket();
          _scheduleReconnect();
        },
      );
    } catch (e) {
      print('Connection attempt failed: $e');
      _cleanUpWebSocket();
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void startPinging() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      try {
        if (_isWebSocketConnected()) {
          websocket!.add(json.encode({"type": "ping"}));
          print("ping");
        }
      } catch (e) {
        print("Error sending ping: $e");
      }
    });
  }

  Future<void> _cleanUpWebSocket() async {
    timer?.cancel();
    timer = null;

    if (websocket != null) {
      try {
        await websocket!.close();
      } catch (e) {
        print("Error closing socket: $e");
      }
      websocket = null;
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return; // 🔑 only reconnect if allowed
    Future.delayed(_initialReconnectDelay, () {
      _connectSocket();
    });
  }

  @override
  void onClose() {
    _shouldReconnect = false; // 🔑 stop reconnect loop
    _cleanUpWebSocket();
    super.onClose();
  }
}
