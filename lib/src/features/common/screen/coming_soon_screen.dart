import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/image/logo_image.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: const [
          Center(
            child: LogoWidget(size: 80),
          ),
          Positioned.fill(
            child: ColoredBox(color: Colors.black45),
          ),
          Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
    );
  }
}
