import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoController extends ChangeNotifier {
  late VideoPlayerController videoPlayerController;
  Duration currentPosition = Duration.zero;
  bool isPlaying = false;
  Duration videoDuration = Duration.zero;

  Future<void> initializeVideo(String videoUrl) async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    );
    await videoPlayerController.initialize();
    videoDuration = videoPlayerController.value.duration;
    notifyListeners(); // Notify listeners that the video is initialized
  }

  void playPauseVideo() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying = false;
    } else {
      videoPlayerController.play();
      isPlaying = true;
    }
    notifyListeners();
  }

  void seekTo(Duration position) {
    videoPlayerController.seekTo(position);
    currentPosition = position;
    notifyListeners();
  }

  void updateCurrentPosition() {
    currentPosition = videoPlayerController.value.position;
    notifyListeners();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
