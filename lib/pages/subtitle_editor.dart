import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import 'package:bordered_text/bordered_text.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pota_video_caption/utils.dart' as utils;
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:path/path.dart' as path;
// import 'package:stroke_text/stroke_text.dart';
import 'package:video_player/video_player.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SubtitleEditor extends StatefulWidget {
  const SubtitleEditor({Key? key}) : super(key: key);

  @override
  _SubtitleEditorState createState() => _SubtitleEditorState();
}

class _SubtitleEditorState extends State<SubtitleEditor> {
  VideoPlayerController? _controller;
  String? _videoPath;
  String? _audioPath;
  List<utils.Subtitle> _subtitles = [];
  int _nextId = 1;
  bool _isPlaying = false;
  final ScrollController _timelineScrollController = ScrollController();
  final TextEditingController _subtitleTextController = TextEditingController();
  utils.Subtitle? _selectedSubtitle;
  Duration _currentPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  double _timelineScale = 100.0; // pixels per second
  bool _showPositionControls = false;

  // For subtitle preview in video
  String _currentSubtitleText = '';
  double _currentVerticalPosition = 0.9;
  double _currentHorizontalPosition = 0.5;
  double _currentFontSize = 16.0;
  String _currentFontFile = "/system/fonts/Roboto-Regular.ttf";
  TextAlign _currentTextAlign = TextAlign.center;

  sherpa_onnx.OfflineRecognizer? _recognizer;
  sherpa_onnx.OfflineStream? _stream;
  bool _isModelInitialized = false;

  sherpa_onnx.VoiceActivityDetector? _vad;
  sherpa_onnx.CircularBuffer? _buffer;
  sherpa_onnx.SileroVadModelConfig? sileroVadConfig;
  sherpa_onnx.VadModelConfig? vadConfig;

  List<String> _systemFonts = [];

  @override
  void initState() {
    super.initState();
    _getSystemFonts();
    _initializeWhisperModel();
  }

  Future<void> _getSystemFonts() async {
    var fontDirectories = [
      "/system/fonts/",
      "/system/font/",
      "/data/fonts/",
      "/system/product/fonts/",
    ];

    for (var fontDirectory in fontDirectories) {
      var fontFiles = Directory(fontDirectory);
      if (fontFiles.existsSync()) {
        await fontFiles.list().forEach((fontFile) async {
          if (fontFile.path.endsWith(".ttf") &&
              fontFile.path.contains("Regular")) {
            _systemFonts.add(fontFile.path);
            final bytes = await File(fontFile.path).readAsBytes();
            FontLoader(
                path
                    .basenameWithoutExtension(fontFile.path)
                    .replaceAll("-Regular", ""),
              )
              ..addFont(Future.value(ByteData.view(bytes.buffer)))
              ..load();
          }
        });
      }
    }

    setState(() {});
  }

  Future<void> _initializeWhisperModel() async {
    sherpa_onnx.initBindings();

    try {
      // Request storage permissions
      await _requestPermissions();

      // Get application documents directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final modelDir = Directory(
        '${documentsDir.path}/sherpa-onnx-whisper-tiny',
      );

      // Create the model directory if it doesn't exist
      if (!modelDir.existsSync()) {
        modelDir.createSync(recursive: true);
      }

      // Define model files to copy from assets
      final modelFiles = [
        'tiny-encoder.onnx',
        'tiny-decoder.onnx',
        'tiny-tokens.txt',
      ];

      // Copy model files from assets to documents directory
      for (final modelFile in modelFiles) {
        final assetFile = 'assets/sherpa-onnx-whisper-tiny/$modelFile';
        final targetFile = '${modelDir.path}/${modelFile.split('/').last}';

        if (!File(targetFile).existsSync()) {
          //final target = path.join(documentsDir.path, assetFile);
          final data = await rootBundle.load(assetFile);
          final bytes = data.buffer.asUint8List();
          await File(targetFile).writeAsBytes(bytes);
        }
      }

      final fontFiles = ['assets/fonts/kindymanscript.otf'];

      if (!Directory('${documentsDir.path}/fonts').existsSync()) {
        Directory('${documentsDir.path}/fonts').createSync(recursive: true);
      }

      for (final fontFile in fontFiles) {
        final targetFile =
            '${documentsDir.path}/fonts/${fontFile.split('/').last}';

        if (!File(targetFile).existsSync()) {
          //final target = path.join(documentsDir.path, assetFile);
          final data = await rootBundle.load(fontFile);
          final bytes = data.buffer.asUint8List();
          await File(targetFile).writeAsBytes(bytes);
        }
      }

      final whisper = sherpa_onnx.OfflineWhisperModelConfig(
        encoder: '${modelDir.path}/tiny-encoder.onnx',
        decoder: '${modelDir.path}/tiny-decoder.onnx',
      );

      final modelConfig = sherpa_onnx.OfflineModelConfig(
        whisper: whisper,
        tokens: '${modelDir.path}/tiny-tokens.txt',
        modelType: 'whisper',
        debug: false,
        numThreads: 2,
      );
      final config = sherpa_onnx.OfflineRecognizerConfig(model: modelConfig);

      final src = 'assets/vad/silero_vad.onnx';
      final modelPath = await utils.copyAssetFile(src, 'silero_vad.onnx');

      sileroVadConfig = sherpa_onnx.SileroVadModelConfig(
        model: modelPath,
        minSpeechDuration: 0.25,
        minSilenceDuration: 0.25,
        threshold: 0.5,
        maxSpeechDuration: 5,
      );

      if (sileroVadConfig != null) {
        vadConfig = sherpa_onnx.VadModelConfig(
          sileroVad: sileroVadConfig!,
          numThreads: 2,
          debug: true,
        );
      }

      setState(() {
        _recognizer = sherpa_onnx.OfflineRecognizer(config);

        if (vadConfig != null) {
          _vad = sherpa_onnx.VoiceActivityDetector(
            config: vadConfig!,
            bufferSizeInSeconds: 180,
          );
        }

        _isModelInitialized = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Whisper model initialized successfully')),
      );
    } catch (e, t) {
      print(e);
      print(t);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize Whisper model: $e')),
      );
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timelineScrollController.dispose();
    _subtitleTextController.dispose();
    super.dispose();
  }

  Future<String> extractAudio(String videoPath) async {
    final audioOutputPath =
        '${videoPath.replaceAll(RegExp(r'\.\w+$'), '')}_audio.wav';

    final command =
        '-y -i "$videoPath" -vn -acodec pcm_s16le -ar 16000 -ac 1 "$audioOutputPath"';

    await FFmpegKit.execute(command);

    return audioOutputPath;
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      if (mounted) {
        context.loaderOverlay.show();
      }
      // final documentsDir = await getApplicationDocumentsDirectory();
      // FFmpegCaption caption = FFmpegCaption(
      //   inputVideoPath: result.files.single.path!,
      //   outputVideoPath:
      //       '${result.files.single.path!.replaceAll(RegExp(r'\.\w+$'), '')}_output.mp4',
      //   text: 'Hello World',
      //   fontColor: 'red',
      //   fontSize: 36,
      //   startTime: 2,
      //   endTime: 8,
      //   fontFile: "${documentsDir.path}/fonts/kindymanscript.otf",
      // );
      // print(caption.generateCommand());
      // print(File("${documentsDir.path}/fonts/kindymanscript.otf").existsSync());

      // FFmpegKit.execute(caption.generateCommand()).then((session) async {
      //   final returnCode = await session.getReturnCode();
      //   print(returnCode.toString());

      //   if (ReturnCode.isSuccess(returnCode)) {
      //     setState(() {
      //       _videoPath =
      //           '${result.files.single.path!.replaceAll(RegExp(r'\.\w+$'), '')}_output.mp4';
      //     });
      //     _initializeVideoPlayer();
      //     // SUCCESS
      //   } else if (ReturnCode.isCancel(returnCode)) {
      //     // CANCEL
      //     print("CANCEL");
      //   } else {
      //     // ERROR
      //     print("ERROR");
      //   }
      //   final output = await session.getOutput();
      //   log("$output");
      //   final failStackTrace = await session.getFailStackTrace();
      //   print(failStackTrace);
      // });

      var audioPath = await extractAudio(result.files.single.path!);
      setState(() {
        _videoPath = result.files.single.path!;
        _audioPath = audioPath;
      });
      _initializeVideoPlayer();
      //await _generateSubtitle();
      if (mounted) {
        context.loaderOverlay.hide();
      }
    }
  }

  Future<void> _generateSubtitle() async {
    if (_audioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a WAV file first')),
      );
      return;
    }

    if (!_isModelInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Model is not initialized yet. Please wait.'),
        ),
      );
      return;
    }

    setState(() {
      _buffer = sherpa_onnx.CircularBuffer(capacity: 16000 * 180);
      print(_buffer!.ptr);
      if (_vad != null) {
        _vad!.clear();
        if (vadConfig != null) {
          _vad = sherpa_onnx.VoiceActivityDetector(
            config: vadConfig!,
            bufferSizeInSeconds: 180,
          );
        }
      }
    });

    try {
      final waveData = sherpa_onnx.readWave(_audioPath!);

      _buffer!.push(waveData.samples);
      final windowSize = _vad!.config.sileroVad.windowSize;

      while (_buffer!.size > windowSize) {
        final samples = _buffer!.get(startIndex: _buffer!.head, n: windowSize);

        _vad!.acceptWaveform(samples);
        _buffer!.pop(windowSize);
        if (_vad!.isDetected()) {
          //print('detected');
        }

        if (!_vad!.isDetected()) {
          //print('not detected');
        }
        //print(_vad!.front());
        if (!_vad!.isEmpty()) {
          try {
            // print(
            //   "Start : ${_vad != null ? (_vad!.front().start / 16000) : 0}",
            // );
            // print(
            //   "End : ${_vad != null ? (_vad!.front().samples.length / 16000) : 0}",
            // );

            _stream = _recognizer?.createStream();
            _stream?.acceptWaveform(
              samples: _vad!.front().samples,
              sampleRate: 16000,
            );
            _recognizer?.decode(_stream!);

            final result = _recognizer?.getResult(_stream!);

            // var segment = {
            //   "start": _vad != null ? (_vad!.front().start / 16000) : 0,
            //   "duration":
            //       _vad != null ? (_vad!.front().samples.length / 16000) : 0,
            //   "text": result?.text,
            // };
            var start =
                _vad != null ? ((_vad!.front().start / 16000) * 1000) : 0;
            var duration =
                _vad != null
                    ? ((_vad!.front().samples.length / 16000) * 1000)
                    : 0;

            final newSubtitle = utils.Subtitle(
              id: _nextId++,
              startTime: Duration(milliseconds: start.toInt()),
              endTime: Duration(milliseconds: (start + duration).toInt()),
              text: "${result?.text.trim()}",
            );

            _subtitles.add(newSubtitle);
          } catch (e) {
            print(e);
          }

          await Future.delayed(const Duration(milliseconds: 500));

          _vad!.pop();
        }
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void _initializeVideoPlayer() async {
    if (_videoPath != null) {
      _controller = VideoPlayerController.file(File(_videoPath!))
        ..initialize().then((_) {
          setState(() {
            _videoDuration = _controller!.value.duration;
          });
          _setupVideoListener();
        });
    }
  }

  void _setupVideoListener() {
    _controller!.addListener(() {
      if (_controller!.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller!.value.isPlaying;
        });
      }

      setState(() {
        _currentPosition = _controller!.value.position;
      });

      // Auto-scroll timeline to match current position
      if (_isPlaying) {
        _scrollTimelineToCurrentPosition();
      }

      // Display current subtitle (if any)
      _checkCurrentSubtitle();
    });
  }

  void _scrollTimelineToCurrentPosition() {
    double pixelPosition =
        _currentPosition.inMilliseconds / 1000 * _timelineScale;
    if (pixelPosition >
            _timelineScrollController.position.pixels +
                _timelineScrollController.position.viewportDimension / 2 ||
        pixelPosition < _timelineScrollController.position.pixels) {
      _timelineScrollController.animateTo(
        pixelPosition -
            _timelineScrollController.position.viewportDimension / 2,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _checkCurrentSubtitle() {
    utils.Subtitle? currentSub;
    for (var subtitle in _subtitles) {
      if (_currentPosition >= subtitle.startTime &&
          _currentPosition <= subtitle.endTime) {
        currentSub = subtitle;
        break;
      }
    }

    if (currentSub != null) {
      setState(() {
        _currentSubtitleText = currentSub!.text;
        _currentVerticalPosition = currentSub.verticalPosition;
        _currentHorizontalPosition = currentSub.horizontalPosition;
        _currentTextAlign = currentSub.textAlign;
      });
    } else {
      setState(() {
        _currentSubtitleText = '';
      });
    }

    if (currentSub != _selectedSubtitle) {
      setState(() {
        _selectedSubtitle = currentSub;
        if (currentSub != null) {
          _subtitleTextController.text = currentSub.text;
        }
      });
    }
  }

  void _playPause() {
    if (_controller != null) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  void _seekToPosition(Duration position) {
    if (_controller != null) {
      _controller!.seekTo(position);
    }
  }

  void _addSubtitle() {
    Duration startTime = _currentPosition;
    Duration endTime = startTime + const Duration(seconds: 3);

    if (endTime > _videoDuration) {
      endTime = _videoDuration;
    }

    final newSubtitle = utils.Subtitle(
      id: _nextId++,
      startTime: startTime,
      endTime: endTime,
      text: "",
    );

    setState(() {
      _subtitles.add(newSubtitle);
      _selectedSubtitle = newSubtitle;
      _subtitleTextController.text = "";
      _showPositionControls = true;
    });

    _sortSubtitles();
  }

  void _deleteSubtitle() {
    if (_selectedSubtitle != null) {
      setState(() {
        _subtitles.removeWhere((sub) => sub.id == _selectedSubtitle!.id);
        _selectedSubtitle = null;
        _subtitleTextController.text = "";
        _showPositionControls = false;
      });
    }
  }

  void _updateSubtitleText() {
    if (_selectedSubtitle != null) {
      setState(() {
        _selectedSubtitle!.text = _subtitleTextController.text;
        _currentSubtitleText = _subtitleTextController.text;
      });
    }
  }

  void _updateSubtitleTiming(Duration startTime, Duration endTime) {
    if (_selectedSubtitle != null) {
      setState(() {
        int index = _subtitles.indexWhere(
          (sub) => sub.id == _selectedSubtitle!.id,
        );
        if (index >= 0) {
          utils.Subtitle updated = utils.Subtitle(
            id: _selectedSubtitle!.id,
            startTime: startTime,
            endTime: endTime,
            text: _selectedSubtitle!.text,
            verticalPosition: _selectedSubtitle!.verticalPosition,
            horizontalPosition: _selectedSubtitle!.horizontalPosition,
            textAlign: _selectedSubtitle!.textAlign,
          );
          _subtitles[index] = updated;
          _selectedSubtitle = updated;
        }
      });
      _sortSubtitles();
    }
  }

  void _updateCurrentSubtitle(
    double vertical,
    double horizontal,
    TextAlign align,
  ) {
    if (_selectedSubtitle != null) {
      setState(() {
        int index = _subtitles.indexWhere(
          (sub) => sub.id == _selectedSubtitle!.id,
        );
        if (index >= 0) {
          utils.Subtitle updated = utils.Subtitle(
            id: _selectedSubtitle!.id,
            startTime: _selectedSubtitle!.startTime,
            endTime: _selectedSubtitle!.endTime,
            text: _selectedSubtitle!.text,
            verticalPosition: vertical,
            horizontalPosition: horizontal,
            textAlign: align,
          );
          _subtitles[index] = updated;
          _selectedSubtitle = updated;

          // Update current display
          _currentVerticalPosition = vertical;
          _currentHorizontalPosition = horizontal;
          _currentTextAlign = align;
        }
      });
    }
  }

  void _sortSubtitles() {
    setState(() {
      _subtitles.sort((a, b) => a.startTime.compareTo(b.startTime));
    });
  }

  Future<void> _exportSRT() async {
    if (_subtitles.isEmpty || _videoPath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No subtitles to export')));
      return;
    }

    _sortSubtitles();

    String srtContent = '';
    for (int i = 0; i < _subtitles.length; i++) {
      final subtitle = _subtitles[i];
      srtContent += '${i + 1}\n';
      srtContent += '${subtitle.advancedSrtFormat}\n';
      srtContent += '${subtitle.text}\n\n';
    }

    final directory = await getApplicationDocumentsDirectory();
    final videoFileName = path.basename(_videoPath!);
    final srtFileName = videoFileName.replaceAll(
      path.extension(videoFileName),
      '.srt',
    );
    final file = File('${directory.path}/$srtFileName');

    await file.writeAsString(srtContent);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
  }

  Future<void> _exportVideo() async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      print("Picking directory not supported");
      return;
    }

    if (mounted) {
      context.loaderOverlay.show();
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    var captions = <utils.Caption>[];
    for (final subtitle in _subtitles) {
      utils.Caption caption = utils.Caption(
        text: subtitle.text.replaceAll('"', '').replaceAll("'", ""),
        fontColor: 'white',
        fontSize: subtitle.fontSize,
        fontFile: subtitle.fontFile,
        startTime: subtitle.startTime,
        endTime: subtitle.endTime,
        addBox: true,
        boxColor: 'black@0.6',
        // textAlign: 'center',
        borderWidth: 2,
        borderColor: 'black',
        // shadowX: 2,
        // shadowY: 2,
        // shadowColor: 0x000000,
        lineSpacing: 10,
        alpha: 0.8,
        x: subtitle.horizontalPosition,
        y: subtitle.verticalPosition,
      );

      captions.add(caption);
    }

    // captions = [captions[0], captions[1]];

    utils.FFmpegCaptionManager manager = utils.FFmpegCaptionManager(
      inputVideoPath: _videoPath!,
      outputVideoPath:
          '${_videoPath!.replaceAll(RegExp(r'\.\w+$'), '')}_output.mp4',
      captions: captions,
    );
    // log(manager.generateCommand());

    await FFmpegKit.execute(manager.generateCommand()).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
      } else {
        // ERROR
      }

      final output = await session.getOutput();
      log("$output");

      final logs = await session.getLogs();
      for (var log in logs) {
        print(log.getMessage());
      }
    });

    //await 1 second
    await Future.delayed(const Duration(seconds: 1));

    final params = SaveFileDialogParams(
      sourceFilePath:
          '${_videoPath!.replaceAll(RegExp(r'\.\w+$'), '')}_output.mp4',
    );
    final filePath = await FlutterFileDialog.saveFile(params: params);

    print(filePath);

    if (mounted) {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subtitle Editor'),
        actions: [
          if (_videoPath != null) ...[
            IconButton(
              onPressed: () {
                _pickVideo();
              },
              icon: const Icon(Icons.video_file),
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _exportVideo,
              tooltip: 'Export SRT',
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video player
            _buildVideoPlayer(),

            // Playback controls
            _buildPlaybackControls(),

            // Timeline
            _buildTimeline(),

            // // Subtitle editor
            _buildSubtitleEditor(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _videoPath == null ? _pickVideo : _addSubtitle,
        tooltip: _videoPath == null ? 'Pick Video' : 'Add Subtitle',
        child: Icon(_videoPath == null ? Icons.video_library : Icons.add),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 240,
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_controller == null ||
              (_controller != null && !_controller!.value.isInitialized)) {
            return Center(child: const Text('Select a video to get started'));
          }
          // Video dimensions
          double videoWidth = constraints.maxWidth;
          double videoHeight = constraints.maxHeight;

          double referenceHeight =
              _controller!
                  .value
                  .size
                  .height; // Reference video height (e.g., 1080p)

          // Calculate scaling factor based on video height
          double scalingFactor = videoHeight / referenceHeight;

          // Calculate subtitle position relative to video size
          double subtitleWidth = videoWidth * 0.8; // 80% of video width
          double subtitleHeight = videoHeight * 0.1; // 10% of video height

          double subtitleLeft = (videoWidth) * _currentHorizontalPosition;
          double subtitleTop =
              videoHeight * _currentVerticalPosition - subtitleHeight / 2;

          // Ensure the subtitle stays within the video bounds
          // subtitleLeft = subtitleLeft.clamp(0, videoWidth);
          // subtitleTop = subtitleTop.clamp(0, videoHeight - subtitleHeight);

          return Stack(
            children: [
              Center(
                child:
                    _controller != null && _controller!.value.isInitialized
                        ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                        : _videoPath == null
                        ? const Text('Select a video to get started')
                        : const CircularProgressIndicator(),
              ),

              // Subtitle overlay with gesture detection
              if (_currentSubtitleText.isNotEmpty)
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
                      double baseFontSize = _currentFontSize;

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
                          _updateCurrentSubtitle(
                            newVertical,
                            newHorizontal,
                            _currentTextAlign,
                          );
                        },
                        child: Container(
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: 12,
                          //   vertical: 6,
                          // ),
                          // decoration: BoxDecoration(
                          //   color: Colors.black.withOpacity(0.6),
                          //   borderRadius: BorderRadius.circular(4),
                          // ),
                          child: BorderedText(
                            strokeWidth: 2,
                            strokeColor: Colors.black,
                            child: Text(
                              _currentSubtitleText,
                              textAlign: _currentTextAlign,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: relativeFontSize,
                                fontFamily: _currentFontFile
                                    .split("/")
                                    .last
                                    .split(".")
                                    .first
                                    .replaceAll("-Regular", ""),
                                // backgroundColor: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),

                          // child: StrokeText(
                          //   text: _currentSubtitleText,
                          //   textAlign: _currentTextAlign,
                          //   textStyle: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: relativeFontSize,
                          //     fontFamily: _currentFontFile
                          //         .split("/")
                          //         .last
                          //         .split(".")
                          //         .first
                          //         .replaceAll("-Regular", ""),
                          //     backgroundColor: Colors.black.withOpacity(0.6),
                          //   ),
                          //   strokeColor: Colors.black,
                          //   strokeWidth: 2,
                          // ),
                        ),
                      );
                    },
                  ),
                ),
              // Positioned.fill(
              //   child: LayoutBuilder(
              //     builder: (context, constraints) {
              //       return Stack(
              //         children: [
              //           Positioned(
              //             left:
              //                 constraints.maxWidth *
              //                     (_currentHorizontalPosition - 0.5) +
              //                 constraints.maxWidth * 0.5 -
              //                 150,
              //             top:
              //                 constraints.maxHeight * _currentVerticalPosition -
              //                 40,
              //             child: GestureDetector(
              //               onPanUpdate: (details) {
              //                 // Calculate new position based on drag delta
              //                 double newVertical =
              //                     _currentVerticalPosition +
              //                     (details.delta.dy / constraints.maxHeight);
              //                 double newHorizontal =
              //                     _currentHorizontalPosition +
              //                     (details.delta.dx / constraints.maxWidth);

              //                 // Clamp values between 0.0 and 1.0
              //                 newVertical = newVertical.clamp(0.0, 1.0);
              //                 newHorizontal = newHorizontal.clamp(0.0, 1.0);

              //                 // Update subtitle position
              //                 _updateCurrentSubtitle(
              //                   newVertical,
              //                   newHorizontal,
              //                   _currentTextAlign,
              //                 );
              //               },
              //               child: Container(
              //                 padding: EdgeInsets.symmetric(
              //                   horizontal: 12,
              //                   vertical: 6,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   color: Colors.black.withOpacity(0.6),
              //                   borderRadius: BorderRadius.circular(4),
              //                 ),
              //                 child: Text(
              //                   _currentSubtitleText,
              //                   textAlign: _currentTextAlign,
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize:
              //                         _selectedSubtitle!.fontSize!.toDouble(),
              //                     fontFamily: _selectedSubtitle!.fontFile!
              //                         .split("/")
              //                         .last
              //                         .split(".")
              //                         .first
              //                         .replaceAll("-Regular", ""),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _controller != null ? _playPause : null,
          ),
          Expanded(
            child: Slider(
              value: _currentPosition.inMilliseconds.toDouble(),
              min: 0.0,
              max: _videoDuration.inMilliseconds.toDouble(),
              onChanged: (value) {
                _seekToPosition(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
          Text(
            '${_formatDuration(_currentPosition)} / ${_formatDuration(_videoDuration)}',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildTimeline() {
    double totalWidth = _videoDuration.inMilliseconds / 1000 * _timelineScale;

    return Container(
      height: 120,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Timeline'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () {
                        setState(() {
                          _timelineScale = (_timelineScale * 0.8).clamp(
                            50,
                            500,
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () {
                        setState(() {
                          _timelineScale = (_timelineScale * 1.2).clamp(
                            50,
                            500,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(4),
              ),
              margin: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                controller: _timelineScrollController,
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: totalWidth,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      // Time markers
                      ..._buildTimeMarkers(totalWidth),

                      // Subtitle blocks
                      ..._buildSubtitleBlocks(),

                      // Current position indicator
                      Positioned(
                        left:
                            _currentPosition.inMilliseconds /
                            1000 *
                            _timelineScale,
                        top: 0,
                        bottom: 0,
                        child: Container(width: 2, color: Colors.red),
                      ),

                      // Handle timeline clicks
                      Positioned.fill(
                        child: GestureDetector(
                          onTapDown: (details) {
                            double position =
                                details.localPosition.dx / _timelineScale;
                            _seekToPosition(
                              Duration(milliseconds: (position * 1000).toInt()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimeMarkers(double totalWidth) {
    List<Widget> markers = [];

    // Add second markers
    int totalSeconds = _videoDuration.inSeconds;
    for (int i = 0; i <= totalSeconds; i++) {
      double position = i * _timelineScale;

      if (position <= totalWidth) {
        markers.add(
          Positioned(
            left: position,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              color: i % 5 == 0 ? Colors.grey.shade500 : Colors.grey.shade700,
            ),
          ),
        );

        if (i % 5 == 0) {
          markers.add(
            Positioned(
              left: position,
              top: 0,
              child: Text(
                _formatDuration(Duration(seconds: i)),
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ),
          );
        }
      }
    }

    return markers;
  }

  List<Widget> _buildSubtitleBlocks() {
    return _subtitles.map((subtitle) {
      bool isSelected = _selectedSubtitle?.id == subtitle.id;

      double startPosition =
          subtitle.startTime.inMilliseconds / 1000 * _timelineScale;
      double endPosition =
          subtitle.endTime.inMilliseconds / 1000 * _timelineScale;
      double width = endPosition - startPosition;

      return Positioned(
        left: startPosition,
        width: width,
        top: 20,
        height: 60,
        child: Stack(
          children: [
            // Subtitle block
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSubtitle = subtitle;
                    _subtitleTextController.text = subtitle.text;
                    _showPositionControls = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.blue.withOpacity(0.6)
                            : Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.blue,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle.text.isEmpty ? '(No text)' : subtitle.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                      if (isSelected)
                        Text(
                          'V: ${(subtitle.verticalPosition * 100).round()}% H: ${(subtitle.horizontalPosition * 100).round()}%',
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                    ],
                  ),
                ),
                onHorizontalDragStart: (details) {
                  setState(() {
                    _selectedSubtitle = subtitle;
                    _subtitleTextController.text = subtitle.text;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  if (_selectedSubtitle?.id == subtitle.id) {
                    double deltaSeconds = details.delta.dx / _timelineScale;
                    Duration delta = Duration(
                      milliseconds: (deltaSeconds * 1000).toInt(),
                    );

                    Duration newStartTime = subtitle.startTime + delta;
                    Duration newEndTime = subtitle.endTime + delta;

                    if (newStartTime >= Duration.zero &&
                        newEndTime <= _videoDuration) {
                      _updateSubtitleTiming(newStartTime, newEndTime);
                    }
                  }
                },
              ),
            ),

            // Left handle for adjusting start time
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 16,
              child: GestureDetector(
                // behavior: HitTestBehavior.translucent,
                onTap: () {
                  print("LEFT HANDLE");
                },
                onHorizontalDragStart: (details) {
                  setState(() {
                    _selectedSubtitle = subtitle;
                    _subtitleTextController.text = subtitle.text;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  if (_selectedSubtitle?.id == subtitle.id) {
                    double deltaSeconds = details.delta.dx / _timelineScale;
                    Duration delta = Duration(
                      milliseconds: (deltaSeconds * 1000).toInt(),
                    );

                    Duration newStartTime = subtitle.startTime + delta;

                    // Ensure the new start time is valid
                    if (newStartTime >= Duration.zero &&
                        newStartTime < subtitle.endTime) {
                      _updateSubtitleTiming(newStartTime, subtitle.endTime);
                    }
                  }
                },

                child: Container(color: Colors.blueAccent, width: 16),
              ),
            ),

            // Right handle for adjusting end time
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 16,
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  setState(() {
                    _selectedSubtitle = subtitle;
                    _subtitleTextController.text = subtitle.text;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  if (_selectedSubtitle?.id == subtitle.id) {
                    double deltaSeconds = details.delta.dx / _timelineScale;
                    Duration delta = Duration(
                      milliseconds: (deltaSeconds * 1000).toInt(),
                    );

                    Duration newEndTime = subtitle.endTime + delta;

                    // Ensure the new end time is valid
                    if (newEndTime > subtitle.startTime &&
                        newEndTime <= _videoDuration) {
                      _updateSubtitleTiming(subtitle.startTime, newEndTime);
                    }
                  }
                },

                child: Container(color: Colors.blueAccent, width: 16),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSubtitleEditor() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _selectedSubtitle == null
                    ? 'No subtitle selected'
                    : 'Editing subtitle #${_subtitles.indexOf(_selectedSubtitle!) + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (_selectedSubtitle != null) ...[
                IconButton(
                  icon: Icon(
                    _showPositionControls
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPositionControls = !_showPositionControls;
                    });
                  },
                  tooltip:
                      _showPositionControls
                          ? 'Hide position controls'
                          : 'Show position controls',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSubtitle,
                  tooltip: 'Delete subtitle',
                ),
              ],
            ],
          ),
          if (_selectedSubtitle != null) ...[
            // const SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         decoration: const InputDecoration(
            //           labelText: 'Start time',
            //           border: OutlineInputBorder(),
            //         ),
            //         initialValue: _formatDuration(_selectedSubtitle!.startTime),
            //         readOnly: true,
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: TextFormField(
            //         decoration: const InputDecoration(
            //           labelText: 'End time',
            //           border: OutlineInputBorder(),
            //         ),
            //         initialValue: _formatDuration(_selectedSubtitle!.endTime),
            //         readOnly: true,
            //       ),
            //     ),
            //   ],
            // ),

            // Position controls (expanded/collapsed)
            if (_showPositionControls) ...[
              const SizedBox(height: 16),
              const Text(
                'Position Controls:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Vertical (${(_selectedSubtitle!.verticalPosition * 100).round()}%)',
              //           ),
              //           Slider(
              //             value: _selectedSubtitle!.verticalPosition,
              //             min: 0.0,
              //             max: 1.0,
              //             divisions: 10,
              //             label:
              //                 '${(_selectedSubtitle!.verticalPosition * 100).round()}%',
              //             onChanged: (value) {
              //               _updateCurrentSubtitle(
              //                 value,
              //                 _selectedSubtitle!.horizontalPosition,
              //                 _selectedSubtitle!.textAlign,
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),

              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Horizontal (${(_selectedSubtitle!.horizontalPosition * 100).round()}%)',
              //           ),
              //           Slider(
              //             value: _selectedSubtitle!.horizontalPosition,
              //             min: 0.0,
              //             max: 1.0,
              //             divisions: 10,
              //             label:
              //                 '${(_selectedSubtitle!.horizontalPosition * 100).round()}%',
              //             onChanged: (value) {
              //               _updateCurrentSubtitle(
              //                 _selectedSubtitle!.verticalPosition,
              //                 value,
              //                 _selectedSubtitle!.textAlign,
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 8),
              Row(
                children: [
                  Text('Text Alignment:'),
                  const SizedBox(width: 16),
                  ToggleButtons(
                    isSelected: [
                      _selectedSubtitle!.textAlign == TextAlign.left,
                      _selectedSubtitle!.textAlign == TextAlign.center,
                      _selectedSubtitle!.textAlign == TextAlign.right,
                    ],
                    onPressed: (index) {
                      TextAlign newAlign;
                      switch (index) {
                        case 0:
                          newAlign = TextAlign.left;
                          break;
                        case 1:
                          newAlign = TextAlign.center;
                          break;
                        case 2:
                          newAlign = TextAlign.right;
                          break;
                        default:
                          newAlign = TextAlign.center;
                      }

                      _updateCurrentSubtitle(
                        _selectedSubtitle!.verticalPosition,
                        _selectedSubtitle!.horizontalPosition,
                        newAlign,
                      );
                    },
                    children: const [
                      Icon(Icons.format_align_left),
                      Icon(Icons.format_align_center),
                      Icon(Icons.format_align_right),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              //font selection
              Row(
                children: [
                  Text('Font:'),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _currentFontFile,
                    items:
                        _systemFonts
                            .map(
                              (font) => DropdownMenuItem(
                                value: font,
                                child: Text(
                                  font
                                      .split("/")
                                      .last
                                      .split(".")
                                      .first
                                      .replaceAll("-Regular", ""),
                                  style: TextStyle(
                                    fontFamily: font
                                        .split("/")
                                        .last
                                        .split(".")
                                        .first
                                        .replaceAll("-Regular", ""),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubtitle!.fontFile = value;
                        _currentFontFile = value!;
                      });
                    },
                  ),
                ],
              ),

              //font size
              Row(
                children: [
                  Text('Font Size:'),
                  const SizedBox(width: 16),
                  Slider(
                    value: _currentFontSize,
                    min: 8.0,
                    max: 72.0,
                    divisions: 10,
                    label:
                        '${_selectedSubtitle!.fontSize!.toDouble().toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() {
                        _selectedSubtitle!.fontSize = value.toInt();
                        _currentFontSize = value;
                      });
                    },
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),
            TextField(
              controller: _subtitleTextController,
              decoration: const InputDecoration(
                labelText: 'Subtitle text',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: null,
              // expands: true,
              onChanged: (value) {
                _updateSubtitleText();
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _updateSubtitleTiming(
                      _currentPosition,
                      _selectedSubtitle!.endTime,
                    );
                  },
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Set start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _updateSubtitleTiming(
                      _selectedSubtitle!.startTime,
                      _currentPosition,
                    );
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text('Set end'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
