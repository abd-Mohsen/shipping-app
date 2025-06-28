import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnlineSocketController extends GetxController {
  @override
  void onInit() {
    _connectSocket();
    super.onInit();
  }

  WebSocket? onlineWebsocket;

  final GetStorage _getStorage = GetStorage();

  bool _isOnlineWebSocketConnected() {
    return onlineWebsocket != null && onlineWebsocket!.readyState == WebSocket.open;
  }

  final Duration _initialReconnectDelay = const Duration(seconds: 5);

  bool _isConnecting = false;

  void _connectSocket() async {
    if (_isConnecting) return;
    if (_isOnlineWebSocketConnected()) return;

    _isConnecting = true;

    try {
      await _cleanUpWebSocket();

      String socketUrl = 'wss://shipping.adadevs.com/ws/connected-users/?token=${_getStorage.read("token")}';

      onlineWebsocket = await WebSocket.connect(socketUrl).timeout(const Duration(seconds: 20));

      onlineWebsocket!.listen(
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

  Future<void> _cleanUpWebSocket() async {
    if (onlineWebsocket != null) {
      try {
        await onlineWebsocket!.close();
      } catch (_) {}
      onlineWebsocket = null;
    }
  }

  void _scheduleReconnect() {
    Future.delayed(_initialReconnectDelay, () {
      _connectSocket();
    });
  }

  @override
  void onClose() async {
    await _cleanUpWebSocket();
    super.dispose();
  }
}
