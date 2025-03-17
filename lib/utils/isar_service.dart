import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pota_video_caption/models/video_project/video_project.dart';
// Import your model

class IsarService {
  static final IsarService _instance = IsarService._internal();
  late Isar isar;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [VideoProjectSchema], // Add your schema here
      directory: dir.path,
    );
  }
}
