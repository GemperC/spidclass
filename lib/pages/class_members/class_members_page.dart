// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/app_route.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';
import 'package:spidclass/models/class_model.dart';
import 'package:spidclass/models/member_model.dart';
import 'package:spidclass/pages/class_members/class_members_arguments.dart';
import 'package:spidclass/pages/class_members/updateMemberDialog.dart';
import 'package:spidclass/pages/classroom/classroom_arguments.dart';
import 'package:spidclass/widgets/main_button_3.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:spidclass/widgets/utils.dart';

class ClassMembersPage extends StatefulWidget {
  final ClassMembersArguments arguments;
  const ClassMembersPage({
    required this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  State<ClassMembersPage> createState() => _ClassMembersPageState();
}

class _ClassMembersPageState extends State<ClassMembersPage> {
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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  addMemberDialog();
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
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
    final columns = ['Full Name', 'Class', 'Father', 'Mother', 'Other Info'];
    return DataTable(
      columns: getColumns(columns),
      columnSpacing: 12,
      rows: getRows(members),
      showCheckboxColumn: false,
    );
  }

  List<DataRow> getRows(List<Member> members) => members.map((Member member) {
        final cells = [
          '${member.first_name} ${member.second_name}',
          member.class_year,
          member.father,
          member.mother,
          member.other_information,
        ];
        return DataRow(
          cells: getCells(cells),
          onSelectChanged: (value) {
            showNumbersDialog(member);
          },
          onLongPress: () {
            updateMemberDialog(member);
          },
        );
      }).toList();

  Future updateMemberDialog(Member member) {
    final docMember = FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.arguments.classroom.id)
        .collection('members')
        .doc(member.id);

    first_nameController.text = member.first_name;
    second_nameController.text = member.second_name;
    motherController.text = member.mother;
    fatherController.text = member.father;
    mother_numberController.text = member.mother_number;
    father_numberController.text = member.father_number;
    numberController.text = member.number;
    attendanceController.text = "${member.attendance}";
    other_informationController.text = member.other_information;
    ageController.text = "${member.age}";
    class_yearController.text = member.class_year;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Update Details",
          style: GoogleFonts.poppins(
            color: ThemeColors.blackTextColor,
            fontSize: FontSize.large,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: 300,
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  MemberTextFromField(first_nameController, 'First Name'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(second_nameController, 'Second Name'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(ageController, 'Age'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(class_yearController, 'Class Year'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(motherController, 'Mother'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(fatherController, 'Father'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(mother_numberController, 'Mother Number'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(father_numberController, 'Father Number'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(numberController, 'Number'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(
                      other_informationController, 'Other Info'),
                ],
              )),
        ),
        actions: [
          TextButton(
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('Remove this member?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('No')),
                          TextButton(
                              onPressed: () {
                                docMember.delete();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Yes Delete',
                                  style: TextStyle(color: Colors.red))),
                        ]),
                  ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                first_nameController.clear();
                second_nameController.clear();
                motherController.clear();
                fatherController.clear();
                mother_numberController.clear();
                father_numberController.clear();
                numberController.clear();
                trial_lessonController.clear();
                last_paymentController.clear();
                attendanceController.clear();
                other_informationController.clear();
                ageController.clear();
                class_yearController.clear();
              },
              child: Text('Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 104, 104, 104)))),
          TextButton(
              onPressed: () {
                docMember.update({
                  'first_name': first_nameController.text,
                  'second_name': second_nameController.text,
                  'mother': motherController.text,
                  'father': fatherController.text,
                  'mother_number': mother_numberController.text,
                  'father_number': father_numberController.text,
                  'number': numberController.text,
                  // 'attendance': 0,
                  'other_information': other_informationController.text,
                  'age': int.parse(ageController.text),
                  'class_year': class_yearController.text,
                });

                first_nameController.clear();
                second_nameController.clear();
                motherController.clear();
                fatherController.clear();
                mother_numberController.clear();
                father_numberController.clear();
                numberController.clear();
                trial_lessonController.clear();
                last_paymentController.clear();
                attendanceController.clear();
                other_informationController.clear();
                ageController.clear();
                class_yearController.clear();
                Navigator.pop(context);
              },
              child: Text('Update Info')),
        ],
      ),
    );
  }

  Future showNumbersDialog(Member member) {
    final List<String> numberList = <String>[
      member.number,
      member.father_number,
      member.mother_number
    ];
    String dropdownvalue = member.number;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          '${member.first_name} ${member.second_name} Numbers:',
          style: GoogleFonts.poppins(
            color: ThemeColors.blackTextColor,
            fontSize: FontSize.large,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          // width: 300,
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  copyNumber(member.number, '${member.first_name}\'s number'),
                  copyNumber(member.father_number, member.father),
                  copyNumber(member.mother_number, member.mother)
                ],
              )),
        ),
      ),
    );
  }

  Widget copyNumber(String number, String howsNumber) {
    if (howsNumber == "-") {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              color: ThemeColors.blackTextColor,
              fontSize: FontSize.medium,
              fontWeight: FontWeight.w400,
            ),
            text: "$howsNumber:    ",
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (number != "-") {
                      Clipboard.setData(ClipboardData(text: number))
                          .then((value) {
                        Utils.showSnackBarWithColor(
                            'The Number has been copied', Colors.blue);
                      });
                      Navigator.pop(context);
                    }
                  },
                text: number,
                style: GoogleFonts.poppins(
                  color: ThemeColors.primaryColor,
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataCell> getCells(List<dynamic> cells) => cells.map((data) {
        return DataCell(
          Text(
            '$data',
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

  Future addMemberDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Add New Member",
          style: GoogleFonts.poppins(
            color: ThemeColors.blackTextColor,
            fontSize: FontSize.large,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: 300,
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  MemberTextFromField(first_nameController, 'First Name'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(second_nameController, 'Second Name'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(ageController, 'Age'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(class_yearController, 'Class Year'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(motherController, 'Mother'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(fatherController, 'Father'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(mother_numberController, 'Mother Number'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(father_numberController, 'Father Number'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(numberController, 'Number'),
                  SizedBox(height: sizedBoxHight),
                  MemberDateFromField(trial_lessonController, 'Trial Lesson'),
                  SizedBox(height: sizedBoxHight),
                  MemberDateFromField(last_paymentController, 'Last Payment'),
                  SizedBox(height: sizedBoxHight),
                  MemberTextFromField(
                      other_informationController, 'Other Info'),
                ],
              )),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () async {
                if (await createMember()) {
                  first_nameController.clear();
                  second_nameController.clear();
                  motherController.clear();
                  fatherController.clear();
                  mother_numberController.clear();
                  father_numberController.clear();
                  numberController.clear();
                  trial_lessonController.clear();
                  last_paymentController.clear();
                  attendanceController.clear();
                  other_informationController.clear();
                  ageController.clear();
                  class_yearController.clear();
                }
              },
              child: Text('Add Member')),
        ],
      ),
    );
  }

  Widget MemberTextFromField(
          TextEditingController controller, String labelText) =>
      TextFormField(
        controller: controller,
        validator: (value) {
          if (controller.text.isEmpty) {
            return "This field can't be empty";
          }
        },
        style: GoogleFonts.poppins(
          color: ThemeColors.blackTextColor,
        ),
        keyboardType: TextInputType.name,
        cursorColor: ThemeColors.primaryColor,
        decoration: InputDecoration(
          // fillColor: ThemeColors.textFieldBgColor,
          // filled: true,
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            // color: ThemeColors.textFieldHintColor,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w500,
          ),
          // border: OutlineInputBorder(
          //   borderSide: BorderSide.none,
          //   borderRadius: BorderRadius.all(Radius.circular(18)),
          // ),
        ),
      );

  Widget MemberDateFromField(
          TextEditingController controller, String labelText) =>
      DateTimeField(
        format: DateFormat('yyyy-MM-dd'),
        controller: controller,
        onShowPicker: ((context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        }),
        validator: (value) {
          if (controller.text.isEmpty) return "This field can't be empty";
        },
        style: GoogleFonts.poppins(
          color: ThemeColors.blackTextColor,
        ),
        keyboardType: TextInputType.name,
        cursorColor: ThemeColors.primaryColor,
        decoration: InputDecoration(
          // fillColor: ThemeColors.textFieldBgColor,
          // filled: true,
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            // color: ThemeColors.textFieldHintColor,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w500,
          ),
          // border: OutlineInputBorder(
          //   borderSide: BorderSide.none,
          //   borderRadius: BorderRadius.all(Radius.circular(18)),
          // ),
        ),
      );

  Future<bool> createMember() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return Future.value(false);
    } else {
      final docMember = FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.arguments.classroom.id)
          .collection('members')
          .doc();
      final member = Member(
        id: docMember.id,
        first_name: first_nameController.text,
        second_name: second_nameController.text,
        mother: motherController.text,
        father: fatherController.text,
        mother_number: mother_numberController.text,
        father_number: father_numberController.text,
        number: numberController.text,
        attendance: 0,
        attendance_dates: [
          DateTime.parse(trial_lessonController.text),
        ],
        other_information: other_informationController.text,
        isAttending: true,
        age: int.parse(ageController.text),
        class_year: class_yearController.text,
      );

      final json = member.toJson();
      await docMember.set(json);

      Utils.showSnackBarWithColor('New Member has been added', Colors.blue);
      Navigator.pop(context);
      return Future.value(true);
    }
  }
}
