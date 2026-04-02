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
          const SectionHeader(number: '02', title: "Where I've Worked"),
          const SizedBox(height: 40),
          if (ResponsiveLayout.isDesktop(context))
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
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildCompanyTabs(),
                ),
                const SizedBox(height: 30),
                _buildExperienceDetail(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCompanyTabs() {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Flex(
      direction: isDesktop ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: widget.experience.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == _selectedIndex;

        return InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                left: isDesktop
                    ? BorderSide(
                        color: isSelected ? AppTheme.accent : AppTheme.textMuted.withOpacity(0.1),
                        width: 2,
                      )
                    : BorderSide.none,
                bottom: !isDesktop
                    ? BorderSide(
                        color: isSelected ? AppTheme.accent : AppTheme.textMuted.withOpacity(0.1),
                        width: 2,
                      )
                    : BorderSide.none,
              ),
              color: isSelected ? AppTheme.accent.withOpacity(0.05) : Colors.transparent,
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
      ],
    );
  }
}
