import 'package:easy_localization/easy_localization.dart';
import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../models/portfolio_models.dart';
import 'portfolio_motion.dart';
import 'section_header.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

class AboutSectionWidget extends StatelessWidget {
  final About about;

  const AboutSectionWidget({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      id: 'about',
      child: Cue.onScrollVisible(
        acts: const [
          Act.fadeIn(),
          Act.slideY(from: kSectionRevealSlideFrom),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Actor(
              acts: const [
                Act.fadeIn(),
                Act.slideY(from: kSectionHeaderSlideFrom),
              ],
              child: SectionHeader(number: '01', title: 'nav_about'.tr()),
            ),
            const SizedBox(height: 48),
            if (ResponsiveLayout.isDesktop(context))
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildTextContent(context)),
                  const SizedBox(width: 56),
                  Expanded(
                    flex: 2,
                    child: Actor(
                      delay: kAboutProfileDelay,
                      acts: const [Act.fadeIn(), Act.scale(from: 0.92)],
                      child: _buildProfileImage(context),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildTextContent(context),
                  const SizedBox(height: 48),
                  Actor(
                    delay: kAboutProfileDelay,
                    acts: const [Act.fadeIn(), Act.scale(from: 0.92)],
                    child: _buildProfileImage(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...about.paragraphs.asMap().entries.map(
          (entry) => Actor(
            delay: staggeredDelay(entry.key, step: kAboutParagraphStagger),
            acts: const [
              Act.fadeIn(),
              Act.slideY(from: kContentRevealSlideFrom),
            ],
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                entry.value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Actor(
          delay: staggeredDelay(
            about.paragraphs.length,
            step: kAboutParagraphStagger,
            base: kAboutSkillsHeaderDelay,
          ),
          acts: const [
            Act.fadeIn(),
            Act.slideY(from: kContentRevealSlideFrom),
          ],
          child: Text(
            'about_skills_header'.tr(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.accent,
              fontFamily: 'JetBrains Mono',
              letterSpacing: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Glassmorphism skill grid ─────────────────────────────
        _buildSkillGrid(context),
      ],
    );
  }

  /// Skills displayed as a staggered grid of glass chips.
  Widget _buildSkillGrid(BuildContext context) {
    final cols = context.skillGridColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: about.skills.asMap().entries.map((entry) {
            final i = entry.key;
            final skill = entry.value;
            return SizedBox(
              width: (constraints.maxWidth - (10 * (cols - 1))) / cols,
              child: Actor(
                delay: staggeredDelay(i, step: kAboutSkillChipStagger),
                acts: const [
                  Act.fadeIn(),
                  Act.slideX(from: -kSectionHeaderSlideFrom),
                ],
                child: _GlassSkillChip(
                  skill: skill,
                  icon: _iconForSkill(skill),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: const _ImageWithFrame(),
      ),
    );
  }

  IconData _iconForSkill(String skill) {
    final s = skill.toLowerCase();
    if (s.contains('flutter')) return Icons.flutter_dash;
    if (s.contains('dart')) return Icons.code;
    if (s.contains('firebase')) return Icons.local_fire_department;
    if (s.contains('api') || s.contains('rest')) return Icons.api;
    if (s.contains('architecture')) return Icons.architecture;
    if (s.contains('ui') || s.contains('ux') || s.contains('design')) {
      return Icons.design_services;
    }
    if (s.contains('c++') || s == 'c') return Icons.data_object;
    if (s.contains('python')) return Icons.terminal;
    if (s.contains('unity') || s.contains('game') || s.contains('cocos')) {
      return Icons.videogame_asset;
    }
    if (s.contains('java') || s.contains('j2me')) return Icons.coffee;
    if (s.contains('sql') || s.contains('db') || s.contains('database')) {
      return Icons.storage;
    }
    if (s.contains('github') || s.contains('git')) return Icons.merge;
    if (s.contains('javascript') || s.contains('js')) return Icons.javascript;
    return Icons.developer_mode;
  }
}

// ── Glass Skill Chip ──────────────────────────────────────────────────────────

class _GlassSkillChip extends StatefulWidget {
  final String skill;
  final IconData icon;

  const _GlassSkillChip({required this.skill, required this.icon});

  @override
  State<_GlassSkillChip> createState() => _GlassSkillChipState();
}

class _GlassSkillChipState extends State<_GlassSkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GlassContainer(
          blur: _hovered ? 16 : 10,
          backgroundOpacity: _hovered ? 0.10 : 0.05,
          borderOpacity: _hovered ? 0.30 : 0.14,
          borderRadius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          tintColor: _hovered ? AppTheme.accent : Colors.white,
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ]
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _hovered ? AppTheme.accent : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.skill,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: _hovered ? AppTheme.accent : AppTheme.textPrimary,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile image with animated frame ─────────────────────────────────────────

class _ImageWithFrame extends StatefulWidget {
  const _ImageWithFrame();

  @override
  State<_ImageWithFrame> createState() => _ImageWithFrameState();
}

class _ImageWithFrameState extends State<_ImageWithFrame> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
          _hovered ? -5.0 : 0.0,
          _hovered ? -5.0 : 0.0,
          0.0,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Offset accent border frame
            Positioned(
              left: 18,
              top: 18,
              right: -18,
              bottom: -18,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.accent.withValues(
                      alpha: _hovered ? 1.0 : 0.7,
                    ),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: AppTheme.accent.withValues(alpha: 0.2),
                            blurRadius: 24,
                          ),
                        ]
                      : [],
                ),
                transform: Matrix4.translationValues(
                  _hovered ? 10.0 : 0.0,
                  _hovered ? 10.0 : 0.0,
                  0.0,
                ),
              ),
            ),
            // Profile photo
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Image.asset('assets/images/profile.png', fit: BoxFit.cover),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _hovered ? 0.0 : 0.25,
                    child: Container(color: AppTheme.accent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
