import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  String id;
  String name;
  String place;
  int lesson_time;

  Class({
    this.id = '',
    required this.name,
    required this.place,
    required this.lesson_time,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'place': place,
        'lesson_time': lesson_time,
      };

  static Class fromJson(Map<String, dynamic> json) => Class(
        id: json['id'],
        name: json['name'],
        place: json['place'],
        lesson_time: json['lesson_time'],
      );
}
