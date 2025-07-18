import 'package:flutter/material.dart';

class PageSlideBottomToUp extends PageRouteBuilder {
  final Widget page;

  PageSlideBottomToUp({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(0.0, 1.0);
          final end = Offset.zero;
          final curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
}

class PageSlideRightToLeft extends PageRouteBuilder {
  final Widget page;

  PageSlideRightToLeft({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 👉 From right
          const end = Offset.zero; // Center
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween), // Forward
            child: SlideTransition(
              position: secondaryAnimation.drive(
                Tween(
                  begin: Offset.zero,
                  end: Offset(-1.0, 0.0), // 👈 On back: slide to left
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            ),
          );
        },
      );
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.rightWidget});

  final String title;
  final Widget? rightWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: rightWidget),
          ),
        ],
      ),
    );
  }
}
