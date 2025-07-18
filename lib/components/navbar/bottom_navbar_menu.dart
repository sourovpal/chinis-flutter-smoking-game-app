import 'package:flutter/material.dart';
import 'package:game_app/components/pages/list_content_view_page.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

// class BottomNavbarMenu extends StatefulWidget {
//   const BottomNavbarMenu({super.key});

//   @override
//   State<BottomNavbarMenu> createState() => _BottomNavbarMenu();
// }

// class _BottomNavbarMenu extends State<BottomNavbarMenu> {
class BottomNavbarMenu extends StatelessWidget {
  BottomNavbarMenu({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {"label": "我的成就", "icon": "award", "handler": (BuildContext context) {}},
    {"label": "煙癮測試", "icon": "graph", "handler": (BuildContext context) {}},
    {
      "label": "主頁",
      "icon": "home",
      "handler": (BuildContext context) {
        Navigator.pushNamed(context, "/home");
      },
    },
    {
      "label": "計劃",
      "icon": "book",
      "handler": (BuildContext context) {
        Navigator.push(
          context,
          PageSlideBottomToUp(
            page: ListContentViewPage(
              title: "「愛．無煙」計劃",
              content: "Html Content",
              barImage: "assets/ui/background/bar_about.png",
            ),
          ),
        );
      },
    },
    {"label": "聯絡", "icon": "edit", "handler": (BuildContext context) {}},
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
          if (navCurrentIndex == index) return;
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
                width: 20,
                height: 20,
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
      height: 55,
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
      child: Padding(
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
