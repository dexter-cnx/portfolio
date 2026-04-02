import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';

class ContactSectionWidget extends StatelessWidget {
  final Contact contact;
  final List<SocialLink> socialLinks;
  final Function(String url) onCtaTap;

  const ContactSectionWidget({
    super.key,
    required this.contact,
    required this.onCtaTap,
    this.socialLinks = const [],
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

          // Social Links
          if (socialLinks.isNotEmpty) ...[
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: socialLinks.map((link) => _SocialLinkChip(
                label: link.label,
                onTap: () => onCtaTap(link.url),
              )).toList(),
            ),
          ],

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

class _SocialLinkChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SocialLinkChip({required this.label, required this.onTap});

  @override
  State<_SocialLinkChip> createState() => _SocialLinkChipState();
}

class _SocialLinkChipState extends State<_SocialLinkChip> {
  bool _isHovered = false;

  IconData _iconForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('github')) return Icons.code;
    if (l.contains('linkedin')) return Icons.work_outline;
    if (l.contains('twitter') || l == 'x') return Icons.alternate_email;
    if (l.contains('email') || l.contains('mail')) return Icons.email_outlined;
    if (l.contains('game') || l.contains('play') || l.contains('เกม')) return Icons.videogame_asset_outlined;
    if (l.contains('phone') || l.contains('โทร')) return Icons.phone_iphone_outlined;
    if (l.contains('line')) return Icons.chat_bubble_outline;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHovered
                  ? AppTheme.accent
                  : AppTheme.textMuted.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(4),
            color: _isHovered ? AppTheme.accent.withValues(alpha: 0.08) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForLabel(widget.label),
                size: 18,
                color: _isHovered ? AppTheme.accent : AppTheme.textMuted,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _isHovered ? AppTheme.accent : AppTheme.textMuted,
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
