class VoiceModel {
  final int? id;
  final String filePath;
  final String title;
  final String date;
  final String time;
  final String duration;

  VoiceModel(
      {this.id,
      required this.filePath,
      required this.title,
      required this.date,
      required this.time,
      required this.duration});

  factory VoiceModel.fromMap(Map<String, dynamic> map) {
    return VoiceModel(
        id: map['id'],
        filePath: map['filePath'],
        title: map['title'],
        date: map['date'],
        time: map['time'],
        duration: map['duration']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'title': title,
      'date': date,
      'time': time,
      'duration': duration
    };
  }
}
