import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';
import 'package:intl/intl.dart';

class SmokingDiaryScreen extends StatefulWidget {
  const SmokingDiaryScreen({super.key});
  @override
  State<SmokingDiaryScreen> createState() => _SmokingDiaryScreenState();
}

class _SmokingDiaryScreenState extends State<SmokingDiaryScreen> {
  final TextEditingController _dailyCigarettersController =
      TextEditingController();
  final TextEditingController _pricePerPackController = TextEditingController();
  final TextEditingController _quitDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dailyCigarettersController.dispose();
    _pricePerPackController.dispose();
    _quitDateController.dispose();
    super.dispose();
  }

  void setFormAttributes(BuildContext context) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (_dailyCigarettersController.text == "" ||
        _pricePerPackController.text == "" ||
        _quitDateController.text == "") {
      return showErrorToast("所有輸入欄位皆為必填。");
    }

    if (_quitDateController.text.isNotEmpty) {
      try {
        DateTime currentDateTime = DateFormat(
          'yyyy-MM-dd HH:mm',
        ).parse(_quitDateController.text);

        DateTime updatedDateTime = currentDateTime.add(Duration(minutes: 1));

        _quitDateController.text = DateFormat(
          'yyyy-MM-dd HH:mm',
        ).format(updatedDateTime);
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
    print(_quitDateController.text);

    setAchievement(1, {
      "last_update": currentDate,
      "progress": 100,
      "daily_cigaretters": _dailyCigarettersController.text,
      "price_per_pack": _pricePerPackController.text,
      "quit_date": _quitDateController.text,
    });
    showSuccessToast("已保存");
    reloadAchivement();
    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      resizeToAvoidBottomInset: true,
      body: FullScreenBackground(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 0),
              child: ScreenHeader(title: "戒煙日記"),
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/ui/background/bar_diary.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "您現時平均吸食多少支煙？",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _dailyCigarettersController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hint: Text(""),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[400]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "您所購買的香煙，每包售價多少？",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _pricePerPackController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hint: Text(""),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[400]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "您的戒煙日為？",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _quitDateController,
                        decoration: InputDecoration(
                          hint: Text(""),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[400]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            helpText: 'Select a date',
                          );

                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              helpText: 'Select a time',
                            );

                            if (pickedTime != null) {
                              final DateTime fullDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );

                              String formattedDateTime = DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(fullDateTime);
                              _quitDateController.text = formattedDateTime;
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setFormAttributes(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "提交",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
