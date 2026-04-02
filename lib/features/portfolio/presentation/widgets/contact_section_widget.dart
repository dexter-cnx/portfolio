import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';

class ContactSectionWidget extends StatelessWidget {
  final Contact contact;

  const ContactSectionWidget({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      id: 'contact',
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 150),
      child: Column(
        children: [
          Text(
            '04. What\'s Next?',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.accent,
                  fontFamily: 'JetBrains Mono',
                ),
          ),
          const SizedBox(height: 20),
          Text(
            contact.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.sizeOf(context).width < 768 ? 40 : 60,
                ),
          ),
          const SizedBox(height: 25),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              contact.body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 50),
          OutlinedButton(
            onPressed: () {}, // Link to contact.ctaUrl
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text(contact.ctaLabel),
          ),
          const SizedBox(height: 150),
          Text(
            'Built by [Your Name] with Flutter',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textMuted,
                  fontFamily: 'JetBrains Mono',
                ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
