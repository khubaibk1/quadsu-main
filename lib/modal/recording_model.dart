class RecordingModel{
  List<Recording> recordings=[];

  RecordingModel({this .recordings=const[]});



  factory RecordingModel.fromJson(List<dynamic> json) {
    List<Recording> data = [];
    data = <Recording>[];
    for (var v in json) {
      data.add(Recording.fromJson(v));
    }
    return RecordingModel(recordings: data);
  }
}

class Recording {
  final int sNo;
  final String duration;

  final String fileName;

  Recording({
    required this.sNo,
    required this.duration,
    required this.fileName,
  });

  factory Recording.fromJson(Map json) {
    return Recording(
      sNo: json["srno"] ?? 0,
      duration: json["duration"] ?? "",
      fileName: json["filename"] ?? "",
    );
  }
}
