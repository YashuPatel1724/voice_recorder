import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/provider/recording_provider.dart';
import 'package:voice_recorder/provider/voice_text_provider.dart';
import 'package:voice_recorder/view/screens/Home%20Page/home_page.dart';


void main()
{
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => VoiceRecording(),
    ),
    ChangeNotifierProvider(
      create: (context) => VoiceTextProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecorderScreen(),
    );
  }
}
