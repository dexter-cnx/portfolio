import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String number;
  final String title;

  const SectionHeader({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$number. ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accent,
                fontFamily: 'JetBrains Mono',
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 1,
            color: AppTheme.textMuted.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}
