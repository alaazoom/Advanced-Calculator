import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg         = Color(0xFF0E0E14);
  static const surface    = Color(0xFF16161F);
  static const surfaceHi  = Color(0xFF1E1E2A);
  static const card       = Color(0xFF1A1A26);

  static const cyan       = Color(0xFF00E5FF);
  static const violet     = Color(0xFFBB86FC);
  static const orange     = Color(0xFFFF7043);
  static const green      = Color(0xFF69FF47);
  static const pink       = Color(0xFFFF4081);

  static const btnNumber  = Color(0xFF1E1E2A);
  static const btnOp      = Color(0xFF1F1535);   // violet tint
  static const btnFunc    = Color(0xFF0F2030);   // cyan tint
  static const btnEquals  = cyan;
  static const btnClear   = Color(0xFF2A1520);   // pink tint

  static const textPri    = Color(0xFFF0F0FF);
  static const textSec    = Color(0xFF7B7B9A);
  static const textDim    = Color(0xFF3D3D55);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: GoogleFonts.dmMono().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.cyan,
      secondary: AppColors.violet,
      surface: AppColors.surface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.dmMono(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: AppColors.textPri,
      ),
    ),
  );
}
