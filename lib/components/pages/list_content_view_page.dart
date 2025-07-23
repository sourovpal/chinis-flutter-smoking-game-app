import 'package:flutter/material.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ListContentViewPage extends StatefulWidget {
  const ListContentViewPage({
    super.key,
    required this.title,
    required this.content,
    required this.barImage,
    this.isBack,
  });

  final String title;
  final String content;
  final String barImage;
  final bool? isBack;

  @override
  State<ListContentViewPage> createState() => _ListContentViewPageState();
}

class _ListContentViewPageState extends State<ListContentViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbarMenu(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight(context),
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
                  title: widget.title,
                  rightWidget: widget.isBack == null
                      ? ElevatedButton.icon(
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
                            "目錄",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.barImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: SizedBox(
                  height: 500,
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(data: widget.content),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
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
