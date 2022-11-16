import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/app_route.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';
import 'package:spidclass/models/class_model.dart';
import 'package:spidclass/models/member_model.dart';
import 'package:spidclass/pages/class_members/class_members_arguments.dart';
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            StreamBuilder<List<Member>>(
                stream: fetchMembers(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final members = snapshot.data!;
                    print(members.length);
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return buildMemberTile(members[index]);
                      },
                    );
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
              onPressed: () {
                createMember();
                Navigator.pop(context);
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

  Future createMember() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
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
        trial_lesson: DateTime.parse(trial_lessonController.text),
        last_payment: DateTime.parse("2000-02-02"),
        next_payment: DateTime.parse("2000-02-02"),
        attendance: 0,
        attendance_dates: [
          DateTime.parse(trial_lessonController.text),
        ],
        unpayed_lessons: 0,
        other_information: other_informationController.text,
        isAttending: true,
        age: int.parse(ageController.text),
        class_year: class_yearController.text,
      );

      final json = member.toJson();
      await docMember.set(json);

      //create batteries to the battery station
      Utils.showSnackBarWithColor('New Member has been added', Colors.blue);
      Navigator.pop(context);
    }
  }

  Widget buildMemberTile(Member member) => ListTile(
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
                      '${member.first_name}',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.xxLarge,
                        fontWeight: FontWeight.w600,
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
