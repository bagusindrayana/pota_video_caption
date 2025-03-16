import 'package:flutter/material.dart';
import 'package:pota_video_caption/utils.dart' as utils;

class CaptionTextFont extends StatefulWidget {
  final utils.Caption caption;
  final List<String> fonts;
  final Function onSaved;

  const CaptionTextFont({
    required this.caption,
    required this.fonts,
    required this.onSaved,
    super.key,
  });
  @override
  State<CaptionTextFont> createState() => _CaptionTextFontState();
}

class _CaptionTextFontState extends State<CaptionTextFont> {
  String? _currentFontFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentFontFile =
        widget.caption.fontFile ?? "/system/fonts/Roboto-Regular.ttf";
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns.
      // If you change the scrollDirection to horizontal,
      // this produces 2 rows.
      crossAxisCount: 3,
      // Generate 100 widgets that display their index in the list.
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children:
          widget.fonts
              .map(
                (font) => InkWell(
                  onTap: () {
                    setState(() {
                      _currentFontFile = font;
                      widget.caption.fontFile = font;
                      widget.onSaved.call();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:
                            font == _currentFontFile
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          font
                              .split("/")
                              .last
                              .split(".")
                              .first
                              .replaceAll("-Regular", ""),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: font
                                .split("/")
                                .last
                                .split(".")
                                .first
                                .replaceAll("-Regular", ""),
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: DropdownButton<String>(
    //       value: _currentFontFile,
    //       dropdownColor: Colors.black.withOpacity(0.5),
    //       items:
    //           widget.fonts
    //               .map(
    //                 (font) => DropdownMenuItem(
    //                   value: font,
    //                   child:
    // Text(
    //                     font
    //                         .split("/")
    //                         .last
    //                         .split(".")
    //                         .first
    //                         .replaceAll("-Regular", ""),
    //                     style: TextStyle(
    //                       fontFamily: font
    //                           .split("/")
    //                           .last
    //                           .split(".")
    //                           .first
    //                           .replaceAll("-Regular", ""),
    //                       fontSize: 20.0,
    //                       color: Colors.white,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               )
    //               .toList(),
    //       onChanged: (value) {
    //         setState(() {
    //           _currentFontFile = value;
    //         });
    //         widget.caption.fontFile = value;
    //         widget.onSaved.call();
    //       },
    //     ),
    //   ),
    // );
  }
}
