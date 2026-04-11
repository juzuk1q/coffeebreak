import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// fontWeight: medium - w500, semibold - w600, regular - w400

class TxtStyle {
  static TextStyle reg30 = GoogleFonts.roboto(
    fontSize: 30,
    color: AppColor.text,
    fontWeight: FontWeight.w400,
  );
  static TextStyle m14({Color? color}) {
    return GoogleFonts.roboto(
      fontSize: 14,
      color: color ?? AppColor.text,
      fontWeight: FontWeight.w500,
    );
  }
  static TextStyle m18 = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColor.text,
  );
  static TextStyle m16 = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.white,
  );
  static TextStyle sb16 = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );
}