import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../download_helper.dart'; // Import the reusable class

class WhisperModel {
  final String name;
  final String url;
  double progress;
  bool exist;
  int size;

  WhisperModel({
    required this.name,
    required this.url,
    this.progress = 1,
    this.exist = false,
    this.size = 0,
  });

  //update progress
  updateProgress(double progress) {
    this.progress = progress;
  }
}

class DownloadModelPage extends StatefulWidget {
  @override
  _DownloadModelPageState createState() => _DownloadModelPageState();
}

class _DownloadModelPageState extends State<DownloadModelPage> {
  bool _isDownloading = false;

  List<WhisperModel> _modelList = [
    WhisperModel(
      name: 'tiny',
      size: 111,
      url:
          'https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-whisper-tiny.tar.bz2',
    ),

    WhisperModel(
      name: 'small',
      size: 610,
      url:
          'https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-whisper-small.tar.bz2',
    ),
    WhisperModel(
      name: 'turbo',
      size: 538,
      url:
          'https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-whisper-turbo.tar.bz2',
    ),
  ];

  @override
  void initState() {
    super.initState();
    checkModelExist();
  }

  Future<void> checkModelExist() async {
    final documentsDir = await getApplicationDocumentsDirectory();

    for (var model in _modelList) {
      if (await Directory(
        '${documentsDir.path}/models/sherpa-onnx-whisper-${model.name}',
      ).exists()) {
        model.exist = true;
      }
    }
    setState(() {});
  }

  Future<void> extractFile(bz2File, extractedFilePath) async {
    final extractedFile = await DownloadHelper.extractBz2(
      bz2File: bz2File,
      outputPath: extractedFilePath,
    );

    // Success
    print('File downloaded and extracted to: ${extractedFile.path}');
  }

  Future<double> getFileSizeInMB(File file) async {
    try {
      final fileLength = await file.length();
      return (fileLength / (1024 * 1024)).toDouble(); // Convert bytes to MB
    } catch (e) {
      print('Error getting file size: $e');
      return -1.0; // Or handle the error appropriately
    }
  }

  Future<void> startDownloadAndExtract(WhisperModel model) async {
    try {
      final tempDir = Directory.systemTemp;
      final bz2FilePath =
          '${tempDir.path}/sherpa-onnx-whisper-${model.name}.tar.bz2';
      final documentsDir = await getApplicationDocumentsDirectory();
      final extractedFilePath = '${documentsDir.path}/models';

      if (File(bz2FilePath).existsSync()) {
        print("EXIST");
        var size = await getFileSizeInMB(File(bz2FilePath));

        if (size >= model.size - 1) {
          return extractFile(File(bz2FilePath), extractedFilePath);
        }
      }

      setState(() {
        _isDownloading = true;
        model.updateProgress(0.0);
      });

      // Download the file
      final bz2File = await DownloadHelper.downloadFile(
        url: model.url,
        savePath: bz2FilePath,
        onProgress: (progress) {
          if (progress > 0) {
            setState(() {
              model.updateProgress(progress);
            });
          }
          if (progress == 1) {
            setState(() {
              model.exist = true;
            });
            // Extract the file
            print("FINISH");
          }
        },
      );
      bz2File.addListener(() {
        if (bz2File.value != null) {
          print(bz2File.value?.path);
          extractFile(bz2File.value, extractedFilePath);
        }
      });
    } catch (e, t) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error: $e');
      print(t);
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download Whisper Model')),
      body: Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              _modelList.map((model) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("${model.name} - ${model.size}MB"),
                              SizedBox(width: 8),
                              if (model.exist)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Exist",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          if (model.progress < 1)
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "${(model.progress * 100).toStringAsFixed(2)}%",
                                  ),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: model.progress,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        startDownloadAndExtract(model);
                      },
                      child:
                          model.progress < 1
                              ? Icon(Icons.downloading_outlined)
                              : (model.exist
                                  ? Icon(Icons.download_done)
                                  : Icon(Icons.download)),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: DownloadModelPage()));
