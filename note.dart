// lib/note.dart
class Note {
  int? id;
  String? title;
  String? description;

  Note({this.id, this.title, this.description});

  Note.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['description'] = this.description;
    return map;
  }
}
