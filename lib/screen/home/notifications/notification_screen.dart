import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight(context),
          constraints: BoxConstraints(minHeight: screenHeight(context)),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/ui/background/bg_cloud.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 45),
                child: ScreenHeader(title: "通知"),
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/ui/background/bar_notification.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ListTile(title: Text("HTML Notification 1")),
                      Divider(color: Colors.grey[300]),
                      ListTile(title: Text("HTML Notification 2")),
                      Divider(color: Colors.grey[300]),
                      ListTile(title: Text("HTML Notification 3")),
                      Divider(color: Colors.grey[300]),
                      ListTile(title: Text("HTML Notification 4")),
                      Divider(color: Colors.grey[300]),
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
