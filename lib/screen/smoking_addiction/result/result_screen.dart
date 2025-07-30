import 'package:flutter/material.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.optionResult});
  final int optionResult;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic> attributes = {
    "title": "較輕",
    "description": "您對尼古丁的依賴程度仍然很低。您應該在依賴程度提高之前立即採取行動。",
    "primary": Colors.green,
    "secondary": Colors.green[700],
  };

  @override
  void initState() {
    super.initState();

    if (widget.optionResult >= 5) {
      attributes = {
        "title": "偏高",
        "description":
            "您對尼古丁的依賴程度中等。如果您不盡快戒煙，您對尼古丁的依賴程度將會增加，直到您可能嚴重上癮。立即採取行動，結束對尼古丁的依賴。",
        "primary": Colors.red,
        "secondary": Colors.red[700],
      };
    } else if (widget.optionResult >= 3) {
      attributes = {
        "title": "中等",
        "description":
            "您的依賴程度很高。您無法控制吸煙-它可以控制您！當您決定戒煙時，您可以嘗試用尼古丁替代或其他藥物，以幫助您戒掉煙癮。",
        "primary": Colors.orange,
        "secondary": Colors.orange[700],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      body: FullScreenBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 0),
              child: ScreenHeader(title: "煙害解密"),
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/ui/background/bar_quiz.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 75),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: (screenWidth(context) / 4) * 3,
                constraints: BoxConstraints(minHeight: 300),
                decoration: BoxDecoration(
                  color: attributes["primary"],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: attributes["secondary"],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          attributes["title"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      attributes["description"],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
