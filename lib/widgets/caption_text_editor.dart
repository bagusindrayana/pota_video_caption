import 'package:flutter/material.dart';
import 'package:pota_video_caption/utils/utils.dart' as utils;
import 'package:pota_video_caption/utils/ffmpeg_helper.dart' as ffmpeg_helper;

class CaptionTextEditor extends StatelessWidget {
  final ffmpeg_helper.Caption caption;
  final Function onSaved;

  const CaptionTextEditor({
    required this.caption,
    required this.onSaved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: caption.text,
    );
    final FocusNode focusNode = FocusNode();

    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Add a delete button on the top right corner
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: null,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (v) {
              caption.text = controller.text;
              onSaved.call();
            },
          ),
        ),
      ],
    );
  }
}
