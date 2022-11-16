import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/app.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';
import 'package:spidclass/models/class_model.dart';
import 'package:spidclass/pages/classroom/classroom_arguments.dart';
import 'package:spidclass/widgets/utils.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classPlaceController = TextEditingController();
  final TextEditingController classLessonTimeController =
      TextEditingController();
  final double sizedBoxHight = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Classes",
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xxLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  addClassDialog();
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<List<Class>>(
              stream: fetchClasses(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final classes = snapshot.data!;
                  print(classes.length);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      return buildClassTile(classes[index]);
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
    );
  }

  Stream<List<Class>> fetchClasses() {
    return FirebaseFirestore.instance.collection('classes').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Class.fromJson(doc.data())).toList());
  }

  Future addClassDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Add New Class",
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
                  TextFormField(
                    controller: classNameController,
                    validator: (value) {
                      if (classNameController.text.isEmpty)
                        return "This field can't be empty";
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.blackTextColor,
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      // fillColor: ThemeColors.textFieldBgColor,
                      // filled: true,
                      labelText: "Class Name",
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
                  ),
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: classPlaceController,
                    validator: (value) {
                      if (classPlaceController.text.isEmpty)
                        return "This field can't be empty";
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.blackTextColor,
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      // fillColor: ThemeColors.textFieldBgColor,
                      // filled: true,
                      labelText: "Place",
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
                  ),
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: classLessonTimeController,
                    validator: (value) {
                      if (classLessonTimeController.text.isEmpty)
                        return "This field can't be empty";
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.blackTextColor,
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      // fillColor: ThemeColors.textFieldBgColor,
                      // filled: true,
                      labelText: "Lesson Time in minutes",
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
                  ),
                  
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
                createClass();
                Navigator.pop(context);
              },
              child: Text('Add Class')),
        ],
      ),
    );
  }

  Future createClass() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      //create battery station
      final docClass = FirebaseFirestore.instance.collection('classes').doc();
      final _class = Class(
        name: classNameController.text,
        id: docClass.id,
        place: classPlaceController.text,
        lesson_time: int.parse(classLessonTimeController.text),
      );

      final json = _class.toJson();
      await docClass.set(json);

      //create batteries to the battery station
      Utils.showSnackBarWithColor('New class has been created', Colors.blue);
      
      Navigator.pop(context);
    }
  }

  Widget buildClassTile(Class _class) => ListTile(
      // go to the class page
      onTap: () {
        final args = ClassroomArguments(classroom: _class);
        Navigator.pushNamed(context, AppRoute.classroom, arguments: args);
      },
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
