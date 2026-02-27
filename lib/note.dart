import 'dart:convert';

class Note {
  String id;
  String title;
  String content;
  DateTime dateTime;
  List<String> images;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    this.images = const [],
  });

  // Chuyển đối tượng Note thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
      'images': images,
    };
  }

  // Tạo đối tượng Note từ Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
      images: map['images'] != null ? List<String>.from(map['images']) : [],
    );
  }

  // Mã hóa thành chuỗi JSON
  String toJson() => json.encode(toMap());

  // Giải mã từ chuỗi JSON
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}