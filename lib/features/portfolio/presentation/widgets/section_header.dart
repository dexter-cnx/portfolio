import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String number;
  final String title;
  final String? description;

  const SectionHeader({
    super.key,
    required this.number,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppTheme.metaText),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: AppTheme.textPrimary),
        ),
        if (description != null && description!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
        const SizedBox(height: 24),
        const Divider(height: 1, color: AppTheme.outline),
      ],
    );
  }
}
