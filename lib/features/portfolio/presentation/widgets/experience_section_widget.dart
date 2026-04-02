import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_header.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

class ExperienceSectionWidget extends StatefulWidget {
  final List<Experience> experience;

  const ExperienceSectionWidget({super.key, required this.experience});

  @override
  State<ExperienceSectionWidget> createState() => _ExperienceSectionWidgetState();
}

class _ExperienceSectionWidgetState extends State<ExperienceSectionWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.experience.isEmpty) return const SizedBox.shrink();

    return SectionWrapper(
      id: 'experience',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(number: '02', title: "exp_title".tr()),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: _buildCompanyTabs(),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildExperienceDetail(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyTabs() {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.experience.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == _selectedIndex;

        return InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isSelected ? AppTheme.accent : AppTheme.textMuted.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              color: isSelected ? AppTheme.accent.withValues(alpha: 0.05) : Colors.transparent,
            ),
            child: Text(
              item.company,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? AppTheme.accent : AppTheme.textMuted,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExperienceDetail() {
    final item = widget.experience[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Text(
          item.period,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.textMuted,
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
        ...item.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.play_arrow,
                      size: 12,
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
            )),
        if (item.tech.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildTechWrap(context, item.tech),
        ],
      ],
    );
  }

  Widget _buildTechWrap(BuildContext context, List<String> techs) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: techs
          .map((tech) => Chip(
                avatar: Icon(
                  _getIconForSkill(tech),
                  size: 14,
                  color: AppTheme.accent,
                ),
                label: Text(
                  tech,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontFamily: 'JetBrains Mono',
                      ),
                ),
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: AppTheme.accent, width: 1.0),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ))
          .toList(),
    );
  }

  IconData _getIconForSkill(String skill) {
    final s = skill.toLowerCase();
    if (s.contains('flutter')) return Icons.flutter_dash;
    if (s.contains('dart')) return Icons.code;
    if (s.contains('firebase')) return Icons.local_fire_department;
    if (s.contains('api') || s.contains('rest')) return Icons.api;
    if (s.contains('architecture')) return Icons.architecture;
    if (s.contains('ui') || s.contains('ux') || s.contains('design')) return Icons.design_services;
    if (s.contains('c++') || s.contains('c ') || s == 'c') return Icons.data_object;
    if (s.contains('python')) return Icons.terminal;
    if (s.contains('unity') || s.contains('game') || s.contains('cocos')) return Icons.videogame_asset;
    if (s.contains('java') || s.contains('j2me')) return Icons.coffee;
    if (s.contains('sql') || s.contains('db') || s.contains('database')) return Icons.storage;
    if (s.contains('github') || s.contains('git')) return Icons.merge;
    if (s.contains('javascript') || s.contains('js')) return Icons.javascript;
    return Icons.developer_mode;
  }
}
