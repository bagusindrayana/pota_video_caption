import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:pota_video_caption/video_caption_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:pota_video_caption/utils.dart' as utils;

class VideoViewer extends StatefulWidget {
  const VideoViewer({super.key, required this.controller, this.child});

  final VideoCaptoinController controller;
  final Widget? child;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoCaptoinController get controller => widget.controller;

  double _currentVerticalPosition = 0.9;
  double _currentHorizontalPosition = 0.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(_update);
  }

  _update() {
    // print('updatee');

    if (mounted) {
      if (controller.currentCaption != null) {
        setState(() {
          var defaultXPosition = 0.0;
          var textWidth = controller.currentCaption!.textSize().width;
          if (textWidth < controller.videoWidth) {
            defaultXPosition =
                ((controller.videoWidth / 2) - (textWidth / 2)) /
                controller.videoWidth;
          } else {
            defaultXPosition = 0.0;
          }
          _currentHorizontalPosition =
              controller.currentCaption!.x ?? defaultXPosition;
          _currentVerticalPosition = controller.currentCaption!.y ?? 0.8;

          controller.currentCaption!.x = _currentHorizontalPosition;
          controller.currentCaption!.y = _currentVerticalPosition;
        });
      }
    }
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.video.value.isPlaying) {
          controller.video.pause();
        } else {
          controller.video.play();
        }
      },
      child: Container(
        height: 240,
        color: Colors.grey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Video dimensions
            double videoWidth = constraints.maxWidth;
            double videoHeight = constraints.maxHeight;

            double referenceHeight =
                widget
                    .controller
                    .videoHeight; // Reference video height (e.g., 1080p)

            // Calculate scaling factor based on video height
            double scalingFactor = videoHeight / referenceHeight;

            // Calculate subtitle position relative to video size
            double subtitleWidth = videoWidth * 0.8; // 80% of video width
            double subtitleHeight = videoHeight * 0.1; // 10% of video height

            double subtitleLeft = (videoWidth) * _currentHorizontalPosition;
            double subtitleTop = videoHeight * _currentVerticalPosition;

            // subtitleLeft = subtitleLeft.clamp(0, videoWidth);
            // subtitleTop = subtitleTop.clamp(0, videoHeight - subtitleHeight);
            return Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: controller.video.value.aspectRatio,
                    child: VideoPlayer(controller.video),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: controller.video,
                    builder:
                        (_, __) => AnimatedOpacity(
                          opacity: controller.isPlaying ? 0 : 1,
                          duration: kThemeAnimationDuration,
                          child: GestureDetector(
                            onTap: controller.video.play,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
                if (controller.currentCaption != null)
                  Positioned(
                    left: subtitleLeft,
                    top: subtitleTop,
                    // width: subtitleWidth,
                    // left:
                    //     constraints.maxWidth *
                    //         (_currentHorizontalPosition - 0.5) +
                    //     constraints.maxWidth * 0.5 -
                    //     150,
                    // top: constraints.maxHeight * _currentVerticalPosition - 40,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Base font size for reference resolution (e.g., 16px for 1080p)
                        double baseFontSize =
                            controller.currentCaption!.fontSize?.toDouble() ??
                            24.0;

                        // Calculate relative font size
                        double relativeFontSize = baseFontSize * scalingFactor;
                        return GestureDetector(
                          onPanUpdate: (details) {
                            // Calculate new position based on drag delta
                            double newVertical =
                                _currentVerticalPosition +
                                (details.delta.dy / videoHeight);
                            double newHorizontal =
                                _currentHorizontalPosition +
                                (details.delta.dx / videoWidth);

                            // Clamp values between 0.0 and 1.0
                            newVertical = newVertical.clamp(0.0, 1.0);
                            newHorizontal = newHorizontal.clamp(0.0, 1.0);

                            // Update subtitle position
                            // _updateCurrentSubtitle(
                            //   newVertical,
                            //   newHorizontal,
                            //   _currentTextAlign,
                            // );
                            _currentHorizontalPosition = newHorizontal;
                            _currentVerticalPosition = newVertical;
                            controller.currentCaption!.x = newHorizontal;
                            controller.currentCaption!.y = newVertical;
                            setState(() {});
                          },
                          child: Container(
                            child: controller.currentCaption!.renderWidget(
                              relativeFontSize: relativeFontSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // if (widget.child != null)
                //   Padding(
                //     padding: EdgeInsets.only(
                //       top: controller.videoHeight / 2 - 50,
                //     ),
                //     child: widget.child,
                //   ),
              ],
            );
          },
        ),
      ),
    );
  }
}
