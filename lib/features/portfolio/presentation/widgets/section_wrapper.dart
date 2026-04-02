import 'package:flutter/material.dart';

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final String? id;
  final EdgeInsetsGeometry? padding;

  const SectionWrapper({super.key, required this.child, this.id, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: id != null ? ValueKey(id) : null,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: child,
        ),
      ),
    );
  }
}
