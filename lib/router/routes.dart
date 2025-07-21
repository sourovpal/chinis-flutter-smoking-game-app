import 'package:flutter/material.dart';
import 'package:game_app/screen/home/harm_smoking/harm_smoking_screen.dart';
import 'package:game_app/screen/home/home_screen.dart';
import 'package:game_app/screen/home/smoking_diary/smoking_diary_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // "/": (context) => RootScreen(),
  "/": (context) => HomeScreen(),
  "/smoking-diary": (context) => SmokingDiaryScreen(),
  "/harm-smoking": (context) => HarmSmokingScreen(),
};
