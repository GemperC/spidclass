// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:spidclass/config/font_size.dart';
// import 'package:spidclass/config/theme_colors.dart';
// import 'package:intl/intl.dart';
// import 'package:spidclass/models/member_model.dart';

// class UpdateMemberDialog extends StatefulWidget {
//   final Member member;
//   const UpdateMemberDialog({
//     super.key,
//     required this.member,
//   });

//   @override
//   State<UpdateMemberDialog> createState() => _UpdateMemberDialogState();
// }

// class _UpdateMemberDialogState extends State<UpdateMemberDialog> {
//   final formKey = GlobalKey<FormState>();

//   TextEditingController first_nameController = TextEditingController();
//   TextEditingController second_nameController = TextEditingController();
//   TextEditingController motherController = TextEditingController();
//   TextEditingController fatherController = TextEditingController();
//   TextEditingController mother_numberController = TextEditingController();
//   TextEditingController father_numberController = TextEditingController();
//   TextEditingController numberController = TextEditingController();
//   TextEditingController trial_lessonController = TextEditingController();
//   TextEditingController last_paymentController = TextEditingController();
//   TextEditingController attendanceController = TextEditingController();
//   TextEditingController other_informationController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController class_yearController = TextEditingController();

//   final double sizedBoxHight = 16;
// @override
//   void initState() {
//     first_nameController.text = widget.member.first_name;
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (context) => 
//       AlertDialog(
//         // backgroundColor: ThemeColors.scaffoldBgColor,
//         scrollable: true,
//         title: Text(
//           "Add New Member",
//           style: GoogleFonts.poppins(
//             color: ThemeColors.blackTextColor,
//             fontSize: FontSize.large,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         content: Container(
//           width: 300,
//           child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   MemberTextFromField(first_nameController, 'First Name'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(second_nameController, 'Second Name'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(ageController, 'Age'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(class_yearController, 'Class Year'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(motherController, 'Mother'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(fatherController, 'Father'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(mother_numberController, 'Mother Number'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(father_numberController, 'Father Number'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(numberController, 'Number'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberDateFromField(trial_lessonController, 'Trial Lesson'),
//                   SizedBox(height: sizedBoxHight),
//                   MemberTextFromField(other_informationController, 'Other Info'),
//                 ],
//               )),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel')),
//           TextButton(
//               onPressed: () async {
    
//               },
//               child: Text('Update Info')),
//         ],
//       ),
//     );
//   }

//   Widget MemberTextFromField(
//           TextEditingController controller, String labelText) =>
//       TextFormField(
//         controller: controller,
//         validator: (value) {
//           if (controller.text.isEmpty) {
//             return "This field can't be empty";
//           }
//         },
//         style: GoogleFonts.poppins(
//           color: ThemeColors.blackTextColor,
//         ),
//         keyboardType: TextInputType.name,
//         cursorColor: ThemeColors.primaryColor,
//         decoration: InputDecoration(
//           // fillColor: ThemeColors.textFieldBgColor,
//           // filled: true,
//           labelText: labelText,
//           labelStyle: GoogleFonts.poppins(
//             // color: ThemeColors.textFieldHintColor,
//             fontSize: FontSize.medium,
//             fontWeight: FontWeight.w500,
//           ),
//           // border: OutlineInputBorder(
//           //   borderSide: BorderSide.none,
//           //   borderRadius: BorderRadius.all(Radius.circular(18)),
//           // ),
//         ),
//       );

//   Widget MemberDateFromField(
//           TextEditingController controller, String labelText) =>
//       DateTimeField(
//         format: DateFormat('yyyy-MM-dd'),
//         controller: controller,
//         onShowPicker: ((context, currentValue) {
//           return showDatePicker(
//               context: context,
//               firstDate: DateTime(1900),
//               initialDate: currentValue ?? DateTime.now(),
//               lastDate: DateTime(2100));
//         }),
//         validator: (value) {
//           if (controller.text.isEmpty) return "This field can't be empty";
//         },
//         style: GoogleFonts.poppins(
//           color: ThemeColors.blackTextColor,
//         ),
//         keyboardType: TextInputType.name,
//         cursorColor: ThemeColors.primaryColor,
//         decoration: InputDecoration(
//           // fillColor: ThemeColors.textFieldBgColor,
//           // filled: true,
//           labelText: labelText,
//           labelStyle: GoogleFonts.poppins(
//             // color: ThemeColors.textFieldHintColor,
//             fontSize: FontSize.medium,
//             fontWeight: FontWeight.w500,
//           ),
//           // border: OutlineInputBorder(
//           //   borderSide: BorderSide.none,
//           //   borderRadius: BorderRadius.all(Radius.circular(18)),
//           // ),
//         ),
//       );
// }
