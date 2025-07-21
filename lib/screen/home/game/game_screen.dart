import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(),
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
                child: ScreenHeader(
                  title: "止癮小遊戲",
                  rightWidget: ElevatedButton.icon(
                    onPressed: () {
                      setBottomNavbar(index: 2);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    label: Text(
                      "退出遊戲",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: screenHeight(context),
                constraints: BoxConstraints(minHeight: screenHeight(context)),
                child: InAppWebView(initialFile: "assets/game/index.html"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
