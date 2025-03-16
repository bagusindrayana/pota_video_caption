import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pota_video_caption/pages/caption_editor_page.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sherpa-ONNX Whisper Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      darkTheme: ThemeData.dark(),
      home: LoaderOverlay(child: CaptionEditorPage()),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize with your video source
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4',
        ),
      )
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Video Player with Timeline')),
      body: Column(
        children: [
          // Video player
          Expanded(
            child: Center(
              child:
                  _controller.value.isInitialized
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : const CircularProgressIndicator(),
            ),
          ),

          // Timeline controller
          VideoTimelineController(
            videoPlayerController: _controller,
            height: 80,
          ),

          // Play/pause button
          IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
        ],
      ),
    );
  }
}

class VideoTimelineController extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final double height;
  final Color timelineColor;
  final Color thumbColor;
  final Color backgroundColor;

  const VideoTimelineController({
    Key? key,
    required this.videoPlayerController,
    this.height = 80,
    this.timelineColor = Colors.white,
    this.thumbColor = Colors.red,
    this.backgroundColor = Colors.black54,
  }) : super(key: key);

  @override
  _VideoTimelineControllerState createState() =>
      _VideoTimelineControllerState();
}

class _VideoTimelineControllerState extends State<VideoTimelineController> {
  late ScrollController _scrollController;
  double _sliderValue = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Listen to video position changes
    widget.videoPlayerController.addListener(_videoPositionChanged);
  }

  @override
  void dispose() {
    widget.videoPlayerController.removeListener(_videoPositionChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _videoPositionChanged() {
    if (!_isDragging && widget.videoPlayerController.value.isPlaying) {
      final Duration position = widget.videoPlayerController.value.position;
      final Duration duration = widget.videoPlayerController.value.duration;

      if (duration.inMicroseconds > 0) {
        final double value = position.inMicroseconds / duration.inMicroseconds;
        setState(() {
          _sliderValue = value;
        });

        // Scroll the timeline to follow the video position
        _scrollToPosition(value);
      }
    }
  }

  void _scrollToPosition(double value) {
    if (_scrollController.hasClients) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        value * maxScroll,
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final Duration position = widget.videoPlayerController.value.position;
    final Duration duration = widget.videoPlayerController.value.duration;

    return Column(
      children: [
        // Time display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Timeline with markings
        Container(
          height: widget.height,
          color: widget.backgroundColor,
          child: Stack(
            children: [
              // Scrollable timeline markings
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: TimelineMarkings(
                  width:
                      MediaQuery.of(context).size.width *
                      3, // Make timeline 3x screen width for better scrolling
                  height: widget.height,
                  duration: duration,
                  color: widget.timelineColor,
                ),
              ),

              // Centered playhead indicator
              Center(
                child: Container(
                  width: 2,
                  height: widget.height,
                  color: widget.thumbColor,
                ),
              ),

              // Transparent overlay for touch handling
              GestureDetector(
                onHorizontalDragStart: (details) {
                  setState(() {
                    _isDragging = true;
                  });
                  widget.videoPlayerController.pause();
                },
                onHorizontalDragUpdate: (details) {
                  if (_scrollController.hasClients) {
                    final double maxScroll =
                        _scrollController.position.maxScrollExtent;
                    final double currentScroll = _scrollController.offset;
                    final double newScroll = currentScroll - details.delta.dx;

                    // Constrain the scroll
                    final double boundedScroll = newScroll.clamp(
                      0.0,
                      maxScroll,
                    );
                    _scrollController.jumpTo(boundedScroll);

                    // Update the slider value
                    final double newValue = boundedScroll / maxScroll;
                    setState(() {
                      _sliderValue = newValue;
                    });

                    // Seek the video to the new position
                    final int microseconds =
                        (newValue * duration.inMicroseconds).round();
                    widget.videoPlayerController.seekTo(
                      Duration(microseconds: microseconds),
                    );
                  }
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    _isDragging = false;
                  });
                },
                onTapDown: (details) {
                  // Calculate position based on tap position
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset localOffset = box.globalToLocal(
                    details.globalPosition,
                  );
                  final double width = box.size.width;
                  final double center = width / 2;

                  if (_scrollController.hasClients) {
                    final double maxScroll =
                        _scrollController.position.maxScrollExtent;
                    final double currentScroll = _scrollController.offset;

                    // Calculate the new scroll position based on the tap offset from center
                    final double tapOffset = localOffset.dx - center;
                    final double newScroll = currentScroll + tapOffset;

                    // Constrain the scroll
                    final double boundedScroll = newScroll.clamp(
                      0.0,
                      maxScroll,
                    );
                    _scrollController.jumpTo(boundedScroll);

                    // Update the slider value
                    final double newValue = boundedScroll / maxScroll;
                    setState(() {
                      _sliderValue = newValue;
                    });

                    // Seek the video to the new position
                    final int microseconds =
                        (newValue * duration.inMicroseconds).round();
                    widget.videoPlayerController.seekTo(
                      Duration(microseconds: microseconds),
                    );
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: widget.height,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineMarkings extends StatelessWidget {
  final double width;
  final double height;
  final Duration duration;
  final Color color;

  const TimelineMarkings({
    Key? key,
    required this.width,
    required this.height,
    required this.duration,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: TimelineMarkingsPainter(duration: duration, color: color),
    );
  }
}

class TimelineMarkingsPainter extends CustomPainter {
  final Duration duration;
  final Color color;

  TimelineMarkingsPainter({required this.duration, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.0;

    // Draw timeline background line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Calculate number of marks based on duration
    final int durationInSeconds = duration.inSeconds;
    final int totalMarks = durationInSeconds + 1; // +1 to include 0

    if (totalMarks <= 1) return;

    final double markSpacing = size.width / (totalMarks - 1);

    // Draw marks
    for (int i = 0; i < totalMarks; i++) {
      final double x = i * markSpacing;

      // Major marks at 5-second intervals
      if (i % 5 == 0) {
        // Draw the mark
        canvas.drawLine(
          Offset(x, size.height * 0.35),
          Offset(x, size.height * 0.65),
          paint,
        );

        // Draw the time label
        final int seconds = i;
        final String label =
            "${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}";

        final TextSpan span = TextSpan(
          text: label,
          style: TextStyle(color: color, fontSize: 10),
        );

        final TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

        tp.layout();
        tp.paint(canvas, Offset(x - tp.width / 2, size.height * 0.15));
      } else {
        // Minor marks
        canvas.drawLine(
          Offset(x, size.height * 0.45),
          Offset(x, size.height * 0.55),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
