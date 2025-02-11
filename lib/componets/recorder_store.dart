import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../Model/voice_model.dart';
import '../provider/recording_provider.dart';

Consumer<VoiceRecording> recorder_store() {
  return Consumer<VoiceRecording>(
    builder: (context, value, child) {
      List<VoiceModel> recordingList = [];
      recordingList = value.recordings
          .map(
            (e) => VoiceModel.fromMap(e),
          )
          .toList();
      return value.recordings.isEmpty
          ? const Center(
              child: Text("No recordings yet",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: recordingList.length,
              itemBuilder: (context, index) {
                String filePath = recordingList[index].filePath;
                bool isPlaying = filePath == value.isPlaying;
                String title = recordingList[index].title;
                // String date = recordingList[index].date;
                String time = recordingList[index].time;
                String formattedTime = recordingList[index].duration;
                return Slidable(
                  key: ValueKey(recordingList[index].id),
                  startActionPane: ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          autoClose: true,
                          onPressed: (context) {
                            Slidable.of(context)?.close();
                            value.titleController.text = recordingList[index].title;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {

                                return AlertDialog(
                                  title: const Text('Edit Recording Title'),
                                  content: TextField(
                                    controller: value.titleController,
                                    decoration: InputDecoration(labelText: "title"),
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
                                        value.dataEdit(title: value.titleController.text, id: recordingList[index].id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.white,
                          icon: Icons.edit,
                          label: "Edit",
                        ),
                      ],),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        value.dataDelete(id: recordingList[index].id!);
                      },),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Slidable.of(context)?.close();
                          value.dataDelete(id: recordingList[index].id!);
                        },
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Delete",
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white54,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 3,
                            blurStyle: BlurStyle.outer)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.audiotrack, color: Colors.white),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            spacing: 6,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              )
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.stop : Icons.play_arrow,
                                    size: 30,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () =>
                                      value.playRecording(filePath),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                        color: Colors.black26, fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    },
  );
}
