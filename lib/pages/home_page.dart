import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pota_video_caption/models/video_project/video_project.dart';
import 'package:pota_video_caption/pages/caption_editor_page.dart';
import 'package:pota_video_caption/utils/isar_service.dart';
import 'package:isar/isar.dart';
import 'package:pota_video_caption/widgets/bottom_sheet_with_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final IsarService isarService = IsarService();
  List<VideoProject> videos = [];
  VideoProject? _selectedVideo;
  TextEditingController _titleController = TextEditingController();

  final BottomSheetController _sheetController = BottomSheetController();
  double sheetHeight = 200;

  bool fitlerExported = false;
  List<VideoProject> listVideo = [];

  Future<void> getData() async {
    final isar = isarService.isar;
    videos = await isar.videoProjects.where().sortByCreatedAtDesc().findAll();
    listVideo = videos;
    setState(() {});
  }

  void filterVideos() {
    setState(() {
      listVideo =
          videos.where((v) {
            return v.exported == true || fitlerExported == false;
          }).toList();
    });
  }

  Future<void> deleteData(VideoProject video) async {
    final isar = isarService.isar;
    String? videoPath = video.videoPath;
    await isar.writeTxn(() async {
      await isar.videoProjects.delete(video.id);
    });
    if (videoPath != null) {
      if (await File(videoPath).exists()) {
        await File(videoPath).delete();
      }
    }
    await getData();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete project ${video.title}')));
      setState(() {
        _selectedVideo = null;
        _sheetController.hide();
      });
    }
  }

  void selectVideo(VideoProject video) {
    setState(() {
      _selectedVideo = video;
    });
    _titleController.text = video.title ?? "";
    _sheetController.show();
  }

  Future<void> _updateData() async {
    var isar = isarService.isar;

    await isar.writeTxn(() async {
      await isar.videoProjects.put(_selectedVideo!); // insert & update
    });
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
                _selectedVideo!.title = _titleController.text;
                _updateData();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pota Video Caption',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _sheetController.hide();
                },
                child: Column(
                  children: [
                    // New Project button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildNewProjectButton(),
                    ),
                    const SizedBox(height: 24),
                    // Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildTabs(),
                    ),
                    const SizedBox(height: 16),
                    // Video drafts
                    Expanded(child: _buildVideoDrafts()),
                  ],
                ),
              ),
            ),
            BottomSheetWithController(
              controller: _sheetController,
              sheetHeight: sheetHeight,
              // Optional: hide the floating button if you only want to control it programmatically
              // showButton: false,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoaderOverlay(
                                      child: CaptionEditorPage(
                                        videoProject: _selectedVideo,
                                      ),
                                    ),
                              ),
                            ).then((v) {
                              getData();
                            });
                          },
                          leading: Icon(Icons.movie_edit, size: 32),
                          title: Text("Edit", style: TextStyle(fontSize: 18)),
                        ),

                        ListTile(
                          onTap: () {
                            _showEditTitleDialog();
                          },
                          leading: Icon(Icons.edit_square, size: 32),
                          title: Text("Rename", style: TextStyle(fontSize: 18)),
                        ),
                        ListTile(
                          onTap: () {
                            deleteData(_selectedVideo!);
                          },
                          leading: Icon(Icons.delete_sweep_sharp, size: 32),
                          title: Text("Delete", style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProjectButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CaptionEditorPage()),
          ).then((v) async {
            await getData();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text(
          'New Project',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Drafts and Exported tabs
        Row(
          children: [
            _buildTab('Drafts', !fitlerExported, videos.length, () {
              fitlerExported = false;
              setState(() {});
              filterVideos();
            }),
            const SizedBox(width: 24),
            _buildTab(
              'Exported',
              fitlerExported,
              videos.where((v) {
                return v.exported == true;
              }).length,
              () {
                fitlerExported = true;
                setState(() {});
                filterVideos();
              },
            ),
          ],
        ),
        // View options
        // Row(
        //   children: [
        //     const Icon(Icons.view_list, size: 22),
        //     const SizedBox(width: 16),
        //     const Icon(Icons.edit_note, size: 22),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildTab(String title, bool isActive, int count, Function onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
      ],
    );
  }

  //second to format 00:00
  String formatDuration(int duration) {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:$seconds';
  }

  Widget _buildVideoDrafts() {
    return LayoutBuilder(
      builder:
          (context, constraints) => RefreshIndicator(
            onRefresh: () async {
              await getData();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listVideo.length,
                  itemBuilder: (context, index) {
                    final video = listVideo[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CaptionEditorPage(videoProject: video),
                          ),
                        ).then((v) {
                          getData();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Video thumbnail
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    color: Colors.grey.shade800,
                                    child:
                                        video.thumbnail != null
                                            ? Image.file(
                                              File(video.thumbnail!),
                                              fit: BoxFit.cover,
                                            )
                                            : Center(
                                              child: Icon(
                                                Icons.movie,
                                                size: 48,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "${formatDuration(video.duration ?? 0)}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () {
                                    selectVideo(video);
                                  },
                                  icon: const Icon(Icons.more_vert, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Video info
                          Text(
                            "${video.title}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${video.createdAt}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }
}
