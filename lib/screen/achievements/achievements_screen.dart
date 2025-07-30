import 'package:flutter/material.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late Future<List<Map<String, dynamic>>> _achievementsFuture;
  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _loadAchievements();
  }

  Future<List<Map<String, dynamic>>> _loadAchievements() async {
    final List<Map<String, dynamic>> items = [
      {"label": "01 煙癮無難度", "id": 1},
      {"label": "02 身手敏捷", "id": 2},
      {"label": "03 反應神速", "id": 3},
      {"label": "04 慳錢有法", "id": 4},
      {"label": "05 至慳係您", "id": 5},
      {"label": "06 儲蓄達人", "id": 6},
      {"label": "07 味覺、嗅覺提升", "id": 7},
      {"label": "08 無煙七日", "id": 8},
      {"label": "09 退癮徵狀消退", "id": 9},
      {"label": "10 肺功能提升", "id": 10},
      {"label": "11 不知不覺半年了", "id": 11},
      {"label": "12 成功在望", "id": 12},
      {"label": "13 清新大贏家", "id": 13},
      {"label": "14 踢走焦油", "id": 14},
      {"label": "15 擺脫尼古丁", "id": 15},
      {"label": "16 再接再勵", "id": 16},
      {"label": "17 戒煙一Take過", "id": 17},
    ];

    // Load all achievements
    List<Map<String, dynamic>> loadedItems = [];
    int count = 0;

    for (var item in items) {
      final achievement = await getAchievement(item["id"]);
      final progress = achievement["progress"] ?? 0;
      final isCompleted = progress >= 100;

      if (isCompleted) count++;

      loadedItems.add({
        ...item,
        "progress": progress.toDouble(),
        "completed": isCompleted,
      });
    }

    setState(() {
      completedCount = count;
    });

    return loadedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavbarMenu(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _achievementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data!;

          return FullScreenBackground(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: ScreenHeader(title: "我的成就"),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/ui/background/bar_achievement.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "已達成目標 $completedCount／17",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final imageSl = item["id"];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    item["label"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 1,
                                  child: LinearProgressIndicator(
                                    value: item["progress"] / 100,
                                    backgroundColor: Colors.grey[400],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      item["completed"]
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 35),
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
          );
        },
      ),
    );
  }
}
