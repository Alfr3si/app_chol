import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatefulWidget {
  final String assetPath;
  final double size;
  final VoidCallback onTap;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const AnimatedFloatingButton({
    super.key,
    required this.assetPath,
    this.size = 120,
    required this.onTap,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  State<AnimatedFloatingButton> createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget buttonWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Image.asset(
            widget.assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    // Si se definen propiedades de posicionamiento, lo envolvemos en un Positioned automáticamente
    if (widget.top != null || widget.bottom != null || widget.left != null || widget.right != null) {
      return Positioned(
        top: widget.top,
        bottom: widget.bottom,
        left: widget.left,
        right: widget.right,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
