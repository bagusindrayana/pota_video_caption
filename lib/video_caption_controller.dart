import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pota_video_caption/utils.dart' as utils;
import 'package:video_player/video_player.dart';

class VideoCaptoinController extends ChangeNotifier {
  final String dataSource;
  final VideoPlayerController _video;

  List<utils.Caption> _captions = [];

  List<utils.Caption> get captions => _captions;

  utils.Caption? _caption;

  utils.Caption? get currentCaption => _caption;

  utils.Caption? highlightCaption;

  /// Get the [VideoPlayerController]
  VideoPlayerController get video => _video;

  /// Get the [VideoPlayerController.value.initialized]
  bool get initialized => _video.value.isInitialized;

  /// Get the [VideoPlayerController.value.isPlaying]
  bool get isPlaying => _video.value.isPlaying;

  /// Get the [VideoPlayerController.value.position]
  Duration get videoPosition => _video.value.position;

  /// Get the [VideoPlayerController.value.duration]
  Duration get videoDuration => _video.value.duration;

  /// Get the [VideoPlayerController.value.size]
  Size get videoDimension => _video.value.size;

  double get videoWidth => videoDimension.width;

  double get videoHeight => videoDimension.height;

  /// Constructs a [VideoCaptoinController] that edits a video from a file.
  ///[dataSource] is the path of the video file.
  VideoCaptoinController.file(this.dataSource)
    : _video = VideoPlayerController.file(
        File(
          // https://github.com/flutter/flutter/issues/40429#issuecomment-549746165
          Platform.isIOS ? Uri.encodeFull(dataSource) : dataSource,
        ),
      );

  /// Constructs a [VideoCaptoinController] that edits a video from asset.
  ///
  VideoCaptoinController.asset(this.dataSource)
    : _video = VideoPlayerController.asset(dataSource);

  ///get a pre caption of current caption
  ///if current caption is null, return null
  utils.Caption? getPreCaption() {
    if (highlightCaption == null) {
      return null;
    }
    int index = _captions.indexOf(highlightCaption!);
    if (index == 0) {
      return null;
    }
    return _captions[index - 1];
  }

  ///get a next caption of current caption
  ///if current caption is null, return null
  ///if current caption is the last caption, return null
  utils.Caption? getNextCaption() {
    if (highlightCaption == null) {
      return null;
    }
    int index = _captions.indexOf(highlightCaption!);
    if (index == _captions.length - 1) {
      return null;
    }
    return _captions[index + 1];
  }

  dismissHighlightedCaption() {
    highlightCaption = null;
    notifyListeners();
  }

  deleteHighlightedCaption() {
    _captions.remove(highlightCaption);
    highlightCaption = null;
    notifyListeners();
  }

  ///get a caption from a timestamp
  getCaptionFromTimeStamp(Duration timestamp) {
    for (int i = 0; i < _captions.length; i++) {
      if (_captions[i].startTime <= timestamp &&
          _captions[i].endTime >= timestamp) {
        return _captions[i];
      }
    }
    return null;
  }

  Future<void> initializeVideo() async {
    await _video.initialize();
    _video.addListener(_videoListener);
    _video.setLooping(true);
  }

  String generateCaptionContent() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < _captions.length; i++) {
      final caption = _captions[i];
      buffer.writeln('${i + 1}');
      buffer.writeln(
        '${_formatDuration(caption.startTime)} --> ${_formatDuration(caption.endTime)}',
      );
      buffer.writeln(caption.text);
      buffer.writeln();
    }
    return buffer.toString();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))},${threeDigits(duration.inMilliseconds.remainder(1000))}';
  }

  void _videoListener() {
    seekCaptionTo(videoPosition);
  }

  void seekCaptionTo(Duration timestamp) {
    _caption = getCaptionFromTimeStamp(timestamp);
    notifyListeners();
  }

  seekTo(Duration timestamp) async {
    await _video.seekTo(timestamp);
    seekCaptionTo(timestamp);
  }

  void setCaptionIndex(int index) {
    notifyListeners();
  }

  void addCaption(utils.Caption caption) {
    _captions.add(caption);
    notifyListeners();
  }

  void selectCaption(utils.Caption caption) {
    highlightCaption = caption;
    notifyListeners();
  }

  void updateListener() {
    notifyListeners();
  }

  void deleteAllCaptions() {
    _captions.clear();
    notifyListeners();
  }
}
