import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/project_selection/domain/entities/portfolio_project_config.dart';

void main() {
  test('returns default config for an unconfigured repository', () {
    const config = ProjectSelectionConfig();

    final project = config.forRepository(42);

    expect(project.repositoryId, 42);
    expect(project.visible, isFalse);
    expect(project.featured, isFalse);
    expect(project.includeInPdf, isFalse);
  });

  test('replace updates one repository without duplicating it', () {
    const initial = ProjectSelectionConfig(
      projects: <PortfolioProjectConfig>[
        PortfolioProjectConfig(repositoryId: 1, visible: true),
      ],
    );

    final updated = initial.replace(
      const PortfolioProjectConfig(
        repositoryId: 1,
        visible: true,
        featured: true,
      ),
    );

    expect(updated.projects, hasLength(1));
    expect(updated.projects.single.featured, isTrue);
  });

  test('serializes editorial project fields', () {
    const project = PortfolioProjectConfig(
      repositoryId: 7,
      visible: true,
      featured: true,
      includeInPdf: true,
      sortOrder: 3,
      titleOverride: 'Package title',
      summaryOverride: 'Portfolio summary',
    );

    final restored = PortfolioProjectConfig.fromJson(project.toJson());

    expect(restored.repositoryId, 7);
    expect(restored.visible, isTrue);
    expect(restored.featured, isTrue);
    expect(restored.includeInPdf, isTrue);
    expect(restored.sortOrder, 3);
    expect(restored.titleOverride, 'Package title');
    expect(restored.summaryOverride, 'Portfolio summary');
  });

  test('project selection config round-trips through json maps', () {
    final updatedAt = DateTime.utc(2026, 8, 27, 8, 30);
    final config = ProjectSelectionConfig(
      updatedAt: updatedAt,
      projects: const <PortfolioProjectConfig>[
        PortfolioProjectConfig(
          repositoryId: 99,
          visible: true,
          featured: true,
          includeInPdf: true,
          sortOrder: 2,
          titleOverride: 'dxtr_box',
          summaryOverride: 'Fast local data layer',
        ),
      ],
    );

    final restored = ProjectSelectionConfig.fromJson(config.toJson());

    expect(restored.updatedAt, updatedAt);
    expect(restored.projects, hasLength(1));
    expect(restored.projects.single.repositoryId, 99);
    expect(restored.projects.single.visible, isTrue);
    expect(restored.projects.single.featured, isTrue);
    expect(restored.projects.single.includeInPdf, isTrue);
    expect(restored.projects.single.sortOrder, 2);
    expect(restored.projects.single.titleOverride, 'dxtr_box');
    expect(restored.projects.single.summaryOverride, 'Fast local data layer');
  });

  test('rejects project config without a numeric repository id', () {
    expect(
      () => PortfolioProjectConfig.fromJson(const <String, Object?>{}),
      throwsFormatException,
    );
  });
}
