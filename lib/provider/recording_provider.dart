import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_recorder/Db%20Helper/db_services.dart';

class VoiceRecording extends ChangeNotifier {
  FlutterSoundRecorder? recorder;
  FlutterSoundPlayer? player;
  bool _isRecording = false;
  String? _isPlaying;
  List _recordings = [];
  String? recordTime;
  String? recordDate;
  int recordDuration = 0;
  Timer? timer;
  TextEditingController titleController = TextEditingController();

  bool get isRecording => _isRecording;

  String? get isPlaying => _isPlaying;

  List get recordings => _recordings;

  VoiceRecording() {
    recorder = FlutterSoundRecorder();
    player = FlutterSoundPlayer();
    initRecording();
  }

  Future<void> loadVoice() async {
    _recordings = await DbServices.dbServices.getDataFromDatabase();
    notifyListeners();
  }

  Future<void> initRecording() async {
    try {
      await recorder!.openRecorder();
      await player!.openPlayer();
      await Permission.microphone.request();
      loadVoice();
    } catch (e) {
      print("Error initializing : $e");
    }
  }

  Future<void> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath =
        '${directory.path}/recording_${DateTime.now().millisecond}';
    try {
      await recorder!.startRecorder(toFile: filePath);
      _isRecording = true;
      startTime();
      notifyListeners();
    } catch (e) {
      print("Error starting: $e");
    }
  }

  Future<void> stopRecording(BuildContext context) async {
    try {
      String? filePath = await recorder!.stopRecorder();
      stopTime();
      if (filePath != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController titleController = TextEditingController();
            return AlertDialog(
              title: const Text('Enter Recording Title'),
              content: TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    String title = titleController.text.isEmpty
                        ? 'Recording'
                        : titleController.text;
                    DateTime now = DateTime.now();
                    recordTime = DateFormat('hh:mm a').format(now);
                    recordDate = DateFormat('dd-MM-yyyy').format(now);
                    String duration =
                        "${(recordDuration ~/ 60).toString().padLeft(2, '0')}:${(recordDuration % 60).toString().padLeft(2, '0')}";
                    await DbServices.dbServices.addDataInDatabase(
                        filePath, title, recordDate!, recordTime!, duration);
                    await loadVoice();
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      }
      _isRecording = false;
      notifyListeners();
    } catch (e) {
      print("Error stopping: $e");
    }
  }

  Future<void> playRecording(String filePath) async {
    if (_isPlaying == filePath) {
      await player!.stopPlayer();
      _isPlaying = null;
    } else {
      if (_isPlaying != null) {
        await player!.stopPlayer();
      }
      _isPlaying = filePath;
      await player!.startPlayer(
        fromURI: filePath,
        whenFinished: () {
          _isPlaying = null;
          notifyListeners();
        },
      );
    }
    notifyListeners();
  }

  void startTime() {
    recordDuration = 0;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        recordDuration++;
        notifyListeners();
      },
    );
  }

  void stopTime() {
    timer?.cancel();
    notifyListeners();
  }

  Future<void> dataDelete({required int id}) async {
    await DbServices.dbServices.deleteDataFromDatabase(id);
    loadVoice();
  }

  Future<void> dataEdit({required String title, required int id}) async {
    await DbServices.dbServices.editDataFromDatabase(title, id);
    loadVoice();
  }
}
