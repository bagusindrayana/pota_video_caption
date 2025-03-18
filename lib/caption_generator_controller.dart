import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:pota_video_caption/utils/utils.dart' as utils;
import 'package:pota_video_caption/utils/ffmpeg_helper.dart' as ffmpeg_helper;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class CaptionGeneratorController extends ChangeNotifier {
  sherpa_onnx.OfflineRecognizer? _recognizer;
  sherpa_onnx.OfflineStream? _stream;
  bool _isModelInitialized = false;

  sherpa_onnx.VoiceActivityDetector? _vad;
  sherpa_onnx.CircularBuffer? _buffer;
  sherpa_onnx.SileroVadModelConfig? sileroVadConfig;
  sherpa_onnx.VadModelConfig? vadConfig;

  List<String> models = ['tiny', 'small', 'turbo'];

  double _downloadProgress = 0.0;
  bool _isDownloading = false;

  Future<void> requestPermissions() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future _myLoadAsset(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  void initSherpa() {
    sherpa_onnx.initBindings();
  }

  Future<void> copyModel() async {
    try {
      // Request storage permissions
      await requestPermissions();

      // Get application documents directory
      final documentsDir = await getApplicationDocumentsDirectory();

      for (var model in models) {
        final modelDir = Directory(
          '${documentsDir.path}/models/sherpa-onnx-whisper-$model',
        );

        // Create the model directory if it doesn't exist
        if (!modelDir.existsSync()) {
          modelDir.createSync(recursive: true);
        }

        // Define model files to copy from assets
        final modelFiles = [
          '$model-encoder.int8.onnx',
          '$model-decoder.int8.onnx',
          '$model-tokens.txt',
        ];

        // Copy model files from assets to documents directory
        for (final modelFile in modelFiles) {
          final assetFile =
              'assets/models/sherpa-onnx-whisper-$model/$modelFile';
          final targetFile = '${modelDir.path}/${modelFile.split('/').last}';

          if (!File(targetFile).existsSync()) {
            //final target = path.join(documentsDir.path, assetFile);
            final data = await _myLoadAsset(assetFile);
            if (data != null) {
              final bytes = data.buffer.asUint8List();
              await File(targetFile).writeAsBytes(bytes);
            }
          }
        }
      }

      final src = 'assets/vad/silero_vad.onnx';
      await utils.copyAssetFile(src, 'silero_vad.onnx');
    } catch (e, t) {
      print(e);
      print(t);
    }
    notifyListeners();
  }

  Future<void> downloadModel(String url, String model) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Save the file to a temporary directory
        final tempDir = Directory.systemTemp;
        final file = File('${tempDir.path}/sherpa-onnx-whisper-$model.bz2');
        await file.writeAsBytes(response.bodyBytes);

        // Extract the .bz2 file
        final extractedFile = await extractBz2(file);

        // Do something with the extracted file
        print('File extracted to: ${extractedFile.path}');
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {}
  }

  Future<File> extractBz2(File bz2File) async {
    final bytes = await bz2File.readAsBytes();
    final archive = BZip2Decoder().decodeBytes(bytes);

    // Save the extracted file
    final tempDir = Directory.systemTemp;
    final extractedFile = File(
      '${tempDir.path}/${path.basenameWithoutExtension(bz2File.path)}',
    );
    await extractedFile.writeAsBytes(archive);

    return extractedFile;
  }

  Future<void> initializeModel(String model, String language) async {
    final documentsDir = await getApplicationDocumentsDirectory();

    final modelDir = Directory(
      '${documentsDir.path}/models/sherpa-onnx-whisper-$model',
    );

    if (!File('${modelDir.path}/$model-tokens.txt').existsSync()) {
      throw Exception('Model not found');
    }

    final whisper = sherpa_onnx.OfflineWhisperModelConfig(
      encoder: '${modelDir.path}/$model-encoder.int8.onnx',
      decoder: '${modelDir.path}/$model-decoder.int8.onnx',
      language: language,
    );

    final modelConfig = sherpa_onnx.OfflineModelConfig(
      whisper: whisper,
      tokens: '${modelDir.path}/$model-tokens.txt',
      modelType: 'whisper',
      debug: false,
      numThreads: 2,
    );
    final config = sherpa_onnx.OfflineRecognizerConfig(model: modelConfig);
    final target = path.join(documentsDir.path, 'silero_vad.onnx');
    sileroVadConfig = sherpa_onnx.SileroVadModelConfig(
      model: target,
      minSpeechDuration: 0.2,
      minSilenceDuration: 0.2,
      threshold: 0.5,
      maxSpeechDuration: 2,
    );

    if (sileroVadConfig != null) {
      vadConfig = sherpa_onnx.VadModelConfig(
        sileroVad: sileroVadConfig!,
        numThreads: 2,
        debug: true,
      );
    }

    _recognizer = sherpa_onnx.OfflineRecognizer(config);

    if (vadConfig != null) {
      _vad = sherpa_onnx.VoiceActivityDetector(
        config: vadConfig!,
        bufferSizeInSeconds: 180,
      );
    }

    _isModelInitialized = true;
  }

  Future<List<ffmpeg_helper.Caption>> generateCaptions(String audioPath) async {
    List<ffmpeg_helper.Caption> captions = [];
    _buffer = sherpa_onnx.CircularBuffer(capacity: 16000 * 180);

    if (_vad != null) {
      _vad!.clear();
      if (vadConfig != null) {
        _vad = sherpa_onnx.VoiceActivityDetector(
          config: vadConfig!,
          bufferSizeInSeconds: 180,
        );
      }
    }

    try {
      final waveData = sherpa_onnx.readWave(audioPath);

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
            _stream = _recognizer?.createStream();
            _stream?.acceptWaveform(
              samples: _vad!.front().samples,
              sampleRate: 16000,
            );
            _recognizer?.decode(_stream!);

            final result = _recognizer?.getResult(_stream!);

            var start =
                _vad != null ? ((_vad!.front().start / 16000) * 1000) : 0;
            var duration =
                _vad != null
                    ? ((_vad!.front().samples.length / 16000) * 1000)
                    : 0;

            captions.add(
              ffmpeg_helper.Caption(
                startTime: Duration(milliseconds: start.toInt()),
                endTime: Duration(milliseconds: (start + duration).toInt()),
                text: "${result?.text.trim()}",
                fontColor: "white",
                fontSize: 24,
                borderWidth: 2,
                borderColor: "black",
                textAlign: "center",
              ),
            );
          } catch (e) {
            print(e);
          }

          await Future.delayed(const Duration(milliseconds: 300));

          _vad!.pop();
        }
      }
    } catch (e) {
      print(e);
    } finally {}

    return captions;
  }
}
