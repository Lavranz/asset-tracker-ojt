import 'dart:math';

import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class SpinningGradientCircle extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Using the useAnimationController hook for the animation controller
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeat the animation

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Spinning Circle
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: controller.value * 2 * pi,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: GradientCirclePainter(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // "Processing..." Text
            Text("Processing...",
                style: AppTextTheme.BodySmTertiary.copyWith(
                  color: AppColors.surfaceInvertTertiary,
                )),
          ],
        ),
      ),
    );
  }
}

class GradientCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [
          const Color(0xFF23B500),
          const Color(0xFF878C82).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final radius = (size.width - 10) / 2; // Stroke width is 10
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
