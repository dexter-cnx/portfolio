import 'package:easy_localization/easy_localization.dart';
import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../models/portfolio_models.dart';
import 'section_header.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

class ExperienceSectionWidget extends StatefulWidget {
  final List<Experience> experience;

  const ExperienceSectionWidget({super.key, required this.experience});

  @override
  State<ExperienceSectionWidget> createState() =>
      _ExperienceSectionWidgetState();
}

class _ExperienceSectionWidgetState extends State<ExperienceSectionWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.experience.isEmpty) return const SizedBox.shrink();

    return SectionWrapper(
      id: 'experience',
      child: Cue.onScrollVisible(
        acts: const [Act.fadeIn(), Act.slideY(from: 0.06)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Actor(
              acts: const [Act.fadeIn(), Act.slideY(from: 0.08)],
              child: SectionHeader(number: '02', title: 'exp_title'.tr()),
            ),
            const SizedBox(height: 40),
            // Responsive: side tabs on desktop, top tabs on mobile
            ResponsiveLayout.isDesktop(context)
                ? _buildDesktopLayout(context)
                : _buildMobileLayout(context),
          ],
        ),
      ),
    );
  }

  // ── Desktop: vertical tab list on the left ────────────────────────────────

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 200, child: _buildCompanyTabs(context)),
        const SizedBox(width: 40),
        Expanded(child: _buildDetailPanel(context)),
      ],
    );
  }

  // ── Mobile: horizontal scrolling tab bar on top ───────────────────────────

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.experience.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final isSelected = i == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accent.withValues(alpha: 0.12)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accent
                          : AppTheme.textMuted.withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.experience[i].company,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected ? AppTheme.accent : AppTheme.textMuted,
                          fontFamily: 'JetBrains Mono',
                        ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        _buildDetailPanel(context),
      ],
    );
  }

  // ── Vertical tab column (desktop) ─────────────────────────────────────────

  Widget _buildCompanyTabs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.experience.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        final isSelected = i == _selectedIndex;

        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isSelected
                      ? AppTheme.accent
                      : AppTheme.textMuted.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              color: isSelected
                  ? AppTheme.accent.withValues(alpha: 0.07)
                  : Colors.transparent,
            ),
            child: Text(
              item.company,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? AppTheme.accent : AppTheme.textMuted,
                    fontFamily: 'JetBrains Mono',
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Experience detail panel (glassmorphism) ───────────────────────────────

  Widget _buildDetailPanel(BuildContext context) {
    final item = widget.experience[_selectedIndex];

    return Cue.onChange(
      value: _selectedIndex,
      fromCurrentValue: true,
      acts: const [
        Act.fadeIn(),
        Act.slideY(from: 0.04),
      ],
      child: GlassContainer(
        blur: 12,
        backgroundOpacity: 0.05,
        borderOpacity: 0.14,
        borderRadius: 14,
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title @ Company
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: item.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                  ),
                  TextSpan(
                    text: ' @ ${item.company}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.accent,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Period
            Text(
              item.period,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textMuted,
                    fontFamily: 'JetBrains Mono',
                  ),
            ),

            if (item.summary.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                item.summary,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textMuted,
                    ),
              ),
            ],

            const SizedBox(height: 24),

            // Bullet highlights
            ...item.highlights.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 13,
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        h,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tech stack chips
            if (item.tech.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildTechChips(context, item.tech),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTechChips(BuildContext context, List<String> techs) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: techs
          .map(
            (tech) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.08),
                border: Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.30)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconForSkill(tech),
                    size: 12,
                    color: AppTheme.accent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tech,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontFamily: 'JetBrains Mono',
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
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
