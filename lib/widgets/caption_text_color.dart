import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:pota_video_caption/utils.dart' as utils;

class CaptionTextColor extends StatefulWidget {
  final utils.Caption caption;
  final Function onSaved;

  const CaptionTextColor({
    required this.caption,
    required this.onSaved,
    super.key,
  });
  @override
  State<CaptionTextColor> createState() => _CaptionTextColorState();
}

class _CaptionTextColorState extends State<CaptionTextColor> {
  // Color for the picker shown in Card on the screen.
  late Color screenPickerColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screenPickerColor = widget.caption.parseColor(
      widget.caption.fontColor ?? "white",
    ); // Material blue.
    // A purple color.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ColorPicker(
          // Use the screenPickerColor as start and active color.
          color: screenPickerColor,
          // Update the screenPickerColor using the callback.
          onColorChanged: (Color color) {
            widget.caption.fontColor = "#${color.hex}";
            widget.onSaved.call();
            setState(() => screenPickerColor = color);
          },

          enableShadesSelection: false,
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.both: false,
            ColorPickerType.primary: false,
            ColorPickerType.accent: false,
            ColorPickerType.wheel: true,
          },
        ),
      ),
    );
  }
}
