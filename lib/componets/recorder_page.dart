import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/recording_provider.dart';

Consumer<VoiceRecording> recorderPage() {
  return Consumer<VoiceRecording>(
    builder: (context, value, child) {
      String formattedTime = "${(value.recordDuration ~/ 60).toString().padLeft(2, '0')}:${(value.recordDuration % 60).toString().padLeft(2, '0')}";
      return Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:  Color(0xff69308F).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.outer
                      ),
                    ],
                  color:  Color(0xff69308F),
                ),
                alignment: Alignment.center,
                child: Text(
                  value.isRecording ? formattedTime : "00:00",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 100,),
              GestureDetector(
                onTap: value.isRecording
                    ? () => value.stopRecording(context)
                    : () => value.startRecording(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: value.isRecording
                        ? Colors.red
                        :  Color(0xff69308F),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: value.isRecording
                            ? Colors.red
                            :  Color(0xff69308F).withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    value.isRecording ? Icons.stop : Icons.mic,
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
                    color: Colors.black54),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}