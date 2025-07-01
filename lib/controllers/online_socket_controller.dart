import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnlineSocketController extends GetxController {
  @override
  void onInit() {
    _connectSocket();
    //startPinging();
    super.onInit();
  }

  WebSocket? websocket;

  final GetStorage _getStorage = GetStorage();

  bool _isWebSocketConnected() {
    return websocket != null && websocket!.readyState == WebSocket.open;
  }

  final Duration _initialReconnectDelay = const Duration(seconds: 5);

  bool _isConnecting = false;

  void _connectSocket() async {
    if (_isConnecting) return;
    if (_isWebSocketConnected()) return;

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

  Timer? timer;

  void startPinging() async {
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      try {
        if (_isWebSocketConnected()) {
          websocket!.add(json.encode({"type": "ping"}));
          print("ping");
        } else {
          // Handle reconnection
          //_reconnectWebSocket();
        }
      } catch (e) {
        print("Error getting location: $e");
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
        print(e.toString());
      }
      websocket = null;
    }
  }

  void _scheduleReconnect() {
    Future.delayed(_initialReconnectDelay, () {
      _connectSocket();
    });
  }

  @override
  void onClose() async {
    //todo: not disposing (because 2 instances are running?)
    await _cleanUpWebSocket();
    super.dispose();
  }
}
