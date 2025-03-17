import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pota_video_caption/models/video_project/video_project.dart';
import 'package:pota_video_caption/pages/caption_editor_page.dart';
import 'package:pota_video_caption/pages/home_page.dart';
import 'package:pota_video_caption/utils/isar_service.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  final isarService = IsarService();
  await isarService.initialize(); // Initialize Isar
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
      home: LoaderOverlay(child: HomePage()),
    );
  }
}
