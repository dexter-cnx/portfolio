import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';
import 'scroll_reveal.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: context.sectionPaddingH,
        vertical: 140,
      ),
      child: ScrollReveal(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: GlassContainer(
              blur: 14,
              backgroundOpacity: 0.05,
              borderOpacity: 0.13,
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.06),
                  blurRadius: 60,
                  spreadRadius: 0,
                ),
              ],
              child: Column(
                children: [
                  // ── Eyebrow ─────────────────────────────────────────
                  Text(
                    'contact_eyebrow'.tr(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.accent,
                          fontFamily: 'JetBrains Mono',
                          letterSpacing: 1.5,
                        ),
                  ),

                  const SizedBox(height: 20),

                  // ── Title ────────────────────────────────────────────
                  Text(
                    contact.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              context.isMobile ? 36.0 : 52.0,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // ── Body copy ─────────────────────────────────────────
                  Text(
                    contact.body,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textMuted,
                          fontSize: 17,
                          height: 1.65,
                        ),
                  ),

                  const SizedBox(height: 44),

                  // ── Primary CTA ───────────────────────────────────────
                  OutlinedButton(
                    onPressed: () => onCtaTap(contact.ctaUrl),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: Text(contact.ctaLabel),
                  ),

                  // ── Optional contact details ──────────────────────────
                  if (contact.phone != null || contact.lineId != null) ...[
                    const SizedBox(height: 36),
                    if (contact.phone != null)
                      _ContactRow(
                        icon: Icons.phone_outlined,
                        label: contact.phone!,
                        onTap: () => onCtaTap('tel:${contact.phone}'),
                      ),
                    if (contact.lineId != null)
                      _ContactRow(
                        icon: Icons.chat_bubble_outline,
                        label: 'Line: ${contact.lineId}',
                        onTap: () => onCtaTap(
                            'https://line.me/ti/p/~${contact.lineId}'),
                      ),
                  ],

                  // ── Social links ──────────────────────────────────────
                  if (socialLinks.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    const _Divider(),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: socialLinks
                          .map((l) => _SocialChip(
                                link: l,
                                onTap: () => onCtaTap(l.url),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Divider ────────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}

// ── Contact row item ───────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.accent, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

// ── Social chip ────────────────────────────────────────────────────────────────

class _SocialChip extends StatefulWidget {
  final SocialLink link;
  final VoidCallback onTap;

  const _SocialChip({required this.link, required this.onTap});

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  IconData _iconForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('github')) return Icons.code;
    if (l.contains('linkedin')) return Icons.work_outline;
    if (l.contains('twitter') || l == 'x') return Icons.alternate_email;
    if (l.contains('email') || l.contains('mail')) return Icons.email_outlined;
    if (l.contains('game') || l.contains('play')) {
      return Icons.videogame_asset_outlined;
    }
    if (l.contains('phone') || l.contains('โทร')) {
      return Icons.phone_iphone_outlined;
    }
    if (l.contains('line')) return Icons.chat_bubble_outline;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered
                  ? AppTheme.accent
                  : AppTheme.textMuted.withValues(alpha: 0.25),
            ),
            borderRadius: BorderRadius.circular(8),
            color: _hovered
                ? AppTheme.accent.withValues(alpha: 0.09)
                : Colors.transparent,
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.12),
                      blurRadius: 16,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForLabel(widget.link.label),
                size: 16,
                color: _hovered ? AppTheme.accent : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                widget.link.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color:
                          _hovered ? AppTheme.accent : AppTheme.textMuted,
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
