import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

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
    await prefs.setString("achievements", jsonEncode(attrs));
    if (key == 1) reloadAchivement();
    return true;
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

Future<void> reloadAchivement() async {
  Map<String, dynamic> attrs = await getAchievement(1);

  late int dailyCigaretters = 0;
  late int pricePerPack = 0;
  late int quitDays = 0;
  late int totalDaysCigaretters = 0;
  late int totalPriceCigaretters = 0;
  late int totalDaysToHours = 0;

  try {
    if (attrs.containsKey("quit_date")) {
      dailyCigaretters = int.tryParse(attrs["daily_cigaretters"] ?? "0") ?? 0;
      pricePerPack = int.tryParse(attrs["price_per_pack"] ?? "0") ?? 0;

      if (attrs["quit_date"] != null) {
        try {
          DateTime targetDate = DateTime.parse(attrs["quit_date"]);
          DateTime currentDate = DateTime.now();
          Duration difference = targetDate.difference(currentDate);
          totalDaysToHours = difference.inHours;
        } catch (error) {
          print("Error");
        }
      }

      totalDaysCigaretters = dailyCigaretters * quitDays;
      //
      if (pricePerPack > 0) {
        totalPriceCigaretters =
            ((pricePerPack / dailyCigaretters) * totalDaysCigaretters).toInt();
      }

      if (totalPriceCigaretters <= 1000) {
        setAchievement(4, {
          "progress": (totalPriceCigaretters / 10).clamp(0, 100),
        });
      }
      if (totalPriceCigaretters <= 3000) {
        setAchievement(5, {
          "progress": (totalPriceCigaretters / 30).clamp(0, 100),
        });
        setAchievement(6, {
          "progress": (totalPriceCigaretters / 50).clamp(0, 100),
        });
      }

      if (totalPriceCigaretters == 0) {
        setAchievement(4, {"progress": 0});
        setAchievement(5, {"progress": 0});
        setAchievement(6, {"progress": 0});
      }

      if (totalDaysToHours <= 3 && totalDaysToHours > 0) {
        setAchievement(7, {"progress": (totalDaysToHours / 3) * 100});
      }

      if (totalDaysToHours <= 7 && totalDaysToHours > 0) {
        setAchievement(8, {"progress": (totalDaysToHours / 7) * 100});
      }

      if (totalDaysToHours <= 30 && totalDaysToHours > 0) {
        setAchievement(9, {"progress": (totalDaysToHours / 30) * 100});
      }

      if (totalDaysToHours <= 90 && totalDaysToHours > 0) {
        setAchievement(10, {"progress": (totalDaysToHours / 90) * 100});
      }

      if (totalDaysToHours <= 180 && totalDaysToHours > 0) {
        setAchievement(11, {"progress": (totalDaysToHours / 2)});
      }

      if (totalDaysToHours <= 360 && totalDaysToHours > 0) {
        setAchievement(12, {"progress": (totalDaysToHours / 3)});
      }

      if (totalDaysToHours <= 365 && totalDaysToHours > 0) {
        setAchievement(13, {"progress": (totalDaysToHours / 3)});
        if ((totalDaysToHours / 3) >= 100) {
          setAchievement(17, {"progress": 100});
        }
      }

      if (totalDaysToHours <= 100 && totalDaysToHours > 0) {
        setAchievement(14, {"progress": (totalDaysToHours / 3)});
      }

      if (totalDaysToHours <= 200 && totalDaysToHours > 0) {
        setAchievement(15, {"progress": (totalDaysToHours / 3)});
      }
      if (totalDaysToHours == 0) {
        setAchievement(7, {"progress": 0});
        setAchievement(8, {"progress": 0});
        setAchievement(9, {"progress": 0});
        setAchievement(10, {"progress": 0});
        setAchievement(11, {"progress": 0});
        setAchievement(12, {"progress": 0});
        setAchievement(13, {"progress": 0});
        setAchievement(14, {"progress": 0});
        setAchievement(15, {"progress": 0});
      }
    }
  } catch (e) {
    print("Error");
    print(e);
  }
}

Future<void> resetAchivement() async {
  await setAchievement(1, {
    "progress": 0,
    "daily_cigaretters": null,
    "price_per_pack": null,
    "quit_date": null,
  });
  await setAchievement(2, {"progress": 0});
  await setAchievement(3, {"progress": 0});
  await setAchievement(4, {"progress": 0});
  await setAchievement(5, {"progress": 0});
  await setAchievement(6, {"progress": 0});
  await setAchievement(7, {"progress": 0});
  await setAchievement(8, {"progress": 0});
  await setAchievement(9, {"progress": 0});
  await setAchievement(10, {"progress": 0});
  await setAchievement(11, {"progress": 0});
  await setAchievement(12, {"progress": 0});
  await setAchievement(13, {"progress": 0});
  await setAchievement(14, {"progress": 0});
  await setAchievement(15, {"progress": 0});
  setAchievement(17, {"progress": 0});
  Map<String, dynamic> attrs = await getAchievement(1);
  if (attrs["last_update"] != null) {
    await setAchievement(16, {"progress": 100});
  }
}

Future<void> requestNotificationPermissions() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // For iOS/macOS/Web
  if (Platform.isIOS || Platform.isMacOS || kIsWeb) {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  // For Android 13+ (API level 33+)
  if (Platform.isAndroid) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Check if we're running on Android 13 or higher
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      print('Android notification permission: $result');
    }
  }
}
