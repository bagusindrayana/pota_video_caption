import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../download_helper.dart'; // Import the reusable class

class WhisperModel {
  final String name;
  final String url;
  double progress;
  bool exist;

  WhisperModel({
    required this.name,
    required this.url,
    this.progress = 1,
    this.exist = false,
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
      url:
          'https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-whisper-tiny.tar.bz2',
    ),

    WhisperModel(
      name: 'small',
      url:
          'https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-whisper-small.tar.bz2',
    ),
    WhisperModel(
      name: 'turbo',
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
      final file = File(
        '${documentsDir.path}/sherpa-onnx-whisper-${model.name}/${model.name}-tokens.txt',
      );

      if (file.existsSync()) {
        model.exist = true;
      }
    }
    setState(() {});
  }

  Future<void> startDownloadAndExtract(WhisperModel model) async {
    setState(() {
      _isDownloading = true;
      model.updateProgress(0.0);
    });

    try {
      final tempDir = Directory.systemTemp;
      final bz2FilePath =
          '${tempDir.path}/sherpa-onnx-whisper-${model.name}.tar.bz2';

      final documentsDir = await getApplicationDocumentsDirectory();
      final extractedFilePath =
          '${documentsDir.path}/sherpa-onnx-whisper-${model.name}';

      // Download the file
      final bz2File = await DownloadHelper.downloadFile(
        url: model.url,
        savePath: bz2FilePath,
        onProgress: (progress) {
          print(progress);
          setState(() {
            model.updateProgress(progress);
          });
        },
      );

      // Extract the file
      final extractedFile = await DownloadHelper.extractBz2(
        bz2File: bz2File,
        outputPath: extractedFilePath,
      );

      // Success
      print('File downloaded and extracted to: ${extractedFile.path}');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error: $e');
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
                              Text(model.name),
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
