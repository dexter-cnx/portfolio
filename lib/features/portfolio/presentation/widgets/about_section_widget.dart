import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(number: '01', title: 'About Me'),
          const SizedBox(height: 40),
          if (ResponsiveLayout.isDesktop(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildTextContent(context)),
                const SizedBox(width: 50),
                Expanded(flex: 2, child: _buildProfileImage(context)),
              ],
            )
          else
            Column(
              children: [
                _buildTextContent(context),
                const SizedBox(height: 50),
                _buildProfileImage(context),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...about.paragraphs.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                p,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )),
        const SizedBox(height: 20),
        Text(
          "Here are a few technologies I've been working with recently:",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMuted,
              ),
        ),
        const SizedBox(height: 20),
        _buildSkillsGrid(context),
      ],
    );
  }

  Widget _buildSkillsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 5,
      children: about.skills
          .map((skill) => Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    size: 12,
                    color: AppTheme.accent,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    skill,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ],
              ))
          .toList(),
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
}

class _ImageWithFrame extends StatefulWidget {
  const _ImageWithFrame();

  @override
  State<_ImageWithFrame> createState() => _ImageWithFrameState();
}

class _ImageWithFrameState extends State<_ImageWithFrame> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..translate(_isHovered ? -4.0 : 0.0, _isHovered ? -4.0 : 0.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Frame
            Positioned(
              left: 20,
              top: 20,
              right: -20,
              bottom: -20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.accent, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                transform: Matrix4.identity()
                  ..translate(_isHovered ? 8.0 : 0.0, _isHovered ? 8.0 : 0.0),
              ),
            ),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isHovered ? 0 : 0.3,
                    child: Container(
                      color: AppTheme.accent,
                    ),
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
