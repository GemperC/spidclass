import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/app_route.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';
import 'package:spidclass/models/class_model.dart';
import 'package:spidclass/pages/attendance/attendance_arguments.dart';
import 'package:spidclass/pages/class_members/class_members_arguments.dart';
import 'package:spidclass/pages/classroom/classroom_arguments.dart';
import 'package:spidclass/widgets/main_button_3.dart';

class ClassroomPage extends StatefulWidget {
  final ClassroomArguments arguments;
  const ClassroomPage({
    required this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.arguments.classroom.name} in ${widget.arguments.classroom.place}"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 50),
            MainButton3(
              onPressed: () {
                final args = ClassMembersArguments(
                    classroom: widget.arguments.classroom);
                Navigator.pushNamed(context, AppRoute.classMembers,
                    arguments: args);
              },
              text: 'Members Information',
            ),
            SizedBox(height: 50),
            MainButton3(
              onPressed: () {
                final args = AttendanceArguments(
                    classroom: widget.arguments.classroom);
                Navigator.pushNamed(context, AppRoute.attendance,
                    arguments: args);
              },
              text: 'Attendance',
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<Class>> fetchClasses() {
    return FirebaseFirestore.instance.collection('classes').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Class.fromJson(doc.data())).toList());
  }

  Widget buildClassTile(Class _class) => ListTile(
      // go to the class page
      onTap: () {},
      // build the tile info and design
      title: Center(
        child: Padding(
          // padding betwwent he cards
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 65, 61, 82),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              // padding of the text in the cards
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: Column(
                children: [
                  Align(
                    //alingemt of the titel
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Class: ${_class.name}',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.xxLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    //alingemt of the titel
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Place: ${_class.place}',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.textFieldHintColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}
