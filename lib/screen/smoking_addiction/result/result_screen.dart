import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "偏高",
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
                        """您的依賴程度很高。您無法控制 吸煙。它可以控制您！當您決定 戒煙時，您可以嘗試用尼古丁替 代或其他藥物，以幫助您戒掉煙 癮。""",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
