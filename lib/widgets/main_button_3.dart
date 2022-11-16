
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spidclass/config/font_size.dart';
import 'package:spidclass/config/theme_colors.dart';

class MainButton3 extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? iconPath;
  final Function() onPressed;

  const MainButton3({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColors.primaryColor,
        foregroundColor: ThemeColors.whiteTextColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        minimumSize: Size(230, 50),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: textColor == null ? ThemeColors.whiteTextColor : textColor,
          fontSize: FontSize.large,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
