import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String id;
  String first_name;
  String second_name;
  String mother;
  String father;
  String mother_number;
  String father_number;
  String number;
  DateTime trial_lesson;
  DateTime last_payment;
  DateTime next_payment;
  int attendance;
  List<dynamic> attendance_dates;
  int unpayed_lessons;
  String other_information;
  bool isAttending;
  int age;
  String class_year;

  Member({
    this.id = '',
    required this.first_name,
    required this.second_name,
    required this.mother,
    required this.father,
    required this.mother_number,
    required this.father_number,
    required this.number,
    required this.trial_lesson,
    required this.last_payment,
    required this.next_payment,
    required this.unpayed_lessons,
    required this.attendance,
    required this.attendance_dates,
    required this.other_information,
    required this.isAttending,
    required this.age,
    required this.class_year,

  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'second_name': second_name,
        'mother': mother,
        'father': father,
        'mother_number': mother_number,
        'father_number': father_number,
        'number': number,
        'trial_lesson': trial_lesson,
        'last_payment': last_payment,
        'next_payment': next_payment,
        'attendance': attendance,
        'attendance_dates': attendance_dates,
        'unpayed_lessons': unpayed_lessons,
        'other_information': other_information,
        'isAttending': isAttending,
        'age': age,
        'class_year': class_year,
      };

  static Member fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        first_name: json['first_name'],
        second_name: json['second_name'],
        mother: json['mother'],
        father: json['father'],
        mother_number: json['mother_number'],
        father_number: json['father_number'],
        number: json['number'],
        trial_lesson: (json['trial_lesson'] as Timestamp).toDate(),
        last_payment: (json['last_payment'] as Timestamp).toDate(),
        next_payment: (json['next_payment'] as Timestamp).toDate(),
        attendance: json['attendance'],
        attendance_dates: json['attendance_dates'] as List<dynamic>,
        unpayed_lessons: json['unpayed_lessons'],
        other_information: json['other_information'],
        isAttending: json['isAttending'],
        age: json['age'],
        class_year: json['class_year'],
      );
}
