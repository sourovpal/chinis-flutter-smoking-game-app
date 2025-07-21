import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/components/pages/list_content_view_page.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class QuitSmokingScreen extends StatelessWidget {
  const QuitSmokingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {"label": "戒煙的好處", "icon": Icons.keyboard_arrow_right_sharp},
      {"label": "戒煙方法", "icon": Icons.keyboard_arrow_right_sharp},
      {"label": "戒煙的疑惑", "icon": Icons.keyboard_arrow_right_sharp},
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/ui/background/bg_cloud.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 45),
                child: ScreenHeader(title: "煙害解密"),
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ui/background/bar_method.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: items.asMap().entries.map((entrie) {
                    // final index = entrie.key;
                    final item = entrie.value;
                    // final isLast = index == items.length - 1;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageSlideRightToLeft(
                            page: ListContentViewPage(
                              title: item['label'],
                              content:
                                  "(HTML CONTENT) Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              barImage: "assets/ui/background/bar_method.png",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item["label"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Icon(item["icon"], color: Colors.grey[400]),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey[300]),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
