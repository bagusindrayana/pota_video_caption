import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pota_video_caption/utils.dart' as utils;
import 'package:pota_video_caption/video_caption_controller.dart';
import 'package:pota_video_caption/widgets/caption_text_editor.dart';
import 'package:pota_video_caption/widgets/scale_painter.dart';

class TimelineSlider extends StatefulWidget {
  const TimelineSlider({
    super.key,
    required this.controller,
    this.onCaptionTap,
    this.height = 100,
    this.captionBackgroundColor = const Color(0xFF974836),
    this.touchAreaColor = Colors.grey,
    this.baselineColor = Colors.redAccent,
    this.captionTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  });

  final VideoCaptoinController controller;
  final Function(utils.Caption caption)? onCaptionTap;

  /// The [height] param specifies the height of the generated thumbnails
  final double height;
  final Color baselineColor;

  ///the background color of the caption
  final Color captionBackgroundColor;

  ///the color of the touch area
  final Color touchAreaColor;
  final TextStyle captionTextStyle;

  @override
  State<TimelineSlider> createState() => _TimelineSliderState();
}

class _TimelineSliderState extends State<TimelineSlider>
    with SingleTickerProviderStateMixin {
  /// The max width of [TimelineSlider]
  double _sliderWidth = 1.0;

  /// how many pixels per second
  static const double perPixelInSec = 100;

  /// the width of the left and right touch areas
  double touchWidth = 30.0;

  /// the height of the left and right touch areas
  double touchHeight = 60.0;

  late final ScrollController _scrollController;

  /// the horizontal margin of the slider
  late double _horizontalMargin;

  ///is the caption highlighted in edit mode
  bool get isHighlighted => widget.controller.highlightCaption != null;

  ///how many pixels per second should be scrolled as video is playing
  double speed = 1;

  @override
  void initState() {
    super.initState();
    //half of screen width
    calculateSliderWidth(widget.controller);
    touchHeight = widget.height / 2;
    touchWidth = widget.height / 4;
    _scrollController = ScrollController();
    _scrollController.addListener(attachScroll);
    widget.controller.video.addListener(videoUpdate);
    speed = _sliderWidth / widget.controller.videoDuration.inMilliseconds;
  }

  calculateSliderWidth(VideoCaptoinController controller) {
    final duration = controller.videoDuration.inSeconds;
    _sliderWidth = duration.toDouble() * perPixelInSec;
  }

  int lastTimeStamp = 0;
  bool isAutoScrolling = false;

  videoUpdate() {
    //how to update SingleChildScrollView scroll position when video is playing
    if (widget.controller.video.value.isPlaying) {
      isAutoScrolling = true;
      int interval =
          widget.controller.videoPosition.inMilliseconds - lastTimeStamp;
      lastTimeStamp = widget.controller.videoPosition.inMilliseconds;
      if (interval > 0) {
        _scrollController.animateTo(
          speed * (lastTimeStamp + 500),
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void attachScroll() {
    if (_scrollController.position.isScrollingNotifier.value) {
      // update trim and video position
      if (_scrollController.position.userScrollDirection !=
          ScrollDirection.idle) {
        if (widget.controller.isPlaying) {
          widget.controller.video.pause();
        }
        widget.controller.highlightCaption = null;
        _controllerSeekTo(_scrollController.offset);
      } else {}
    }
  }

  /// Sets the video's current timestamp to be at the [position] on the slider
  /// If the expected position is bigger than [captionController.endTrim], set it to [captionController.endTrim]
  void _controllerSeekTo(double position) async {
    final to = widget.controller.videoDuration * (position / (_sliderWidth));
    await widget.controller.seekTo(to);
  }

  // Returns the max size the layout should take with the rect value
  double computeWidth(utils.Caption caption) {
    final start = caption.startTime.inMilliseconds;
    final end = caption.endTime.inMilliseconds;
    final duration = widget.controller.videoDuration.inMilliseconds;
    final width = (_sliderWidth * (end - start)) / duration;
    return width;
  }

  // Returns the max size the layout should take with the rect value
  double computeStartX(utils.Caption caption) {
    // var captionWidth =
    //     (caption.endTime.inSeconds * perPixelInSec) -
    //     (caption.startTime.inSeconds * perPixelInSec);

    // return (caption.startTime.inSeconds * perPixelInSec);

    final start = caption.startTime.inMilliseconds;
    final duration = widget.controller.videoDuration.inMilliseconds;

    final startX = (_sliderWidth * start) / duration;
    return startX;
  }

  @override
  Widget build(BuildContext context) {
    _horizontalMargin = MediaQuery.of(context).size.width / 2;
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.only(left: _horizontalMargin),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(_sliderWidth, 30),
                  // Specify the size of the canvas
                  painter: ScalePainter(
                    tickCount: widget.controller.videoDuration.inSeconds,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: widget.height + 20,
                      width: _sliderWidth,
                      color: Colors.grey.withOpacity(0.2),
                      child: Stack(
                        children: [
                          ...widget.controller.captions.map((caption) {
                            return _buildSingleCaption(caption);
                          }),
                          Visibility(
                            visible: isHighlighted,
                            child: Positioned(
                              left: _calculateLeftTouch(),
                              top: 10,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  adjustCaptionStartTime(details);
                                  setState(() {});
                                },
                                child: Container(
                                  width: touchWidth,
                                  height: widget.height,
                                  decoration: BoxDecoration(
                                    color: widget.touchAreaColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: touchWidth - 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isHighlighted,
                            child: Positioned(
                              left: _calculateRightTouch(),
                              top: 10,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  adjustCaptionEndTime(details);
                                  setState(() {});
                                },
                                child: Container(
                                  width: touchWidth,
                                  height: widget.height,
                                  decoration: BoxDecoration(
                                    color: widget.touchAreaColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: touchWidth - 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //add a icon button at the center of highlighted caption
                // Visibility(
                //   visible: isHighlighted,
                //   child: Positioned(
                //     left: _calculateLeftTouch() + _calculateCaptionWidth() / 2,
                //     child: GestureDetector(
                //       onTap: () {
                //         //delete the highlighted caption
                //         widget.controller.deleteHighlightedCaption();
                //         widget.controller.highlightCaption = null;
                //         setState(() {});
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.grey.withOpacity(0.5),
                //           shape: BoxShape.circle,
                //         ),
                //         padding: const EdgeInsets.all(5.0),
                //         child: const Align(
                //           alignment: Alignment.center,
                //           child: Icon(
                //             Icons.delete_forever,
                //             color: Colors.white,
                //             size: 30,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, left: _horizontalMargin - 2),
          child: Column(
            children: [
              // Transform.rotate(
              //   angle: -75,
              //   child: Icon(Icons.play_arrow, color: Colors.white, size: 50),
              // ),
              Container(
                height: widget.height + 30,
                width: 2,
                decoration: BoxDecoration(
                  border: Border.all(color: widget.baselineColor, width: 2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFullscreenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Material(
            type: MaterialType.transparency,
            child: CaptionTextEditor(
              caption: widget.controller.highlightCaption!,
              onSaved: () {
                setState(() {});
                widget.controller.updateListener();
              },
            ),
          ),
    );
  }

  double _calculateDeleteBtnStartX() {
    if (widget.controller.highlightCaption == null) return 0.0;
    return computeStartX(widget.controller.highlightCaption!) +
        _horizontalMargin +
        computeWidth(widget.controller.highlightCaption!) / 2 -
        10;
  }

  double _calculateLeftTouch() {
    return widget.controller.highlightCaption != null
        ? computeStartX(widget.controller.highlightCaption!) - touchWidth
        : 0.0;
  }

  double _calculateRightTouch() {
    return widget.controller.highlightCaption != null
        ? computeStartX(widget.controller.highlightCaption!) +
            computeWidth(widget.controller.highlightCaption!)
        : 0.0;
  }

  double _calculateCaptionWidth() {
    return widget.controller.highlightCaption != null
        ? computeWidth(widget.controller.highlightCaption!)
        : 0.0;
  }

  /// Adjust the caption start time based on the drag details
  /// @param details: the drag details
  adjustCaptionStartTime(DragUpdateDetails details) {
    if (widget.controller.highlightCaption == null) return;
    double offsetX =
        (details.primaryDelta ?? 0) / (_sliderWidth + _horizontalMargin * 2);
    print("UI: slider primaryDelta=${details.primaryDelta} offsetX: $offsetX");

    final to = widget.controller.videoDuration * offsetX;
    if (widget.controller.highlightCaption != null) {
      var adjustStartX = widget.controller.highlightCaption!.startTime + to;
      //check if start time is less than pre caption end time
      print("pre caption end: ${widget.controller.getPreCaption()?.endTime}");
      if (adjustStartX <=
          (widget.controller.getPreCaption()?.endTime ??
              const Duration(seconds: 0))) {
        adjustStartX =
            widget.controller.getPreCaption()?.endTime ??
            const Duration(seconds: 0);
      }
      widget.controller.highlightCaption!.startTime = adjustStartX;
    }
  }

  /// Adjust the caption end time based on the drag details
  /// @param details: the drag details
  adjustCaptionEndTime(DragUpdateDetails details) {
    if (widget.controller.highlightCaption == null) return;
    double offsetX =
        (details.primaryDelta ?? 0) / (_sliderWidth + _horizontalMargin * 2);
    final to = widget.controller.videoDuration * offsetX;
    if (widget.controller.highlightCaption != null) {
      var adjustEndX = widget.controller.highlightCaption!.endTime + to;
      //check if end time is greater than next caption start time
      if (adjustEndX >=
          (widget.controller.getNextCaption()?.startTime ??
              widget.controller.videoDuration)) {
        adjustEndX =
            widget.controller.getNextCaption()?.startTime ??
            widget.controller.videoDuration;
      }
      widget.controller.highlightCaption!.endTime = adjustEndX;
    }
  }

  _buildSingleCaption(utils.Caption caption) {
    double width = computeWidth(caption);
    double startX = computeStartX(caption);

    return Positioned(
      left: startX,
      top: 10,
      child: GestureDetector(
        onTap: () {
          //set highlighted caption
          // if (isHighlighted) {
          //   if (widget.controller.highlightCaption == caption) {
          //     _showFullscreenDialog(context);
          //   } else {
          //     widget.controller.selectCaption(caption);
          //   }
          //   // Navigator.of(context).push(PageRouteBuilder(
          //   //     opaque: false,
          //   //     pageBuilder: (BuildContext context, _, __) {
          //   //
          //   //     }
          //   // ));
          // } else {
          //   widget.controller.highlightCaption = caption;
          // }
          widget.controller.highlightCaption = caption;
          if (widget.onCaptionTap != null) {
            widget.onCaptionTap!(caption);
          }
          setState(() {});
        },
        child:
        //add left arrow
        Container(
          width: width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.captionBackgroundColor,
            border:
                isHighlighted && caption == widget.controller.highlightCaption
                    ? Border.symmetric(
                      horizontal: BorderSide(
                        color: widget.touchAreaColor,
                        width: 2,
                      ),
                    )
                    : null,
            borderRadius:
                isHighlighted && caption == widget.controller.highlightCaption
                    ? BorderRadius.zero
                    : BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              caption.text,
              textAlign: caption.getTextAlign(caption.textAlign ?? 'center'),
              style: TextStyle(
                fontSize: 14,
                color: caption.parseColor(caption.fontColor ?? 'white'),
                fontFamily: caption.fontFile,
              ),
            ),
          ),
        ),
        //add left arrow
      ),
    );
  }
}
