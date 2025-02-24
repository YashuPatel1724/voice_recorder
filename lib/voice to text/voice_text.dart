import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/provider/voice_text_provider.dart';

class VoiceText extends StatefulWidget {
  const VoiceText({super.key});

  @override
  State<VoiceText> createState() => _VoiceTextState();
}

class _VoiceTextState extends State<VoiceText> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<VoiceTextProvider>(context);
    var providerFalse = Provider.of<VoiceTextProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice To Text"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.lastWords),
            SizedBox(
              height: 200,
            ),
            GestureDetector(
              onTap: () {
                provider.speechToText.isNotListening
                    ? providerFalse.startListening()
                    : providerFalse.stopListening();

              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: provider.speechToText.isNotListening
                      ? Colors.red
                      : Color(0xff69308F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  provider.speechToText.isNotListening
                      ? Icons.mic_off
                      : Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
