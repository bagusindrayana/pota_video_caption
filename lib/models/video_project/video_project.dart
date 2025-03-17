import 'package:isar/isar.dart';

part 'video_project.g.dart';

@collection
class VideoProject {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  @Index(type: IndexType.value)
  String? title;
  String? thumbnail;
  String? videoPath;
  String? originalPath;
  int? duration;
  DateTime? createdAt;
  List<Caption>? captions;
  bool? exported;

  VideoProject({
    this.title,
    this.thumbnail,
    this.videoPath,
    this.originalPath,
    this.duration,
    this.createdAt,
    this.captions,
    this.exported,
  });
}

@embedded
class Caption {
  String? text;
  String? startTime;
  String? endTime;
  String? fontColor;
  int? fontSize;
  String? fontFile;
  double? x;
  double? y;
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
    this.text,
    this.startTime,
    this.endTime,
    this.fontColor,
    this.fontSize,
    this.fontFile,
    this.x,
    this.y,
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

  factory Caption.fromJson(Map<String, dynamic> json) {
    return Caption(
      text: json['text'],
      fontColor: json['fontColor'],
      fontSize: json['fontSize'],
      fontFile: json['fontFile'],
      x: json['x'],
      y: json['y'],
      startTime:
          Duration(milliseconds: json['startTime']).inMilliseconds.toString(),
      endTime:
          Duration(milliseconds: json['endTime']).inMilliseconds.toString(),
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
      'startTime': startTime,
      'endTime': endTime,
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
}
