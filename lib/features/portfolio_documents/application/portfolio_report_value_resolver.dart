final class PortfolioReportValueResolver {
  const PortfolioReportValueResolver();

  dynamic resolve(String? expression, Map<String, dynamic> data) {
    if (expression == null) return '';

    final trimmed = expression.trim();
    if (trimmed.isEmpty) return '';

    final hasOpeningDelimiter = trimmed.contains('{{');
    final hasClosingDelimiter = trimmed.contains('}}');
    if (hasOpeningDelimiter || hasClosingDelimiter) {
      final isCompleteWrapper =
          trimmed.startsWith('{{') && trimmed.endsWith('}}');
      if (!isCompleteWrapper) return '';
    }

    final path = trimmed.startsWith('{{') && trimmed.endsWith('}}')
        ? trimmed.substring(2, trimmed.length - 2).trim()
        : trimmed;
    if (path.isEmpty || path.contains('{{') || path.contains('}}')) return '';

    dynamic current = data;
    for (final segment in path.split('.')) {
      if (current is Map<String, dynamic> && current.containsKey(segment)) {
        current = current[segment];
        continue;
      }
      if (current is Map && current.containsKey(segment)) {
        current = current[segment];
        continue;
      }
      if (current is List) {
        final index = int.tryParse(segment);
        if (index == null || index < 0 || index >= current.length) return '';
        current = current[index];
        continue;
      }
      return '';
    }

    return current ?? '';
  }
}
