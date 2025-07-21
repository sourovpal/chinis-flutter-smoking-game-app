import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_app/components/pages/list_content_view_page.dart';
import 'package:game_app/screen/achievements/achievements_screen.dart';
import 'package:game_app/screen/contact/contact_screen.dart';
import 'package:game_app/screen/home/home_screen.dart';
import 'package:game_app/screen/smoking_addiction/smoking_addiction_screen.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavbarMenu extends StatefulWidget {
  const BottomNavbarMenu({super.key});

  @override
  State<BottomNavbarMenu> createState() => _BottomNavbarMenu();
}

class _BottomNavbarMenu extends State<BottomNavbarMenu> {
  final List<Map<String, dynamic>> menuItems = [
    {
      "label": "我的成就",
      "icon": "award",
      "handler": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          PageSlideBottomToUp(page: AchievementsScreen()),
        );
      },
    },
    {
      "label": "煙癮測試",
      "icon": "graph",
      "handler": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          PageSlideBottomToUp(page: SmokingAddictionScreen()),
        );
      },
    },
    {
      "label": "主頁",
      "icon": "home",
      "handler": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          PageSlideBottomToUp(page: HomeScreen()),
        );
      },
    },
    {
      "label": "計劃",
      "icon": "book",
      "handler": (BuildContext context) async {
        final prefs = await SharedPreferences.getInstance();

        Map<String, dynamic> section = {"content": "Demo"};

        String? jsonString = prefs.getString('api_sections');
        if (jsonString != null) {
          var sections = await jsonDecode(jsonString);
          section = sections["love_smoke_project"];
        }

        Navigator.pushReplacement(
          context,
          PageSlideBottomToUp(
            page: ListContentViewPage(
              title: "「愛．無煙」計劃",
              content: section["content"] ?? "",
              barImage: "assets/ui/background/bar_about.png",
              isBack: false,
            ),
          ),
        );
      },
    },
    {
      "label": "聯絡",
      "icon": "edit",
      "handler": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          PageSlideBottomToUp(page: ContactScreen()),
        );
      },
    },
  ];

  Widget navMenu(
    BuildContext context,
    String label,
    String icon,
    Function(BuildContext) handler,
    int index,
  ) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          // if (navCurrentIndex == index) return;
          navCurrentIndex = index;
          handler(context);
        },
        child: SizedBox(
          width: 30,
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/ui/nav/$icon.png",
                width: 25,
                height: 25,
                color: (index == navCurrentIndex)
                    ? primaryColor
                    : Colors.grey[500],
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: (index == navCurrentIndex)
                      ? primaryColor
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            spreadRadius: 0.2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 6, left: 10, right: 10),
        child: Row(
          children: menuItems.asMap().entries.map((entrie) {
            final index = entrie.key;
            final item = entrie.value;
            return navMenu(
              context,
              item["label"],
              item["icon"],
              item["handler"],
              index,
            );
          }).toList(),
        ),
      ),
    );
  }
}
