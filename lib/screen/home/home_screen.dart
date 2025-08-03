import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/screen/home/game/game_screen.dart';
import 'package:game_app/screen/home/harm_smoking/harm_smoking_screen.dart';
import 'package:game_app/screen/home/notifications/notification_screen.dart';
import 'package:game_app/screen/home/quit_smoking/quit_smoking_screen.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool isNewNotification = false;
  late int smokingDiaryProgress = 0;
  late int dailyCigaretters = 0;
  late int pricePerPack = 0;
  late int quitDays = 0;
  late int quitHours = 0;
  late int quitMinutes = 0;
  late int totalDaysCigaretters = 0;
  late int totalPriceCigaretters = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        isNewNotification = true;
      });
    });
    initAttribute();
  }

  Future<void> initAttribute() async {
    int progress = await getAchievementProgress(1);
    Map<String, dynamic> attrs = await getAchievement(1);
    setState(() {
      try {
        smokingDiaryProgress = progress;
        if (attrs.containsKey("quit_date")) {
          dailyCigaretters =
              int.tryParse(attrs["daily_cigaretters"] ?? "0") ?? 0;
          pricePerPack = int.tryParse(attrs["price_per_pack"] ?? "0") ?? 0;

          if (attrs["quit_date"] != null) {
            try {
              DateTime targetDate = DateTime.parse(attrs["quit_date"]);
              DateTime currentDate = DateTime.now();

              if (currentDate.isAfter(targetDate)) {
                Duration difference = currentDate.difference(targetDate);
                quitDays = difference.inDays.abs();
                quitHours = difference.inHours.remainder(24).abs();
                quitMinutes = difference.inMinutes.remainder(60).abs();
              }
            } catch (error) {
              print("Error home 1");
            }
          }
          totalDaysCigaretters = dailyCigaretters * quitDays;
          //
          if (pricePerPack > 0) {
            totalPriceCigaretters =
                ((pricePerPack / dailyCigaretters) * totalDaysCigaretters)
                    .toInt();
          }
        }
      } catch (e) {
        print("Error home 2");
      }
    });
    await reloadAchivement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavbarMenu(),
      body: FullScreenBackground(
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 0),
          child: Column(
            children: [
              ScreenHeader(
                title: "愛. 無煙",
                rightWidget: GestureDetector(
                  onTap: () {
                    setState(() {
                      isNewNotification = false;
                    });
                    setBottomNavbar();
                    Navigator.push(
                      context,
                      PageSlideBottomToUp(page: NotificationScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      if (isNewNotification)
                        Positioned(
                          right: 2,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      Icon(Icons.notifications, size: 28),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/ui/background/main_diary.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment(0, 0),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 45),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "已停止吸煙$quitDays日$quitHours小時$quitMinutes分鐘",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "少抽了的煙量$totalDaysCigaretters",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "已節省之金錢 HK\$$totalPriceCigaretters",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (smokingDiaryProgress == 100) {
                            final result = await showConfirmationDialog(
                              context,
                            );

                            if (result != true) return;

                            setBottomNavbar();
                            Navigator.pushNamed(context, "/smoking-diary");
                            return;
                            
                          }
                          setBottomNavbar();
                          Navigator.pushNamed(context, "/smoking-diary");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 25,
                          ),
                        ),
                        child: Text(
                          smokingDiaryProgress == 100 ? "唔小心食返" : "開始",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setBottomNavbar();
                        Navigator.push(
                          context,
                          PageSlideBottomToUp(page: HarmSmokingScreen()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 165,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/ui/background/bar_secret_with_text.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setBottomNavbar();
                        Navigator.push(
                          context,
                          PageSlideBottomToUp(page: QuitSmokingScreen()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 165,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/ui/background/main_method_with_text.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  setBottomNavbar();
                  // Every Open game
                  int progress = await getAchievementProgress(2);
                  setAchievement(2, {"progress": progress + 1});

                  // Pre day 1%
                  String currentDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(DateTime.now());

                  Map<String, dynamic> attrs = await getAchievement(3);

                  if (attrs["last_update"] == "" ||
                      currentDate != attrs["last_update"]) {
                    int progress3 = await getAchievementProgress(3);
                    setAchievement(3, {
                      "last_update": currentDate,
                      "progress": progress3 + 1,
                    });
                  }

                  Navigator.push(
                    context,
                    PageSlideBottomToUp(page: GameScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 155,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/ui/background/main_game_with_text.png",
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment(0, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
