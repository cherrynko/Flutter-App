import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderButton extends StatefulWidget {
  final String uploadUrl;

  VoiceRecorderButton({required this.uploadUrl});

  @override
  _VoiceRecorderButtonState createState() => _VoiceRecorderButtonState();
}

class _VoiceRecorderButtonState extends State<VoiceRecorderButton> {
  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initAudioRecorder();
  }

  Future<void> _initAudioRecorder() async {
    await _audioRecorder.openRecorder();
  }

  Future<void> _startRecording() async {
    try {
      await _audioRecorder.startRecorder(
        toFile: 'voice.webm',
        codec: Codec.pcmWebM,
      );

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      // await _audioRecorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      final recordedFilePath = await _audioRecorder.stopRecorder();
      // final recordedFile = File(recordedFilePath!);
      // await recordedFile
      //     .rename('/Users/cafebazaar/Desktop/SAT/sat_project/voice.webm');
      print(recordedFilePath);

      // Send the recorded file to the server
      // File audioFile = File('voice.webm');
      // var request = http.MultipartRequest('POST', Uri.parse(widget.uploadUrl));
      // request.files.add(http.MultipartFile(
      //   'audio',
      //   audioFile.readAsBytes().asStream(),
      //   audioFile.lengthSync(),
      //   filename: 'voice.webm',
      // ));
      // var response = await request.send();
      // if (response.statusCode == 200) {
      //   print('Recording sent successfully.');
      // } else {
      //   print('Failed to send recording. Status code: ${response.statusCode}');
      // }
      // Get the local documents directory
      // final directory = await getApplicationDocumentsDirectory();
      // final filePath = '${directory.path}/voice.webm';
      final filePath = '/Users/cafebazaar/Desktop/SAT/sat_project/voice.webm';

      // Rename the recorded file and move it to the local directory
      // final audioFile = File(filePath);
      // await audioFile.rename(filePath);

      final audioFile = File(filePath);

// Check if the file exists (optional)
      if (audioFile.existsSync()) {
        // File exists, you can perform operations on it
      } else {
        // File does not exist, you can create it and write data to it if needed
      }

// // To write data to the file (optional)
//       await audioFile.writeAsBytes(yourAudioData);

// // To read data from the file (optional)
//       final fileData = await audioFile.readAsBytes();

      print('Recording saved locally: $filePath');
      print("doneeeeee");
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isRecording) Text('در حال ضبط ...') else Text('صحبت کن'),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'این قابلیت روی اپلیکیشن موبایل اندروید در دسترس می‌باشد. برای استفاده از آن میتوانید درخواست دهید.'),
                duration: Duration(seconds: 2), // Adjust the duration
              ),
            );
            if (_isRecording) {
              _stopRecording();
              print("is reeeeeeee");
            } else {
              _startRecording();
            }
          },
          child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
        ),
      ],
    );
  }
}

