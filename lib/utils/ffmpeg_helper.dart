import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class Caption {
  String text;
  String? fontColor;
  int? fontSize;
  String? fontFile;
  double? x;
  double? y;
  Duration startTime;
  Duration endTime;
  bool? addBox;
  String? boxColor;
  int? boxBorderWidth;
  String? boxBorderColor;
  String? textAlign;
  int? borderWidth;
  String? borderColor;
  int? shadowX;
  int? shadowY;
  int? shadowColor;
  double? lineSpacing;
  double? alpha;

  Caption({
    required this.text,
    this.fontColor,
    this.fontSize,
    this.fontFile = "/system/fonts/Roboto-Regular.ttf",
    this.x,
    this.y,
    required this.startTime,
    required this.endTime,
    this.addBox,
    this.boxColor,
    this.boxBorderWidth,
    this.boxBorderColor,
    this.textAlign,
    this.borderWidth,
    this.borderColor,
    this.shadowX,
    this.shadowY,
    this.shadowColor,
    this.lineSpacing,
    this.alpha,
  });

  factory Caption.from(Caption caption) {
    return Caption(
      text: caption.text,
      fontColor: caption.fontColor,
      fontSize: caption.fontSize,
      fontFile: caption.fontFile,
      x: caption.x,
      y: caption.y,
      startTime: caption.startTime,
      endTime: caption.endTime,
      addBox: caption.addBox,
      boxColor: caption.boxColor,
      boxBorderWidth: caption.boxBorderWidth,
      boxBorderColor: caption.boxBorderColor,
      textAlign: caption.textAlign,
      borderWidth: caption.borderWidth,
      borderColor: caption.borderColor,
      shadowX: caption.shadowX,
      shadowY: caption.shadowY,
      shadowColor: caption.shadowColor,
      lineSpacing: caption.lineSpacing,
      alpha: caption.alpha,
    );
  }

  factory Caption.fromJson(Map<String, dynamic> json) {
    return Caption(
      text: json['text'],
      fontColor: json['fontColor'],
      fontSize: json['fontSize'],
      fontFile: json['fontFile'],
      x: json['x'],
      y: json['y'],
      startTime: Duration(
        milliseconds: int.parse((json['startTime'] ?? 0).toString()),
      ),
      endTime: Duration(
        milliseconds: int.parse((json['endTime'] ?? 0).toString()),
      ),
      addBox: json['addBox'],
      boxColor: json['boxColor'],
      boxBorderWidth: json['boxBorderWidth'],
      boxBorderColor: json['boxBorderColor'],
      textAlign: json['textAlign'],
      borderWidth: json['borderWidth'],
      borderColor: json['borderColor'],
      shadowX: json['shadowX'],
      shadowY: json['shadowY'],
      shadowColor: json['shadowColor'],
      lineSpacing: json['lineSpacing'],
      alpha: json['alpha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'fontColor': fontColor,
      'fontSize': fontSize,
      'fontFile': fontFile,
      'x': x,
      'y': y,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'addBox': addBox,
      'boxColor': boxColor,
      'boxBorderWidth': boxBorderWidth,
      'boxBorderColor': boxBorderColor,
      'textAlign': textAlign,
      'borderWidth': borderWidth,
      'borderColor': borderColor,
      'shadowX': shadowX,
      'shadowY': shadowY,
      'shadowColor': shadowColor,
      'lineSpacing': lineSpacing,
      'alpha': alpha,
    };
  }

  String generateFilter() {
    // Default values for optional parameters
    String color = fontColor ?? 'white'; // Default font color
    int size = fontSize ?? 24; // Default font size
    String xPosition =
        (x == null)
            ? '(w-text_w)/2'
            : '(w*${x!.toString()})'; // Default: centered horizontally
    String yPosition =
        (y == null)
            ? 'h-th-10'
            : '(h*${y!.toString()})+(text_h/2)'; // Default: 10 pixels above the bottom

    // Build the drawtext filter
    String drawtextFilter =
        "drawtext=text='${text.replaceAll('"', '\u201E').replaceAll("'", "\u2019").trim()}':fontcolor='${_convertColorToHex(color)}':fontsize=$size";

    // Add font file if provided
    if (fontFile != null && fontFile!.isNotEmpty) {
      drawtextFilter += ":fontfile='$fontFile'";
    }

    // Add text alignment if provided
    // if (textAlign != null) {
    //   drawtextFilter += ":x=(w-text_w)*${_getAlignmentFactor(textAlign!)}";
    // } else {
    //   drawtextFilter += ":x=$xPosition";
    // }

    drawtextFilter += ":x=$xPosition";

    // Add background box if enabled
    if (addBox == true) {
      drawtextFilter +=
          ":box=1:boxcolor=${boxColor ?? 'black@0.5'}"; // Default: semi-transparent black box
      if (boxBorderWidth != null && boxBorderColor != null) {
        drawtextFilter +=
            ":boxborderw=$boxBorderWidth:boxbordercolor=$boxBorderColor";
      }
    }

    // Add text border if enabled
    if (borderWidth != null && borderColor != null) {
      drawtextFilter +=
          ":bordercolor='${_convertColorToHex(borderColor!)}':borderw=$borderWidth";
    }

    // Add shadow if enabled
    if (shadowX != null && shadowY != null && shadowColor != null) {
      drawtextFilter +=
          ":shadowx=$shadowX:shadowy=$shadowY:shadowcolor=$shadowColor";
    }

    // Add line spacing if provided
    if (lineSpacing != null) {
      drawtextFilter += ":line_spacing=$lineSpacing";
    }

    // Add alpha (transparency) if provided
    if (alpha != null) {
      drawtextFilter +=
          ":alpha=${alpha!.toStringAsFixed(2)}"; // Limit to 2 decimal places
    }

    // Add position and timing
    drawtextFilter +=
        ":y=$yPosition:enable='between(t,${startTime.inSeconds},${endTime.inSeconds})'";

    return drawtextFilter;
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(
      3,
      '0',
    );
    return '$hours:$minutes:$seconds,$milliseconds';
  }

  String get srtTimeFormat {
    return '${_formatDuration(startTime)} --> ${_formatDuration(endTime)}';
  }

  String get advancedSrtFormat {
    // Convert normalized positions to percentages (0-100%)
    int verticalPercentage = (y ?? 0 * 100).round();
    int horizontalPercentage = (x ?? 0 * 100).round();

    String alignment = '';
    if (textAlign == TextAlign.left) {
      alignment = 'align:left ';
    } else if (textAlign == TextAlign.right) {
      alignment = 'align:right ';
    }

    return '${_formatDuration(startTime)} --> ${_formatDuration(endTime)} ${alignment}line:${verticalPercentage}% position:${horizontalPercentage}%';
  }

  //convert color to 0xFFFFFF
  String _convertColorToHex(String color) {
    if (color.startsWith("#")) {
      return "0x" + color.replaceAll("#", "");
    }
    return color;
  }

  // Helper function to calculate alignment factor
  double _getAlignmentFactor(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return 0.0;
      case 'center':
        return 0.5;
      case 'right':
        return 1.0;
      default:
        return 0.5; // Default to center
    }
  }

  Size textSize() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: parseColor(fontColor ?? 'white'),
          fontSize: fontSize?.toDouble() ?? 24.0,
          fontFamily: fontFile
              ?.split("/")
              .last
              .split(".")
              .first
              .replaceAll("-Regular", ""),
          // backgroundColor: Colors.black.withOpacity(0.6),
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  // Function to render the caption as a Flutter widget
  Widget renderWidget({double? relativeFontSize}) {
    return BorderedText(
      strokeWidth: borderWidth?.toDouble() ?? 2,
      strokeColor: parseColor(borderColor ?? 'black'),
      child: Text(
        text,

        textAlign: getTextAlign(textAlign ?? 'center'),
        style: TextStyle(
          color: parseColor(fontColor ?? 'white'),
          fontSize: relativeFontSize ?? fontSize?.toDouble() ?? 24.0,
          fontFamily: fontFile
              ?.split("/")
              .last
              .split(".")
              .first
              .replaceAll("-Regular", ""),
          // backgroundColor: Colors.black.withOpacity(0.6),
        ),
      ),
    );
  }

  // Helper function to parse alignment
  Alignment _getAlignment(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return Alignment.centerLeft;
      case 'right':
        return Alignment.centerRight;
      case 'center':
      default:
        return Alignment.center;
    }
  }

  TextAlign getTextAlign(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
      default:
        return TextAlign.center;
    }
  }

  // Helper function to parse color strings (e.g., 'white', 'black@0.5', '#FF0000')
  Color parseColor(String colorString) {
    if (colorString.contains('@')) {
      // Handle transparency (e.g., 'black@0.5')
      List<String> parts = colorString.split('@');
      String colorName = parts[0];
      double opacity = double.tryParse(parts[1]) ?? 1.0;
      return _getColorFromName(colorName).withOpacity(opacity);
    } else if (colorString.startsWith('#')) {
      // Handle hex color (e.g., '#FF0000')
      return Color(
        int.parse(colorString.substring(1), radix: 16),
      ).withAlpha(255);
    } else {
      // Handle named colors (e.g., 'white', 'black')
      return _getColorFromName(colorString);
    }
  }

  // Helper function to get color from name
  Color _getColorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.white; // Default to white
    }
  }
}

class FFmpegCaptionManager {
  String inputVideoPath;
  String outputVideoPath;
  List<Caption> captions;

  FFmpegCaptionManager({
    required this.inputVideoPath,
    required this.outputVideoPath,
    required this.captions,
  });

  String generateCommand() {
    // Combine all caption filters into a single filter chain
    String filterChain = captions
        .map((caption) => caption.generateFilter())
        .join(',');

    // Build the full FFmpeg command
    String command =
        '-y -i "$inputVideoPath" -vf "$filterChain" -codec:a copy "$outputVideoPath"';

    return command;
  }

  String generateSRT() {
    String srtContent = '';

    for (int i = 0; i < captions.length; i++) {
      final subtitle = captions[i];
      srtContent += '${i + 1}\n';
      srtContent += '${subtitle.advancedSrtFormat}\n';
      srtContent += '${subtitle.text}\n\n';
    }

    return srtContent;
  }
}
