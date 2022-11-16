import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  String id;
  String name;
  String place;

  Class({
    this.id = '',
    required this.name,
    required this.place,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'place': place,
      };

  static Class fromJson(Map<String, dynamic> json) => Class(
        id: json['id'],
        name: json['name'],
        place: json['place'],
      );
}
