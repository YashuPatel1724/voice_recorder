import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/Model/voice_model.dart';

import '../../../constant/color_constant.dart';
import '../../../provider/recording_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<VoiceRecording>(context);
    List<VoiceModel> recordingList =
    provider.recordings.map((e) => VoiceModel.fromMap(e)).toList();
    String filePath = recordingList[provider.currentIndex].filePath;
    bool isPlaying = filePath == provider.isPlaying;
    var selectedRecording = recordingList[provider.currentIndex];
    double sliderValue = provider.position.inSeconds.toDouble();
    double maxDuration = provider.duration.inSeconds.toDouble();
    return WillPopScope(
      onWillPop: () async {
        await provider.audioPlayer.stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor :primaryColor,
          title: Text("Audio Player",style: TextStyle(color: Colors.white),),
          leading: InkWell(
              onTap: () async {
                await provider.audioPlayer.stop();
                // provider.resetPlayback();
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,color: Colors.white,)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/image/Screenshot_2025-02-20_094404-removebg-preview.png",
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Image.asset(
                  "assets/image/Screenshot_2025-02-20_095131-removebg-preview.png",
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  selectedRecording.title,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedRecording.date,
                  style: TextStyle(color: Colors.black26, fontSize: 17),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: provider.currentIndex > 0
                          ? () {
                        provider.previousPlay();
                      }
                          : null,
                      icon: Icon(Icons.skip_previous,
                          size: 50,
                          color: provider.currentIndex > 0
                              ? Colors.black
                              : Colors.grey),
                    ),
                    InkWell(
                      onTap: () {
                        provider.playRecording(filePath);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Color(0xff69308F),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          provider.isPlaying == filePath && provider.audioPlayer.playing
                              ? Icons.stop
                              : Icons.play_arrow_rounded,  // Switch icon when playback stops
                          size: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:
                      provider.currentIndex < recordingList.length - 1
                          ? () {
                        provider.nextPlay();
                      }
                          : null,
                      icon: Icon(Icons.skip_next,
                          size: 50,
                          color:
                          provider.currentIndex < recordingList.length - 1
                              ? Colors.black
                              : Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Slider(
                  activeColor: primaryColor,
                  min: 0,
                  max: maxDuration > 0 ? maxDuration : 1,
                  value: sliderValue.clamp(0, maxDuration),
                  onChanged: (value) {
                    provider.seekAudio(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(provider.formatDuration(provider.position)),
                      Text(provider.formatDuration(provider.duration)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
