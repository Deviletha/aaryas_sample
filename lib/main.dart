import 'package:aaryas_sample/screens/splashscreen.dart';
import 'package:aaryas_sample/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aaryas Application',
      theme: _buildTheme(Brightness.light),
      home: SplashScreen(),
    );
  }
}

ThemeData _buildTheme(brightness) {

  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.robotoCondensedTextTheme(baseTheme.textTheme),
      appBarTheme: AppBarTheme(

        surfaceTintColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        elevation: 0,systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),),focusColor: Color(ColorT.themeColor),primaryColor: Color(ColorT.themeColor)
  );
}