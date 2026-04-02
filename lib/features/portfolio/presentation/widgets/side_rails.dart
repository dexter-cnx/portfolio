import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';

class SocialRail extends StatelessWidget {
  final List<SocialLink> socials;

  const SocialRail({super.key, required this.socials});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...socials.map((link) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RotatedBox(
                quarterTurns: 0,
                child: IconButton(
                  onPressed: () {}, // Link functionality later
                  icon: Text(
                    link.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                  ),
                  tooltip: link.url,
                ),
              ),
            )),
        const SizedBox(height: 20),
        Container(
          width: 1,
          height: 100,
          color: AppTheme.textMuted.withOpacity(0.3),
        ),
      ],
    );
  }
}

class EmailRail extends StatelessWidget {
  final String email;

  const EmailRail({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              email,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textMuted,
                    letterSpacing: 2,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 1,
          height: 100,
          color: AppTheme.textMuted.withOpacity(0.3),
        ),
      ],
    );
  }
}
