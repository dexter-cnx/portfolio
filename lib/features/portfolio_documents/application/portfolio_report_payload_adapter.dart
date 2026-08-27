import '../domain/entities/portfolio_document_data.dart';

/// Converts normalized portfolio document data into a report-engine-friendly
/// payload that can be resolved with dotted paths such as `profile.name` or
/// `projects.0.name`.
final class PortfolioReportPayloadAdapter {
  const PortfolioReportPayloadAdapter();

  Map<String, dynamic> adapt(PortfolioDocumentData data) {
    return _normalizeMap(data.toJson());
  }

  Map<String, dynamic> _normalizeMap(Map<String, Object?> source) {
    return <String, dynamic>{
      for (final entry in source.entries) entry.key: _normalize(entry.value),
    };
  }

  dynamic _normalize(Object? value) {
    if (value is Map<String, Object?>) return _normalizeMap(value);
    if (value is Map) {
      return <String, dynamic>{
        for (final entry in value.entries)
          entry.key.toString(): _normalize(entry.value),
      };
    }
    if (value is List) {
      return value.map(_normalize).toList(growable: false);
    }
    return value;
  }
}
