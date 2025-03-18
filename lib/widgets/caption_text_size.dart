import 'package:flutter/material.dart';
import 'package:pota_video_caption/utils/utils.dart' as utils;
import 'package:pota_video_caption/utils/ffmpeg_helper.dart' as ffmpeg_helper;

class CaptionTextSize extends StatefulWidget {
  final ffmpeg_helper.Caption caption;
  final Function onSaved;

  const CaptionTextSize({
    required this.caption,
    required this.onSaved,
    super.key,
  });

  @override
  State<CaptionTextSize> createState() => _CaptionTextSizeState();
}

class _CaptionTextSizeState extends State<CaptionTextSize> {
  double? _currentFontSize = 24.0;
  ffmpeg_helper.Caption? caption;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentFontSize = widget.caption.fontSize?.toDouble() ?? 24.0;
    caption = ffmpeg_helper.Caption.from(widget.caption);

    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            '${_currentFontSize?.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Add a delete button on the top right corner
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Slider(
            value: _currentFontSize ?? 24.0,
            min: 8.0,
            max: 72.0,

            label: '${_currentFontSize?.toStringAsFixed(0)}',
            onChanged: (value) {
              widget.caption.fontSize = value.toInt();
              _currentFontSize = value;
              setState(() {});
              widget.onSaved.call();
            },
          ),
        ),
      ],
    );
  }
}
