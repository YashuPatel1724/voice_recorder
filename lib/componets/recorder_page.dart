import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../constant/color_constant.dart';
import '../provider/recording_provider.dart';
import '../provider/voice_text_provider.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  _RecorderPageState createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {

  @override
  Widget build(BuildContext context) {
    var speechProvider = Provider.of<VoiceTextProvider>(context);
    var speechProviderFalse = Provider.of<VoiceTextProvider>(context, listen: false);
    var recordingProvider = Provider.of<VoiceRecording>(context);
    var recordingProviderFalse = Provider.of<VoiceRecording>(context, listen: false);

    String formattedTime =
        "${(recordingProvider.recordDuration ~/ 60).toString().padLeft(2, '0')}:${(recordingProvider.recordDuration % 60).toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
                color: primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                recordingProvider.isRecording ? formattedTime : "00:00",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (recordingProvider.isRecording)
              Container(
                height: 55,
                width: 250,
                decoration: BoxDecoration(
                  color:primaryColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: AudioWaveforms(
                  enableGesture: false,
                  size: Size(MediaQuery.of(context).size.width * 0.6, 50),
                  recorderController: recordingProvider.waveController,
                  waveStyle: WaveStyle(
                    waveColor: Colors.white,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
              ),
            const SizedBox(height: 100),
            GestureDetector(
              onTap: () async {
                if (recordingProvider.isRecording) {
                  await recordingProvider.waveController.stop();
                  await recordingProviderFalse.stopRecording(context);
                  print("Stopped Recording | Text: ${speechProvider.lastWords}");
                } else {
                  await recordingProvider.waveController.record();
                  await recordingProviderFalse.startRecording();
                  print("Started Recording | Text: ${speechProvider.lastWords}");
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: recordingProvider.isRecording ? Colors.red : primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: recordingProvider.isRecording
                          ? Colors.red
                          : primaryColor.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  recordingProvider.isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tap to Record",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
        
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
