import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  InAppWebViewController? webViewController;
  Map<String, dynamic> section = {};

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData(); // async function call
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('api_sections');
    if (jsonString != null) {
      setState(() {
        var sections = jsonDecode(jsonString);
        if (sections['contact_us'] != null) {
          section = sections['contact_us'];
        }
      });
    }
  }

  void sendContactMail() async {
    if (isLoading) return;

    if (_nameController.text == "") {
      return showErrorToast("姓名欄位為必填。");
    } else if (_phoneController.text == "") {
      return showErrorToast("電話欄位為必填。");
    } else if (_emailController.text == "") {
      return showErrorToast("電子郵件欄位為必填。");
    } else if (_messageController.text == "") {
      return showErrorToast("訊息欄位為必填。");
    }

    setState(() {
      isLoading = true;
    });

    Map<String, String> payload = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "email": _emailController.text,
      "message": _messageController.text,
    };

    final response = await http.post(
      Uri.parse('https://lst.waysapp.com/api/mobile/contact'),
      body: payload,
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _messageController.clear();
      showSuccessToast("訊息已成功發送。");
    } else {
      showErrorToast("訊息發送失敗！");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavbarMenu(),
      body: FullScreenBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 0),
              child: ScreenHeader(title: "聯絡我們"),
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/ui/background/bar_contact.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: InAppWebView(
                  initialData: InAppWebViewInitialData(
                    data: section["content"] ?? 0,
                  ),
                  initialSettings: InAppWebViewSettings(
                    defaultFontSize: 20,
                    defaultFixedFontSize: 20,
                    minimumFontSize: 45,
                    javaScriptEnabled: true,
                    supportZoom: true,
                    verticalScrollBarEnabled: false,
                    transparentBackground: true,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("姓名", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
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
                      Text("電話", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
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
                      Text("電郵", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
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
                      Text("內容", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      TextField(
                        controller: _messageController,
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
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        minLines: 3,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                  onPressed: sendContactMail,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isLoading ? "傳送中..." : "提交",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
