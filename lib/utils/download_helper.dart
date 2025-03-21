import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class DownloadHelper {
  static ValueNotifier<File?> downloadedFile = ValueNotifier(null);
  // Download a file and track progress
  static Future<ValueNotifier<File?>> downloadFile({
    required String url,
    required String savePath,
    required Function(double progress) onProgress,
  }) async {
    final request = http.Request('GET', Uri.parse(url));
    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      final contentLength = streamedResponse.contentLength;
      final file = File(savePath);
      final fileStream = file.openWrite();

      int receivedLength = 0;

      streamedResponse.stream.listen(
        (List<int> chunk) {
          receivedLength += chunk.length;
          if (contentLength != null) {
            final progress = receivedLength / contentLength;
            onProgress(progress);
          }
          fileStream.add(chunk);
        },
        onDone: () async {
          await fileStream.close();
          downloadedFile.value = file;
        },
        onError: (error) {
          fileStream.close();
          throw Exception('Download failed: $error');
        },
        cancelOnError: true,
      );

      return downloadedFile;
    } else {
      throw Exception(
        'Failed to download file: Status code ${streamedResponse.statusCode}',
      );
    }
  }

  // Extract a .bz2 file
  static Future<File> extractBz2({
    required File bz2File,
    required String outputPath,
  }) async {
    print(bz2File.path);
    print(outputPath);
    await extractFileToDisk(bz2File.path, outputPath);
    //     final bytes = await bz2File.readAsBytes();
    //     final archive = BZip2Decoder().decodeBytes(bytes);
    //
    //     final extractedFile = File(outputPath);
    //     await extractedFile.writeAsBytes(archive);

    return bz2File;
  }
}
