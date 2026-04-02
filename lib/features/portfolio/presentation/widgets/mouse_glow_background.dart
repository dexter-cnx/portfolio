import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class MouseGlowBackground extends StatefulWidget {
  final Widget child;

  const MouseGlowBackground({super.key, required this.child});

  @override
  State<MouseGlowBackground> createState() => _MouseGlowBackgroundState();
}

class _MouseGlowBackgroundState extends State<MouseGlowBackground> {
  Offset _mousePosition = Offset.zero;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Stack(
        children: [
          // Background Color
          Container(color: AppTheme.background),
          
          // Glow Effect
          if (_isHovering)
            Positioned(
              left: _mousePosition.dx - 300,
              top: _mousePosition.dy - 300,
              child: IgnorePointer(
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accent.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            
          // Main Content
          widget.child,
        ],
      ),
    );
  }
}
