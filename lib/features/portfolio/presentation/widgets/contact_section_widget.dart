import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';

class ContactSectionWidget extends StatelessWidget {
  final Contact contact;
  final Function(String url) onCtaTap;

  const ContactSectionWidget({
    super.key,
    required this.contact,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      id: 'contact',
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 150),
      child: Column(
        children: [
          Text(
            'contact_eyebrow'.tr(),
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 18,
                    height: 1.6,
                  ),
            ),
          ),
          const SizedBox(height: 50),

          // Action Button
          OutlinedButton(
            onPressed: () => onCtaTap(contact.ctaUrl),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: Text(contact.ctaLabel),
          ),
          
          const SizedBox(height: 60),

          // Additional Contact Info
          if (contact.phone != null || contact.lineId != null)
            Column(
              children: [
                if (contact.phone != null)
                  _ContactInfoItem(
                    icon: Icons.phone,
                    label: contact.phone!,
                    onTap: () => onCtaTap('tel:${contact.phone}'),
                  ),
                if (contact.lineId != null)
                  _ContactInfoItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Line ID: ${contact.lineId}',
                    onTap: () => onCtaTap('https://line.me/ti/p/~${contact.lineId}'),
                  ),
              ],
            ),

          const SizedBox(height: 150),
          Text(
            'footer_built_by'.tr(),
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

class _ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactInfoItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.accent, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontFamily: 'JetBrains Mono',
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
