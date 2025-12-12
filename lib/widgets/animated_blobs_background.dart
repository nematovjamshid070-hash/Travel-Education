import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class AnimatedBlobsBackground extends StatefulWidget {
  const AnimatedBlobsBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBlobsBackground> createState() => _AnimatedBlobsBackgroundState();
}

class _AnimatedBlobsBackgroundState extends State<AnimatedBlobsBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: const SizedBox.expand(),
          ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _a,
            builder: (context, _) {
              final t = _a.value;
              return CustomPaint(
                painter: _BlobsPainter(t),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.white.withOpacity(0.06)),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _BlobsPainter extends CustomPainter {
  _BlobsPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = AppColors.secondary.withOpacity(0.18);
    final paint2 = Paint()..color = AppColors.tertiary.withOpacity(0.16);
    final paint3 = Paint()..color = Colors.white.withOpacity(0.10);

    final r1 = min(size.width, size.height) * 0.42;
    final r2 = min(size.width, size.height) * 0.36;
    final r3 = min(size.width, size.height) * 0.28;

    final c1 = Offset(size.width * (0.25 + 0.10 * t), size.height * (0.25 + 0.06 * (1 - t)));
    final c2 = Offset(size.width * (0.80 - 0.14 * t), size.height * (0.30 + 0.10 * t));
    final c3 = Offset(size.width * (0.55 + 0.08 * (1 - t)), size.height * (0.78 - 0.10 * t));

    canvas.drawCircle(c1, r1, paint1);
    canvas.drawCircle(c2, r2, paint2);
    canvas.drawCircle(c3, r3, paint3);
  }

  @override
  bool shouldRepaint(covariant _BlobsPainter oldDelegate) => oldDelegate.t != t;
}
