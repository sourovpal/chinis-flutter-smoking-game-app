import 'package:flutter/material.dart';
import 'package:game_app/screen/home/home_screen.dart';
import 'package:game_app/screen/root/root_screen.dart';
import 'package:game_app/screen/smoking_diary/smoking_diary_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  "/": (context) => RootScreen(),
  "/home": (context) => HomeScreen(),
  "/smoking-diary": (context) => SmikingDiaryScreen(),
};
