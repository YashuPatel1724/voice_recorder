import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceTextProvider extends ChangeNotifier {
  SpeechToText speechToText = SpeechToText();
  bool speechEnable = false;

  String lastWords = "";
  String text = '';

  VoiceTextProvider() {
    initSpeech();
  }

  Future<void> initSpeech() async {
    speechEnable = await speechToText.initialize(
      onStatus: (status) => print("Speech Status: $status"),
      onError: (errorNotification) => print("Speech Error: $errorNotification"),
    );

    notifyListeners();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    notifyListeners();
    print("lastWords --------> $lastWords");
    text = lastWords;
    print("TextWords--------> $text");
    notifyListeners();
  }

  Future<void> startListening() async {
    await speechToText.listen(
      onResult: onSpeechResult,
    );
    notifyListeners();
    print("Started Listening");
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    print("Stop LastWords======> $lastWords");
    print("Stopped Listening");
    notifyListeners();
  }
}
