import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_recorder/Db%20Helper/db_services.dart';

class VoiceRecording extends ChangeNotifier {
  FlutterSoundRecorder? recorder;
  final AudioPlayer audioPlayer = AudioPlayer();

  bool _isRecording = false;
  String? _isPlaying;
  bool? playing;
  List _recordings = [];
  String? recordTime;
  String? recordDate;
  int recordDuration = 0;
  Timer? timer;
  TextEditingController titleController = TextEditingController();
  int currentIndex = 0;
  final RecorderController waveController = RecorderController();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool get isRecording => _isRecording;
  String? get isPlaying => _isPlaying;
  List get recordings => _recordings;

  VoiceRecording() {
    recorder = FlutterSoundRecorder();
    initRecording();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer.durationStream.listen((dur) {
      duration = dur ?? Duration.zero;
      notifyListeners();
    });

    audioPlayer.positionStream.listen((pos) {
      position = pos;
      notifyListeners();
    });

    audioPlayer.playerStateStream.listen((state) {
      playing = state.playing;
      notifyListeners();
    });
  }

  Future<void> loadVoice() async {
    _recordings = await DbServices.dbServices.getDataFromDatabase();
    notifyListeners();
  }


  Future<void> initRecording() async {
    try {
      await recorder!.openRecorder();
      await Permission.microphone.request();
      loadVoice();
    } catch (e) {
      print("Error initializing: $e");
    }
  }

  Future<void> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    try {
      await recorder!.startRecorder(toFile: filePath);
      _isRecording = true;
      startTime();
      notifyListeners();
    } catch (e) {
      print("Error starting recording: $e");
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    String title = titleController.text.isEmpty ? 'Recording' : titleController.text;
                    DateTime now = DateTime.now();
                    recordTime = DateFormat('hh:mm a').format(now);
                    recordDate = DateFormat('dd-MM-yyyy').format(now);
                    String duration = "${(recordDuration ~/ 60).toString().padLeft(2, '0')}:${(recordDuration % 60).toString().padLeft(2, '0')}";
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
      print("Error stopping recording: $e");
    }
  }


  Future<void> playRecording(String filePath) async {
    if (_isPlaying == filePath) {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } else {
      if (_isPlaying != null) {
        await audioPlayer.stop();
      }
      if (File(filePath).existsSync()) {
        _isPlaying = filePath;
        notifyListeners();

        await audioPlayer.setFilePath(filePath);
        await audioPlayer.play();


        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = null;
            notifyListeners();
          }
        });
      }
    }
    notifyListeners();
  }



  Future<void> seekAudio(double value) async {
    await audioPlayer.seek(Duration(seconds: value.toInt()));
    if (!audioPlayer.playing) {
      await audioPlayer.play();
    }
    notifyListeners();
  }

  void nextPlay() {
    if (currentIndex < _recordings.length) {
      currentIndex++;
      playRecording(_recordings[currentIndex]['filePath']);
    }
    notifyListeners();
  }

  void previousPlay() {
    if (currentIndex > 0) {
      currentIndex--;
      playRecording(_recordings[currentIndex]['filePath']);
    }
    notifyListeners();
  }

  void selectedAudio(int index) {
    currentIndex = index;
    playRecording(_recordings[currentIndex]['filePath']);
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
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

}
