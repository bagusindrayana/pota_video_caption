import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pota_video_caption/caption_generator_controller.dart';
import 'package:pota_video_caption/models/video_project/video_project.dart';
import 'package:pota_video_caption/pages/download_model_page.dart';
import 'package:pota_video_caption/pages/video_result_preview.dart';
import 'package:pota_video_caption/utils/utils.dart' as utils;
import 'package:pota_video_caption/utils/ffmpeg_helper.dart' as ffmpeg_helper;
import 'package:pota_video_caption/models/video_project/video_project.dart'
    as vp;
import 'package:pota_video_caption/video_caption_controller.dart';
import 'package:pota_video_caption/widgets/bottom_sheet_with_controller.dart';
import 'package:pota_video_caption/widgets/caption_text_align.dart';
import 'package:pota_video_caption/widgets/caption_text_border.dart';
import 'package:pota_video_caption/widgets/caption_text_color.dart';
import 'package:pota_video_caption/widgets/caption_text_editor.dart';
import 'package:pota_video_caption/widgets/caption_text_font.dart';
import 'package:pota_video_caption/widgets/caption_text_size.dart';
import 'package:pota_video_caption/widgets/generate_caption_setting.dart';
import 'package:pota_video_caption/widgets/timeline_slider.dart';
import 'package:pota_video_caption/widgets/video_viewer.dart';
import 'package:path/path.dart' as path;

import 'package:pota_video_caption/utils/isar_service.dart';
import 'package:isar/isar.dart';

class CaptionEditorPage extends StatefulWidget {
  VideoProject? videoProject;
  CaptionEditorPage({super.key, this.videoProject});

  @override
  State<CaptionEditorPage> createState() => _CaptionEditorPageState();
}

class _CaptionEditorPageState extends State<CaptionEditorPage> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  VideoCaptoinController? _controller;

  final BottomSheetController _sheetController = BottomSheetController();
  final BottomSheetController _sheetController2 = BottomSheetController();
  double sheet2Height = 200;

  final BottomSheetManager _sheetManager = BottomSheetManager();

  List<String> _systemFonts = [];
  Widget bottomSheet2Content = const SizedBox();

  String? _videoPath;
  String? _audioPath;

  final IsarService isarService = IsarService();
  VideoProject? videoProject;

  CaptionGeneratorController _captionGeneratorController =
      CaptionGeneratorController();

  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captionGeneratorController.initSherpa();
    _sheetManager.registerSheet(_sheetController);
    _sheetManager.registerSheet(_sheetController2);
    _initAll();
  }

  Future<String?> _generateThumbnail(int id) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    var targetDir = documentsDir.path + "/thumbnail";
    if (!File(targetDir).existsSync()) {
      await Directory(targetDir).create(recursive: true);
    }
    String? targetPath = documentsDir.path + "/thumbnail/$id.png";
    // print("FRAME : ${(_controller!.videoDuration.inSeconds / 3).toInt()}");
    await FFmpegKit.execute(
      '-y -i "$_videoPath" -ss ${(_controller!.videoDuration.inSeconds / 3).toInt()}  -vframes 1 -vf  "scale=160:-1" -q:v 2 "$targetPath"',
    ).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
      } else {
        // ERROR
        targetPath = null;
      }

      final output = await session.getOutput();
      log("$output");

      final logs = await session.getLogs();
      for (var log in logs) {
        //print(log.getMessage());
      }
    });

    return targetPath;
  }

  Future<void> _checkData() async {
    var isar = isarService.isar;
    if (widget.videoProject == null) {
      final newProject = VideoProject(
        title: "Untitled",
        duration: 0,
        createdAt: DateTime.now(),
        videoPath: _videoPath,
      );

      await isar.writeTxn(() async {
        newProject.id = await isar.videoProjects.put(
          newProject,
        ); // insert & update
      });
      setState(() {
        videoProject = newProject;
      });
    } else {
      videoProject = widget.videoProject;
      _videoPath = videoProject!.videoPath;

      if (_videoPath != null) {
        await _initVideo(_videoPath!);
      }

      if (videoProject!.captions != null) {
        for (var caption in videoProject!.captions!) {
          _controller!.addCaption(
            ffmpeg_helper.Caption.fromJson(caption.toJson()),
          );
        }
      }
      setState(() {});
    }

    _titleController.text = videoProject?.title ?? "";
  }

  Future<void> _updateData() async {
    var isar = isarService.isar;

    List<vp.Caption> _captions = [];
    for (var caption in _controller!.captions) {
      _captions.add(vp.Caption.fromJson(caption.toJson()));
    }

    videoProject!.captions = _captions;

    await isar.writeTxn(() async {
      await isar.videoProjects.put(videoProject!); // insert & update
    });
  }

  Future<void> _initAll() async {
    await _checkData();
    await _captionGeneratorController.copyModel();
    await _getSystemFonts();
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
      try {
        if (fontFiles.existsSync()) {
          await fontFiles.list().forEach((fontFile) async {
            if ((fontFile.path.endsWith(".ttf") ||
                    fontFile.path.endsWith(".otf")) &&
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
      } catch (e) {}
    }

    setState(() {});
  }

  Future<String> extractAudio(String videoPath) async {
    final audioOutputPath =
        '${videoPath.replaceAll(RegExp(r'\.\w+$'), '')}_audio.wav';

    final command =
        '-y -i "$videoPath" -vn -acodec pcm_s16le -ar 16000 -ac 1 "$audioOutputPath"';

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
      } else {
        // ERROR
      }

      final output = await session.getOutput();
      //log("$output");

      final logs = await session.getLogs();
      for (var log in logs) {
        //print(log.getMessage());
      }
    });

    return audioOutputPath;
  }

  Future<void> _generateCaptions(String language, String model) async {
    if (_videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video file first')),
      );
      return;
    }

    if (mounted) {
      utils.loadingDialog(context);
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (_audioPath == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please select a video file first')),
      // );
      // return;

      var audioPath = await extractAudio(_videoPath!);
      setState(() {
        _audioPath = audioPath;
      });
    }
    try {
      await _captionGeneratorController.initializeModel(model, language);
    } catch (e) {
      print(e);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$e")));
      }
      return;
    }
    var newCaptions = await _captionGeneratorController.generateCaptions(
      _audioPath!,
    );

    for (var c in newCaptions) {
      _controller!.addCaption(c);
    }
    await _updateData();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller?.dispose();

    _sheetManager.unregisterSheet(_sheetController);
    _sheetManager.unregisterSheet(_sheetController2);
    _sheetController.dispose();
    _sheetController2.dispose();
    super.dispose();
  }

  void _showEditTextDialog(BuildContext context) {
    if (_controller!.highlightCaption == null) return;
    setState(() {
      bottomSheet2Content = CaptionTextEditor(
        caption: _controller!.highlightCaption!,
        onSaved: () {
          setState(() {});
          _controller?.updateListener();
        },
      );
      sheet2Height = 200;
    });
    _sheetController2.show();
  }

  void _showFontTextDialog(BuildContext context) {
    if (_controller!.highlightCaption == null) return;
    setState(() {
      bottomSheet2Content = CaptionTextFont(
        caption: _controller!.highlightCaption!,
        fonts: _systemFonts,
        onSaved: () {
          setState(() {});
          _controller?.updateListener();
        },
      );
      sheet2Height = 200;
    });
    _sheetController2.show();
  }

  void _showSizeTextDialog(BuildContext context) {
    if (_controller!.highlightCaption == null) return;
    setState(() {
      bottomSheet2Content = CaptionTextSize(
        caption: _controller!.highlightCaption!,
        onSaved: () {
          setState(() {});
          _controller?.updateListener();
        },
      );
      sheet2Height = 200;
    });
    _sheetController2.show();
  }

  void _showAlignTextDialog(BuildContext context) {
    if (_controller!.highlightCaption == null) return;
    setState(() {
      bottomSheet2Content = CaptionTextAlign(
        caption: _controller!.highlightCaption!,
        onSaved: () {
          setState(() {});
          _controller?.updateListener();
        },
      );
      sheet2Height = 200;
    });

    _sheetController2.show();
  }

  void _showColorTextDialog(BuildContext context) {
    if (_controller!.highlightCaption == null) return;
    setState(() {
      bottomSheet2Content = CaptionTextColor(
        caption: _controller!.highlightCaption!,
        onSaved: () {
          setState(() {});
          _controller?.updateListener();
        },
      );
      sheet2Height = 300;
    });
    _sheetController2.show();
  }

  void _showBorderTextDialog(BuildContext context) {
    if (_controller!.highlightCaption == null) return;
    setState(() {
      bottomSheet2Content = CaptionTextBorder(
        caption: _controller!.highlightCaption!,
        onSaved: () {
          setState(() {});
          _controller?.updateListener();
        },
      );
      sheet2Height = 350;
    });
    _sheetController2.show();
  }

  void _generateCaptionSetting(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return GenerateCaptionSetting(
          onSubmit: (language, model) {
            // _generateCaptions(language, model);
          },
        );
      },
    ).then((v) {
      if (v is String) {
        var data = jsonDecode(v);
        _generateCaptions(data['language'], data['model']);
      }
    });
  }

  Future<void> _pickVideo() async {
    if (_controller != null) {
      _controller!.deleteAllCaptions();
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      if (mounted) {
        _videoPath = result.files.single.path!;
        await _initVideo(_videoPath!);
      }
    }
  }

  Future<void> _initVideo(String url) async {
    if (mounted) {
      _controller = VideoCaptoinController.file(url);
      _controller!
          .initializeVideo()
          .then((_) async {
            if (videoProject!.thumbnail == null) {
              var thumbnail = await _generateThumbnail(videoProject!.id);
              videoProject!.thumbnail = thumbnail;
            }
            videoProject!.duration = _controller!.videoDuration.inSeconds;
            videoProject!.videoPath = url;
            await _updateData();
          })
          .catchError((error) {});
      _controller!.addListener(() {
        setState(() {});
        if (_controller!.video.value.isPlaying ||
            _controller!.highlightCaption == null) {
          _sheetController.hide();
          _sheetController2.hide();
        }
        _updateData();
      });
      _controller!.video.addListener(() {
        if (_controller!.video.value.isPlaying) {
          _sheetController.hide();
          _sheetController2.hide();
        }
        _updateData();
      });
    }
  }

  Future<void> _exportVideo() async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      print("Picking directory not supported");
      return;
    }
    if (mounted) {
      utils.loadingDialog(context);
    }

    //final documentsDir = await getApplicationDocumentsDirectory();
    var dateNow = DateTime.now();
    //foramt dateNow to Y_m_d_H_i_s
    var formatDate = dateNow
        .toString()
        .replaceAll('-', '_')
        .replaceAll(":", "_")
        .replaceAll(".", "_");
    var targetOutput =
        '${_videoPath!.replaceAll(RegExp(r'\.\w+$'), '')}_caption_$formatDate.mp4';

    ffmpeg_helper.FFmpegCaptionManager manager =
        ffmpeg_helper.FFmpegCaptionManager(
          inputVideoPath: _videoPath!,
          outputVideoPath: targetOutput,
          captions: _controller!.captions,
        );

    await FFmpegKit.execute(manager.generateCommand()).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        if (File(targetOutput).existsSync()) {
          //await 1 second
          await Future.delayed(const Duration(seconds: 1));

          final params = SaveFileDialogParams(sourceFilePath: targetOutput);
          final filePath = await FlutterFileDialog.saveFile(params: params);

          // print(filePath);
          if (filePath != null) {
            videoProject?.exported = true;
            await _updateData();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Video Exported : ${path.basename(filePath)}'),
                ),
              );
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoResultPreview(path: targetOutput),
                ),
              );
            }
          } else {
            if (mounted) {
              Navigator.pop(context);
            }
          }
        } else {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed to export video')));
          }
        }
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      } else {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to export video')));
        }
      }

      final output = await session.getOutput();
      //log("$output");

      final logs = await session.getLogs();
      for (var log in logs) {
        print(log.getMessage());
      }
    });
  }

  Future<void> _exportSRT() async {
    if (_controller!.captions.isEmpty || _videoPath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No subtitles to export')));
      return;
    }

    String srtContent = '';
    for (int i = 0; i < _controller!.captions.length; i++) {
      final subtitle = _controller!.captions[i];
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

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
    }
  }

  void _showEditTitleDialog() {
    //show alert dialog with input textfield to edit videoProject.title
    showDialog(
      barrierDismissible: false,
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename'),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                videoProject!.title = _titleController.text;
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showEditTitleDialog();
            },
            child: Text("${videoProject?.title}"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _exportVideo();
              },
              child: Text("Export"),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body:
            videoProject != null
                ? SafeArea(
                  child: Stack(
                    children: [
                      _controller != null && _controller!.initialized
                          ? GestureDetector(
                            onTap: () {
                              _controller?.dismissHighlightedCaption();
                              _sheetController.hide();
                              _sheetController2.hide();
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: VideoViewer(
                                      controller: _controller!,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${formatter(_controller!.videoPosition)}/${formatter(_controller!.videoDuration)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 50,
                                  ),
                                  child: TimelineSlider(
                                    height: 100,
                                    controller: _controller!,
                                    onCaptionTap: (caption) {
                                      _sheetController.show();
                                    },
                                  ),
                                ),

                                ValueListenableBuilder(
                                  valueListenable: _isExporting,
                                  builder:
                                      (_, bool export, Widget? child) =>
                                          AnimatedSize(
                                            duration: kThemeAnimationDuration,
                                            child: export ? child : null,
                                          ),
                                  child: AlertDialog(
                                    title: ValueListenableBuilder(
                                      valueListenable: _exportingProgress,
                                      builder:
                                          (_, double value, __) => Text(
                                            "Exporting video ${(value * 100).ceil()}%",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _pickVideo,
                                  child: Text("Select Video"),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder:
                                //             (context) => DownloadModelPage(),
                                //       ),
                                //     );
                                //   },
                                //   child: Text("Setting"),
                                // ),
                              ],
                            ),
                          ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if (_videoPath == null) {
                                  return;
                                }
                                _controller!.addCaption(
                                  ffmpeg_helper.Caption(
                                    startTime: _controller!.videoPosition,
                                    endTime:
                                        _controller!.videoPosition +
                                        Duration(seconds: 2),
                                    text: "Hello World",
                                    fontColor: "white",
                                    fontSize: 24,
                                    borderWidth: 2,
                                    borderColor: "black",
                                    textAlign: "center",
                                  ),
                                );
                                _updateData();
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.subtitles,
                                    color:
                                        _videoPath != null
                                            ? Colors.white
                                            : Colors.grey,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Add Caption",
                                    style: TextStyle(
                                      color:
                                          _videoPath != null
                                              ? Colors.white
                                              : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_videoPath == null) {
                                  return;
                                }
                                _generateCaptionSetting(context);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.generating_tokens,
                                    color:
                                        _videoPath != null
                                            ? Colors.white
                                            : Colors.grey,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "AI Caption",
                                    style: TextStyle(
                                      color:
                                          _videoPath != null
                                              ? Colors.white
                                              : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DownloadModelPage(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.settings, color: Colors.white),
                                  SizedBox(height: 4),
                                  Text(
                                    "Setting",
                                    style: TextStyle(
                                      color:
                                          _videoPath != null
                                              ? Colors.white
                                              : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      BottomSheetWithController(
                        controller: _sheetController,
                        sheetHeight: 100,
                        // Optional: hide the floating button if you only want to control it programmatically
                        // showButton: false,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.border_color_sharp,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _showEditTextDialog(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.text_fields,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Size",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _showSizeTextDialog(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.format_align_center,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Align",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _showAlignTextDialog(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.font_download_outlined,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Font",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _showFontTextDialog(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.color_lens_outlined,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Color",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _showColorTextDialog(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.text_format,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Border",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _showBorderTextDialog(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          _controller
                                              ?.deleteHighlightedCaption();
                                          _controller?.highlightCaption = null;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _sheetController.hide();
                                  _controller?.dismissHighlightedCaption();
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 42,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      BottomSheetWithController(
                        controller: _sheetController2,
                        sheetHeight: sheet2Height,
                        // Optional: hide the floating button if you only want to control it programmatically
                        // showButton: false,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: SingleChildScrollView(
                            child: bottomSheet2Content,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Center(child: CircularProgressIndicator()),
      ),
      onWillPop: () async {
        // Try to handle with sheet manager first
        if (_sheetManager.handleBackPress()) {
          return false; // Prevent app/page from closing
        }
        return true; // Allow normal back navigation
      },
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
  ].join(":");
}
