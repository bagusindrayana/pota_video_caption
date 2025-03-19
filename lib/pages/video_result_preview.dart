import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

class VideoResultPreview extends StatefulWidget {
  final String path;
  const VideoResultPreview({super.key, required this.path});

  @override
  State<VideoResultPreview> createState() => _VideoResultPreviewState();
}

class _VideoResultPreviewState extends State<VideoResultPreview> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path));
    videoPlayerController.initialize().then((_) {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            videoPlayerController.value.isInitialized
                ? AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: chewieController),
                )
                : CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Saved : ${widget.path}", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
