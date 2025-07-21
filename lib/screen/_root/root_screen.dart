import 'package:flutter/material.dart';
import 'package:game_app/screen/home/home_screen.dart';
import 'package:game_app/util/common_function.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, PageSlideBottomToUp(page: HomeScreen()));
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/ui/background/splash.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
