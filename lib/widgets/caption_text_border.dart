import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:pota_video_caption/utils.dart' as utils;

class CaptionTextBorder extends StatefulWidget {
  final utils.Caption caption;
  final Function onSaved;

  const CaptionTextBorder({
    required this.caption,
    required this.onSaved,
    super.key,
  });
  @override
  State<CaptionTextBorder> createState() => _CaptionTextBorderState();
}

class _CaptionTextBorderState extends State<CaptionTextBorder> {
  // Color for the picker shown in Card on the screen.
  late Color borderColor;
  late int borderWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    borderColor = widget.caption.parseColor(
      widget.caption.borderColor ?? "white",
    );

    borderWidth = widget.caption.borderWidth ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [Tab(text: "Width"), Tab(text: "Color")],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
          Container(
            height: 260,
            child: TabBarView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        '${borderWidth.toStringAsFixed(0)}',
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
                        value: borderWidth.toDouble(),
                        min: 0.0,
                        max: 10.0,

                        label: '${borderWidth.toStringAsFixed(0)}',
                        onChanged: (value) {
                          widget.caption.borderWidth = value.toInt();
                          borderWidth = value.toInt();
                          setState(() {});
                          widget.onSaved.call();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ColorPicker(
                      // Use the borderColor as start and active color.
                      color: borderColor,
                      // Update the borderColor using the callback.
                      onColorChanged: (Color color) {
                        widget.caption.borderColor = "#${color.hex}";
                        widget.onSaved.call();
                        setState(() => borderColor = color);
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
