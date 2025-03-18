import 'package:flutter/material.dart';
import 'package:pota_video_caption/utils.dart' as utils;
import 'package:pota_video_caption/utils/ffmpeg_helper.dart' as ffmpeg_helper;

class CaptionTextAlign extends StatefulWidget {
  final ffmpeg_helper.Caption caption;
  final Function onSaved;

  const CaptionTextAlign({
    required this.caption,
    required this.onSaved,
    super.key,
  });

  @override
  State<CaptionTextAlign> createState() => _CaptionTextAlignState();
}

class _CaptionTextAlignState extends State<CaptionTextAlign> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: ToggleButtons(
            color: Colors.white,
            isSelected: [
              widget.caption.textAlign == "left",
              widget.caption.textAlign == "center",
              widget.caption.textAlign == "right",
            ],
            onPressed: (index) {
              String newAlign;
              switch (index) {
                case 0:
                  newAlign = "left";
                  break;
                case 1:
                  newAlign = "center";
                  break;
                case 2:
                  newAlign = "right";
                  break;
                default:
                  newAlign = "center";
              }

              setState(() {
                widget.caption.textAlign = newAlign;
              });
              widget.onSaved.call();
            },
            children: const [
              Icon(Icons.format_align_left),
              Icon(Icons.format_align_center),
              Icon(Icons.format_align_right),
            ],
          ),
        ),
      ],
    );
  }
}
