// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/app.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';
import 'package:spidclass/models/member_model.dart';
import 'package:spidclass/pages/attendance/attendance_arguments.dart';

class AttendancePage extends StatefulWidget {
  final AttendanceArguments arguments;
  const AttendancePage({
    required this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController first_nameController = TextEditingController();
  TextEditingController second_nameController = TextEditingController();
  TextEditingController motherController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController mother_numberController = TextEditingController();
  TextEditingController father_numberController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController trial_lessonController = TextEditingController();
  TextEditingController last_paymentController = TextEditingController();
  TextEditingController attendanceController = TextEditingController();
  TextEditingController other_informationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController class_yearController = TextEditingController();

  final double sizedBoxHight = 16;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    first_nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.arguments.classroom.name} in ${widget.arguments.classroom.place}"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            StreamBuilder<List<Member>>(
                stream: fetchMembers(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final members = snapshot.data!;

                    return buildDataTable(members);
                  } else if (snapshot.hasData) {
                    return const Text('nothing');
                  } else {
                    return (const Text('error'));
                  }
                }))
          ],
        ),
      ),
    );
  }

  Stream<List<Member>> fetchMembers() {
    return FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.arguments.classroom.id)
        .collection('members')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Member.fromJson(doc.data())).toList());
  }

  Widget buildDataTable(List<Member> members) {
    final columns = [
      'Full Name',
      'Attendace',
    ];
    return Expanded(
      child: DataTable(
        
        columns: getColumns(columns),
        columnSpacing: 12,
        rows: getRows(members),
        showCheckboxColumn: false,
      ),
    );
  }

  List<DataRow> getRows(List<Member> members) => members.map((Member member) {
        List<DateTime> attendanceList = [];
        member.attendance_dates.reversed.toList().forEach((element) {
          attendanceList.add((element as Timestamp).toDate());
        });
        final cells = [
          '${member.first_name} ${member.second_name}',
          '${attendanceList.map((e) => "${e.day}.${e.month}.${e.year} ||")}',
        ];
        return DataRow(
          cells: getCells(cells),
          onSelectChanged: (value) {
            FirebaseFirestore.instance
                .collection('classes')
                .doc(widget.arguments.classroom.id)
                .collection('members')
                .doc(member.id)
                .update({
              'attendance_dates':
                  FieldValue.arrayUnion([DateTime.now() as dynamic])
            });
          },
        );
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells.map((data) {
        return DataCell(
          Text(
            data,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: ThemeColors.blackTextColor,
              fontSize: FontSize.small,
              fontWeight: FontWeight.w400,
            ),
          ),
          // onTap: () {
          //   print('asdad');
          // },
        );
      }).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();
}
