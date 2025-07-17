import 'package:flutter/material.dart';
import 'package:game_app/util/common_veriable.dart';

class BottomNavbarMenu extends StatefulWidget {
  const BottomNavbarMenu({super.key});

  @override
  State<BottomNavbarMenu> createState() => _BottomNavbarMenu();
}

class _BottomNavbarMenu extends State<BottomNavbarMenu> {
  int currentIndex = 2;
  final List<Map<String, dynamic>> menuItems = [
    {
      "label": "我的成就",
      "icon": "award",
      "handler": () {
        print("==================1");
      },
    },
    {"label": "煙癮測試", "icon": "graph", "handler": () {}},
    {"label": "主頁", "icon": "home", "handler": () {}},
    {"label": "計劃", "icon": "book", "handler": () {}},
    {"label": "聯絡", "icon": "edit", "handler": () {}},
  ];

  Widget navMenu(String label, String icon, Function handler, int index) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
            handler();
          });
        },
        child: Column(
          children: [
            Image.asset(
              "assets/ui/nav/$icon.png",
              width: 20,
              height: 20,
              color: (index == currentIndex) ? primaryColor : Colors.grey[500],
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: (index == currentIndex)
                    ? primaryColor
                    : Colors.grey[600],
              ),
            ),
          ],
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
            return navMenu(item["label"], item["icon"], item["handler"], index);
          }).toList(),
        ),
      ),
    );

    // return BottomNavigationBar(
    //   currentIndex: currentIndex, // Which tab is selected
    //   onTap: (value) {
    //     setState(() {
    //       currentIndex = value;
    //     });
    //   },
    //   showSelectedLabels: true, // Change tab
    //   showUnselectedLabels: true,
    //   selectedItemColor: primaryColor,
    //   unselectedItemColor: Colors.grey[600],
    //   selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    //   unselectedLabelStyle: TextStyle(
    //     fontSize: 10,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   items: <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       icon: navIcon("award", 0, currentIndex),
    //       label: '我的成就',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: navIcon("icon", 1, currentIndex),
    //       label: '煙癮測試',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: navIcon("home", 2, currentIndex),
    //       label: '煙癮測試',
    //     ),
    //     // BottomNavigationBarItem(
    //     //   icon: navIcon("home", 3, currentIndex),
    //     //   label: '煙癮測試',
    //     // ),
    //     // BottomNavigationBarItem(
    //     //   icon: navIcon("home", 3, currentIndex),
    //     //   label: '煙癮測試',
    //     // ),
    //   ],
    // );
  }
}
