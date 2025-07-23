import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/screen/smoking_addiction/result/result_screen.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class SmokingAddictionScreen extends StatefulWidget {
  const SmokingAddictionScreen({super.key});

  @override
  State<SmokingAddictionScreen> createState() => _SmokingAddictionScreenState();
}

class _SmokingAddictionScreenState extends State<SmokingAddictionScreen> {
  Map<String, int> optionValues = {
    "first_smoke_time": 3,
    "total_cigarettes_everyday": 3,
  };

  final List<Map<String, dynamic>> items = [
    {
      "id": "first_smoke_time",
      "label": "您起床後多久才吸第一支煙？",
      "options": [
        {"label": "5 分鐘", "value": 3},
        {"label": "6-30 分鐘內", "value": 2},
        {"label": "31-60 分鐘內", "value": 1},
        {"label": "60 分鐘後", "value": 0},
      ],
    },
    {
      "id": "total_cigarettes_everyday",
      "label": "您每日吸多少支煙？",
      "options": [
        {"label": "31 支以上", "value": 3},
        {"label": "21-30 支", "value": 2},
        {"label": "11-20 支", "value": 1},
        {"label": "10 支或以下", "value": 0},
      ],
    },
  ];

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
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "尼古丁會使人上癮或產生依賴性，形成煙癮，人們通常難以克制自己，而且在短時間內就必須補充尼古丁。以下為煙癮程度測試，看看您的煙癮程度有多嚴重。",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: items.asMap().entries.map((entrie) {
                    final index = entrie.key;
                    final listSl = index + 1;
                    final item = entrie.value;
                    final label = item["label"];
                    final optionId = item["id"];
                    final List<Map<String, dynamic>> options = item["options"];
                    // final isLast = index == items.length - 1;

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "$listSl.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "$label",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 6,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: options.map((optionItem) {
                                    final optionLabel = optionItem["label"];
                                    final int optionValue = optionItem["value"];
                                    return SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: optionValue,
                                            groupValue: optionValues[optionId],
                                            onChanged: (value) {
                                              setState(() {
                                                optionValues[optionId] =
                                                    value ?? 0;
                                              });
                                            },
                                          ),
                                          Text(
                                            "$optionLabel",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      int sum =
                          (optionValues["first_smoke_time"] ?? 0) +
                          (optionValues["total_cigarettes_everyday"] ?? 0);

                      Navigator.push(
                        context,
                        PageSlideBottomToUp(
                          page: ResultScreen(optionResult: sum),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("提交", style: TextStyle(color: Colors.white)),
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
