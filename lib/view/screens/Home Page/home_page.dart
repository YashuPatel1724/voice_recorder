import 'package:flutter/material.dart';

import '../../../componets/recorder_page.dart';
import '../../../componets/recorder_store.dart';

class RecorderScreen extends StatelessWidget {
  const RecorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Voice Recorder',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            centerTitle: true,
            bottom: TabBar(
                unselectedLabelColor: Colors.white60,
                labelColor: Colors.white,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                indicatorColor: Colors.white,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    child: Text(
                      "Recorder",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Recording",
                    ),
                  )
                ]),
          ),
          body: TabBarView(physics: BouncingScrollPhysics(), children: [
            recorderPage(),
            recorder_store()
          ])),
    );
  }



}
