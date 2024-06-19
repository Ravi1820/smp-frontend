import 'package:flutter/material.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.grey[300]!, Colors.grey[100]!],
      ),
      direction: ShimmerDirection.ltr,
      child: Container(
        width: 200,
        height: 100,
        color: Colors.grey[300],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Shimmer extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  final ShimmerDirection direction;

  Shimmer({
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        if (direction == ShimmerDirection.ltr) {
          return gradient.createShader(Rect.fromLTWH(0, 0, bounds.width * 0.75, bounds.height));
        } else {
          return gradient.createShader(Rect.fromLTWH(bounds.width, 0, -bounds.width * 0.75, bounds.height));
        }
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}

enum ShimmerDirection {
  ltr,
  rtl,
}