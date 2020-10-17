// To parse this JSON data, do
//
//     final story = storyFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  List<Story> stories;
  final DocumentReference reference;

  // ToDo: document need to observe the stories to upload firebase
  Document.fromSnapshot(DocumentSnapshot snapshot)
      : stories = List<Story>.from(
            snapshot.data()['stories'].map((s) => Story.fromMap(s))),
        reference = snapshot.reference;

  Map<String, dynamic> toJson() =>
      {'stories': List.from(stories.map((s) => s.toJson()))};

  void updateRemote() {
    reference.update(toJson());
  }
}

class Story {
  String title;
  List<String> toDo;
  List<String> inProgress;
  List<String> done;

  Story.fromMap(Map<String, dynamic> map)
      : title = map["title"],
        toDo = initList(map, "to_do"),
        inProgress = initList(map, "in_progress"),
        done = initList(map, "done");

  static List<String> initList(Map<String, dynamic> json, String label) {
    var list = List<String>.from(json[label]);
    return list == null ? List() : list;
  }

  Story.empty(String name)
      : title = name,
        toDo = List(),
        inProgress = List(),
        done = List();

  Map<String, List<String>> get map {
    return {
      "to_do": toDo,
      "in_progress": inProgress,
      "done": done,
    };
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "to_do": List<String>.from(toDo.map((x) => x)),
        "in_progress": List<String>.from(inProgress.map((x) => x)),
        "done": List<String>.from(done.map((x) => x)),
      };

  int totalNumberOfTask() {
    return map.values
        .map((e) => e.length)
        .reduce((value, element) => value + element);
  }
}
