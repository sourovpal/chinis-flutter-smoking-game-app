import 'package:flutter/material.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
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
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavbarMenu(),
      body: FullScreenBackground(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 0),
              child: ScreenHeader(
                title: "止癮小遊戲",
                rightWidget: ElevatedButton.icon(
                  onPressed: () {
                    setBottomNavbar(index: 2);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
              height: 750,
              constraints: BoxConstraints(minHeight: screenHeight(context)),
              child: InAppWebView(initialFile: "assets/game/index.html"),
            ),
          ],
        ),
      ),
    );
  }
}
