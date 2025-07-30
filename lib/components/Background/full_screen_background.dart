import 'package:flutter/widgets.dart';

class FullScreenBackground extends StatefulWidget {
  const FullScreenBackground({super.key, required this.child});

  final Widget child;

  State<FullScreenBackground> createState() => _FullScreenBackgroundState();
}

class _FullScreenBackgroundState extends State<FullScreenBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/ui/background/bg_cloud.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(child: widget.child),
          ),
        ),
      ],
    );
  }
}
