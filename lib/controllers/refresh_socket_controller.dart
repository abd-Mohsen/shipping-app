import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/shared_home_controller.dart';

class RefreshSocketController extends GetxController {
  SharedHomeController sHC = Get.find();
  WebSocket? websocket;
  final GetStorage _getStorage = GetStorage();

  final Duration _initialReconnectDelay = const Duration(seconds: 5);
  bool _isConnecting = false;
  bool _shouldReconnect = true;

  @override
  void onInit() {
    _connectSocket();
    super.onInit();
  }

  bool _isWebSocketConnected() {
    return websocket != null && websocket!.readyState == WebSocket.open;
  }

  void sendLocationID(int id) {
    if (!_isWebSocketConnected()) return;
    websocket!.add(json.encode({
      "type": "switch_location",
      "location_id": id,
    }));
  }

  void _connectSocket() async {
    if (_isConnecting || _isWebSocketConnected()) return;
    _isConnecting = true;

    try {
      await _cleanUpWebSocket();

      String socketUrl = 'wss://shipping.adadevs.com/ws/changes/?token=${_getStorage.read("token")}&';
      //'${governorateID == 0 ? "" : "location_id=$governorateID"}';

      websocket = await WebSocket.connect(socketUrl).timeout(const Duration(seconds: 20));

      websocket!.listen(
        (message) async {
          final decoded = jsonDecode(message);
          if (decoded["type"] == "group_switched") return;
          await sHC.refreshEverything();
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
    if (websocket != null) {
      try {
        await websocket!.close();
      } catch (_) {}
      websocket = null;
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    Future.delayed(_initialReconnectDelay, () {
      _connectSocket();
    });
  }

  @override
  void onClose() {
    _shouldReconnect = false; // prevent auto-reconnect
    _cleanUpWebSocket();
    super.onClose();
  }
}
