import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AssetVideoDialog extends StatefulWidget {
  const AssetVideoDialog({Key? key}) : super(key: key);

  @override
  _AssetVideoDialogState createState() => _AssetVideoDialogState();
}

class _AssetVideoDialogState extends State<AssetVideoDialog> {
  late VideoPlayerController _controller; //todo: add video

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/register_role.mp4',
    )..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _controller.value.isInitialized
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
            child: Text(
              'swipe to choose your role'.tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ok'.tr, style: tt.labelSmall!.copyWith(color: cs.onSurface)),
        ),
      ],
    );
  }
}
