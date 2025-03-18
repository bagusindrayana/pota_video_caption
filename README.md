# Pota Video Caption
Generate caption/subtitle for video using AI locally in your android phone

## How does it work?
- FFmpeg to seperate video and audio
- using VAD (Voice Activity Detector) to detect certain segment audio
- Open Ai Whisper Model to generate caption/subtitle from audio.
- use FFmpeg to merge video and subtitle

## Resources & Refrences
- https://github.com/k2-fsa/sherpa-onnx
- https://github.com/snakers4/silero-vad
- https://github.com/wxkly8888/video_subtitle_editor
- https://github.com/arthenica/ffmpeg-kit

## Setup
- clone this repo
- run `flutter pub get`
- run `flutter run`

## Pre-trained Whisper Models
- all whisper model from https://github.com/k2-fsa/sherpa-onnx/releases/tag/asr-models
- model can directly download from app (tiny, small, turbo)
- but if you want to include model (or copy large version) inside apk build, copy all models file (decoder, encoder, tokens, etc) to `assets` with format `assets/models/sherpa-onnx-whisper-{model_name}/{model_files}`


## Pros
- locally without internet

## Cons
- apk size will be BIG because with bundle ffmpeg (and whisper model if you include it on build)
- depend on device, generation process will take some time
- suitable for short video
- not accurate segmentation timestamp


## Todo
[ ] better segmentation timestamp (to split word by word, probably using some math to count word length)
[ ] add basic video editing (cut, merge, format, etc)



### Support Me!!!
<a href="https://trakteer.id/bagood" target="_blank"
      ><img
        id="wse-buttons-preview"
        src="https://cdn.trakteer.id/images/embed/trbtn-red-1.png?date=18-11-2023"
        height="40"
        style="border: 0px; height: 40px; --darkreader-inline-border-top: 0px; --darkreader-inline-border-right: 0px; --darkreader-inline-border-bottom: 0px; --darkreader-inline-border-left: 0px;"
        alt="Trakteer Saya"
        data-darkreader-inline-border-top=""
        data-darkreader-inline-border-right=""
        data-darkreader-inline-border-bottom=""
        data-darkreader-inline-border-left=""
      /></a>