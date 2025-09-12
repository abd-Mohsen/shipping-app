import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/shared_home_controller.dart';

class RefreshSocketController extends GetxController {
  SharedHomeController sHC = Get.find();

  @override
  void onInit() {
    _connectSocket();
    super.onInit();
  }

  WebSocket? websocket;

  final GetStorage _getStorage = GetStorage();

  bool _isWebSocketConnected() {
    return websocket != null && websocket!.readyState == WebSocket.open;
  }

  final Duration _initialReconnectDelay = const Duration(seconds: 5);

  int get governorateID => sHC.selectedGovernorate?.id ?? 0;

  bool _isConnecting = false;

  void sendLocationID(int id) {
    if (!_isWebSocketConnected()) return;
    websocket!.add(json.encode({
      "type": "switch_location",
      "location_id": id,
    }));
  }

  void _connectSocket() async {
    if (_isConnecting) return;
    if (_isWebSocketConnected()) return;

    _isConnecting = true;

    try {
      await _cleanUpWebSocket();

      String socketUrl = 'wss://shipping.adadevs.com/ws/changes/?token=${_getStorage.read("token")}&';
      //'${governorateID == 0 ? "" : "location_id=$governorateID"}';

      websocket = await WebSocket.connect(socketUrl).timeout(const Duration(seconds: 20));

      websocket!.listen(
        (message) async {
          //todo(later): in new driver tab, the list appears empty for seconds when refreshing
          //the list appears empty in recent and in driver new tab
          print('Message from server: $message');
          message = jsonDecode(message);
          if (message["type"] == "group_switched") return;
          await sHC.refreshEverything(); //todo(later): separate (new and my orders)
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
    Future.delayed(_initialReconnectDelay, () {
      _connectSocket();
    });
  }

  @override
  void onClose() async {
    //todo(later): not disposing (because 2 instances are running?)
    await _cleanUpWebSocket();
    super.dispose();
  }
}
