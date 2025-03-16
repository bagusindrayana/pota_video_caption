// Copyright (c)  2024  Xiaomi Corporation
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import "dart:io";

// Copy the asset file from src to dst
Future<String> copyAssetFile(String src, [String? dst]) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  if (dst == null) {
    dst = basename(src);
  }
  final target = join(directory.path, dst);
  bool exists = await new File(target).exists();

  final data = await rootBundle.load(src);

  if (!exists || File(target).lengthSync() != data.lengthInBytes) {
    final List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(target).writeAsBytes(bytes);
  }

  return target;
}

Float32List convertBytesToFloat32(Uint8List bytes, [endian = Endian.little]) {
  final values = Float32List(bytes.length ~/ 2);

  final data = ByteData.view(bytes.buffer);

  for (var i = 0; i < bytes.length; i += 2) {
    int short = data.getInt16(i, endian);
    values[i ~/ 2] = short / 32678.0;
  }

  return values;
}

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
        "drawtext=text='$text':fontcolor='${_convertColorToHex(color)}':fontsize=$size";

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
    return Container(
      alignment: _getAlignment(
        textAlign ?? 'center',
      ), // Default to center alignment
      padding: const EdgeInsets.all(8.0), // Add some padding
      decoration:
          addBox == true
              ? BoxDecoration(
                color: parseColor(
                  boxColor ?? 'black@0.5',
                ), // Background box color
                border:
                    boxBorderWidth != null && boxBorderColor != null
                        ? Border.all(
                          color: parseColor(boxBorderColor!),
                          width: boxBorderWidth!.toDouble(),
                        )
                        : null,
              )
              : null,
      child: Text(
        text,
        style: TextStyle(
          color: parseColor(fontColor ?? 'white'), // Default font color
          fontSize: fontSize?.toDouble() ?? 24.0, // Default font size
          fontFamily:
              fontFile != null
                  ? 'CustomFont'
                  : null, // Custom font (if provided)
          shadows:
              shadowX != null && shadowY != null && shadowColor != null
                  ? [
                    Shadow(
                      color: Color(shadowColor!),
                      offset: Offset(shadowX!.toDouble(), shadowY!.toDouble()),
                    ),
                  ]
                  : null,
          letterSpacing: lineSpacing, // Line spacing
          backgroundColor:
              borderWidth != null && borderColor != null
                  ? parseColor(borderColor!)
                  : null, // Text border
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
}

class Subtitle {
  final int id;
  Duration startTime;
  Duration endTime;
  String text;

  // Position properties (normalized from 0.0 to 1.0)
  double verticalPosition;
  double horizontalPosition;
  TextAlign textAlign;
  String? fontFile;
  String? fontColor;
  int? fontSize;

  Subtitle({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.text,
    this.verticalPosition = 0.9, // Default bottom
    this.horizontalPosition = 0.5, // Default center
    this.textAlign = TextAlign.center,
    this.fontFile = "/system/fonts/Roboto-Regular.ttf",
    this.fontColor = "white",
    this.fontSize = 16,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'text': text,
      'verticalPosition': verticalPosition,
      'horizontalPosition': horizontalPosition,
      'textAlign': textAlign.index,
      'fontFile': fontFile,
      'fontColor': fontColor,
      'fontSize': fontSize,
    };
  }

  factory Subtitle.fromJson(Map<String, dynamic> json) {
    return Subtitle(
      id: json['id'],
      startTime: Duration(milliseconds: json['startTime']),
      endTime: Duration(milliseconds: json['endTime']),
      text: json['text'],
      verticalPosition: json['verticalPosition'] ?? 0.9,
      horizontalPosition: json['horizontalPosition'] ?? 0.5,
      textAlign: TextAlign.values[json['textAlign'] ?? 1],
      fontFile: json['fontFile'],
      fontColor: json['fontColor'],
      fontSize: json['fontSize'],
    );
  }

  String get srtTimeFormat {
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

    return '${_formatDuration(startTime)} --> ${_formatDuration(endTime)}';
  }

  // Advanced SRT with positioning (WebVTT style)
  String get advancedSrtFormat {
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

    // Convert normalized positions to percentages (0-100%)
    int verticalPercentage = (verticalPosition * 100).round();
    int horizontalPercentage = (horizontalPosition * 100).round();

    String alignment = '';
    if (textAlign == TextAlign.left) {
      alignment = 'align:left ';
    } else if (textAlign == TextAlign.right) {
      alignment = 'align:right ';
    }

    return '${_formatDuration(startTime)} --> ${_formatDuration(endTime)} ${alignment}line:${verticalPercentage}% position:${horizontalPercentage}%';
  }
}
