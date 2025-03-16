import 'package:flutter/material.dart';

class GenerateCaptionSetting extends StatefulWidget {
  final Function(String language, String model) onSubmit;
  const GenerateCaptionSetting({super.key, required this.onSubmit});

  @override
  State<GenerateCaptionSetting> createState() => _GenerateCaptionSettingState();
}

class _GenerateCaptionSettingState extends State<GenerateCaptionSetting> {
  List<Map<String, String>> languages = [
    {"name": "Afrikaans", "code": "af"},
    {"name": "Arabic", "code": "ar"},
    {"name": "Armenian", "code": "hy"},
    {"name": "Azerbaijani", "code": "az"},
    {"name": "Belarusian", "code": "be"},
    {"name": "Bosnian", "code": "bs"},
    {"name": "Bulgarian", "code": "bg"},
    {"name": "Catalan", "code": "ca"},
    {"name": "Chinese", "code": "zh"},
    {"name": "Croatian", "code": "hr"},
    {"name": "Czech", "code": "cs"},
    {"name": "Danish", "code": "da"},
    {"name": "Dutch", "code": "nl"},
    {"name": "English", "code": "en"},
    {"name": "Estonian", "code": "et"},
    {"name": "Finnish", "code": "fi"},
    {"name": "French", "code": "fr"},
    {"name": "Galician", "code": "gl"},
    {"name": "German", "code": "de"},
    {"name": "Greek", "code": "el"},
    {"name": "Hebrew", "code": "he"},
    {"name": "Hindi", "code": "hi"},
    {"name": "Hungarian", "code": "hu"},
    {"name": "Icelandic", "code": "is"},
    {"name": "Indonesian", "code": "id"},
    {"name": "Italian", "code": "it"},
    {"name": "Japanese", "code": "ja"},
    {"name": "Kannada", "code": "kn"},
    {"name": "Kazakh", "code": "kk"},
    {"name": "Korean", "code": "ko"},
    {"name": "Latvian", "code": "lv"},
    {"name": "Lithuanian", "code": "lt"},
    {"name": "Macedonian", "code": "mk"},
    {"name": "Malay", "code": "ms"},
    {"name": "Marathi", "code": "mr"},
    {"name": "Maori", "code": "mi"},
    {"name": "Nepali", "code": "ne"},
    {"name": "Norwegian", "code": "no"},
    {"name": "Persian", "code": "fa"},
    {"name": "Polish", "code": "pl"},
    {"name": "Portuguese", "code": "pt"},
    {"name": "Romanian", "code": "ro"},
    {"name": "Russian", "code": "ru"},
    {"name": "Serbian", "code": "sr"},
    {"name": "Slovak", "code": "sk"},
    {"name": "Slovenian", "code": "sl"},
    {"name": "Spanish", "code": "es"},
    {"name": "Swahili", "code": "sw"},
    {"name": "Swedish", "code": "sv"},
    {"name": "Tagalog", "code": "tl"},
    {"name": "Tamil", "code": "ta"},
    {"name": "Thai", "code": "th"},
    {"name": "Turkish", "code": "tr"},
    {"name": "Ukrainian", "code": "uk"},
    {"name": "Urdu", "code": "ur"},
    {"name": "Vietnamese", "code": "vi"},
    {"name": "Welsh", "code": "cy"},
  ];

  String? _selectedLanguage = 'en';

  List<String> _models = ['tiny', 'small', 'medium'];
  String? _selectedModel = 'tiny';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate Caption'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Language'),
            DropdownButton<String>(
              value: _selectedLanguage,
              items:
                  languages.map((Map<String, String> value) {
                    return DropdownMenuItem<String>(
                      value: value['code'],
                      child: Text("${value['name']}"),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
            ),
            SizedBox(height: 16),
            const Text('Model'),
            DropdownButton<String>(
              value: _selectedModel,
              items:
                  _models.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedModel = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
            widget.onSubmit(
              _selectedLanguage ?? "en",
              _selectedModel ?? "tiny",
            );
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
