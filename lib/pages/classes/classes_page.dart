import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';
import 'package:spidclass/models/class_model.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
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
