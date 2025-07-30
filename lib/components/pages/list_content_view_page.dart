import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:game_app/util/common_veriable.dart';

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
  late InAppWebViewController webViewController;
  double webContentHeight = 600; // Default height
  bool isLoading = false;

  Future<void> _measureContentHeight() async {
    try {
      final contentHeight = await webViewController.evaluateJavascript(
        source: "document.documentElement.scrollHeight",
      );

      if (contentHeight != null) {
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;
        final logicalHeight =
            double.parse(contentHeight.toString()) / pixelRatio;

        if (mounted) {
          setState(() {
            webContentHeight = logicalHeight;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error measuring content height: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: const BottomNavbarMenu(),
      body: FullScreenBackground(
        child: Container(
          height: webContentHeight + 250,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: 5,
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : InAppWebView(
                          initialData: InAppWebViewInitialData(
                            data: widget.content,
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
                          onLoadStop: (controller, url) async {
                            await _measureContentHeight();
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
