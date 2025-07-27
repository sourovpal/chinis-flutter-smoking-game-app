import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {"label": "01 煙癮無難度", "progress": 10},
      {"label": "02 身手敏捷", "progress": 10},
      {"label": "03 反應神速", "progress": 10},
      {"label": "04 慳錢有法", "progress": 10},
      {"label": "05 至慳係您", "progress": 10},
      {"label": "06 儲蓄達人", "progress": 10},
      {"label": "07 味覺、嗅覺提升", "progress": 10},
      {"label": "08 無煙七日", "progress": 10},
      {"label": "09 退癮徵狀消退", "progress": 10},
      {"label": "11 不知不覺半年了", "progress": 10},
      {"label": "12 成功在望", "progress": 10},
      {"label": "13 清新大贏家", "progress": 10},
      {"label": "14 踢走焦油", "progress": 10},
      {"label": "15 擺脫尼古丁", "progress": 10},
      {"label": "16 再接再勵", "progress": 10},
      {"label": "17 戒煙一Take過", "progress": 10},
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: screenHeight(context)),
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
                child: ScreenHeader(title: "我的成就"),
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/ui/background/bar_achievement.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "已達成目標 06／17",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: items.asMap().entries.map((entrie) {
                    final index = entrie.key;
                    final item = entrie.value;
                    final imageSl = index + 1;
                    // final isLast = index == items.length - 1;

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  item["label"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                flex: 1,
                                child: LinearProgressIndicator(
                                  value: imageSl * 0.1,
                                  backgroundColor: Colors.grey[400],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 35),
                              Image.asset(
                                "assets/ui/icon/icon_$imageSl.png",
                                width: 45,
                                height: 45,
                              ),
                            ],
                          ),
                        ),
                      ],
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
