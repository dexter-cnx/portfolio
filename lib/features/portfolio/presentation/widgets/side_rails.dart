import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';

class SocialRail extends StatelessWidget {
  final List<SocialLink> socials;
  final Function(String url) onLinkTap;

  const SocialRail({
    super.key,
    required this.socials,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...socials.map((link) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: IconButton(
                onPressed: () => onLinkTap(link.url),
                icon: Text(
                  link.label.substring(0, 2).toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontFamily: 'JetBrains Mono',
                      ),
                ),
                tooltip: link.label,
              ),
            )),
        const SizedBox(height: 20),
        Container(
          width: 1,
          height: 100,
          color: AppTheme.textMuted.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

class EmailRail extends StatelessWidget {
  final String email;
  final Function(String url) onEmailTap;

  const EmailRail({
    super.key,
    required this.email,
    required this.onEmailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RotatedBox(
            quarterTurns: 1,
            child: InkWell(
              onTap: () => onEmailTap('mailto:$email'),
              child: Text(
                email,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.textMuted,
                      letterSpacing: 2,
                      fontFamily: 'JetBrains Mono',
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 1,
          height: 100,
          color: AppTheme.textMuted.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
