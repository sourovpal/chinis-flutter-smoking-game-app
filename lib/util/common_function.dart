import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PageSlideBottomToUp extends PageRouteBuilder {
  final Widget page;

  PageSlideBottomToUp({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(0.0, 1.0);
          final end = Offset.zero;
          final curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
}

class PageSlideRightToLeft extends PageRouteBuilder {
  final Widget page;

  PageSlideRightToLeft({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 👉 From right
          const end = Offset.zero; // Center
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween), // Forward
            child: SlideTransition(
              position: secondaryAnimation.drive(
                Tween(
                  begin: Offset.zero,
                  end: Offset(-1.0, 0.0), // 👈 On back: slide to left
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            ),
          );
        },
      );
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.rightWidget});

  final String title;
  final Widget? rightWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: rightWidget),
          ),
        ],
      ),
    );
  }
}

void initAchivement() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString("achievements") == null) {
    Map<String, dynamic> achievements = {
      "achievement_1": {"last_update": "", "progress": 0},
      "achievement_2": {"last_update": "", "progress": 0},
      "achievement_3": {"last_update": "", "progress": 0},
      "achievement_4": {"last_update": "", "progress": 0},
      "achievement_5": {"last_update": "", "progress": 0},
      "achievement_6": {"last_update": "", "progress": 0},
      "achievement_7": {"last_update": "", "progress": 0},
      "achievement_8": {"last_update": "", "progress": 0},
      "achievement_9": {"last_update": "", "progress": 0},
      "achievement_10": {"last_update": "", "progress": 0},
      "achievement_11": {"last_update": "", "progress": 0},
      "achievement_12": {"last_update": "", "progress": 0},
      "achievement_13": {"last_update": "", "progress": 0},
      "achievement_14": {"last_update": "", "progress": 0},
      "achievement_15": {"last_update": "", "progress": 0},
      "achievement_16": {"last_update": "", "progress": 0},
      "achievement_17": {"last_update": "", "progress": 0},
    };
    prefs.setString("achievements", jsonEncode(achievements));
  }
}

const _defaultAchievement = {"last_update": null, "value": 0};

Future<Map<String, dynamic>> getAchievement(int key) async {
  try {
    final field = "achievement_$key";
    final prefs = await SharedPreferences.getInstance();
    final payload = prefs.getString("achievements");

    if (payload != null) {
      final attrs = jsonDecode(payload) as Map<String, dynamic>;
      return Map<String, dynamic>.from(attrs[field] ?? _defaultAchievement);
    }
    return Map<String, dynamic>.from(_defaultAchievement);
  } catch (e) {
    debugPrint('Error getting achievement: $e');
    return Map<String, dynamic>.from(_defaultAchievement);
  }
}

/// Updates or sets an achievement
Future<bool> setAchievement(int key, Map<String, dynamic> option) async {
  try {
    final field = "achievement_$key";
    final prefs = await SharedPreferences.getInstance();
    final payload = prefs.getString("achievements");

    final attrs = payload != null
        ? Map<String, dynamic>.from(jsonDecode(payload))
        : {};

    // Merge existing data with new options
    final existing = attrs[field] as Map<String, dynamic>? ?? {};
    attrs[field] = {...existing, ...option};
    return await prefs.setString("achievements", jsonEncode(attrs));
  } catch (e) {
    debugPrint('Error setting achievement: $e');
    return false;
  }
}

Future<int> getAchievementProgress(int key) async {
  final attr = await getAchievement(key);
  return attr["progress"] ?? 0;
}

void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
