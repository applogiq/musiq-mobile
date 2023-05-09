import 'package:flutter/material.dart';

class BackgroundBarPainter extends CustomPainter {
  final double widthOfContainer;
  final double heightOfContainer;
  final double progresPercentage;
  final Color initialColor;
  final Color progressColor;
  final Paint trackPaint;
  final Paint progressPaint;
  BackgroundBarPainter(
      {required this.widthOfContainer,
      required this.heightOfContainer,
      required this.initialColor,
      required this.progressColor,
      required this.progresPercentage})
      : trackPaint = Paint()
          ..color = initialColor
          ..style = PaintingStyle.fill,
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.fill;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                0, -heightOfContainer / 2, widthOfContainer, heightOfContainer),
            const Radius.circular(0)),
        trackPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                0,
                -heightOfContainer / 2,
                (progresPercentage * widthOfContainer) / 100,
                heightOfContainer),
            const Radius.circular(0)),
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
