class PublishedEvent {
  const PublishedEvent({
    required this.id,
    required this.title,
    required this.titleUr,
    required this.summary,
    required this.year,
    required this.eventDate,
    required this.category,
    required this.imageUrl,
    required this.status,
  });

  final String id;
  final String title;
  final String titleUr;
  final String summary;
  final String year;
  final String eventDate;
  final String? category;
  final String? imageUrl;
  final String status;

  factory PublishedEvent.fromJson(Map<String, dynamic> json) {
    return PublishedEvent(
      id: _readString(json['id']),
      title: _pickFirstValue([
        json['title_en'],
        json['title'],
        json['title_ur'],
      ]),
      titleUr: _readString(json['title_ur']),
      summary: _pickFirstValue([
        json['summary_en'],
        json['summary_ur'],
      ]),
      year: _readString(json['year']),
      eventDate: _readString(json['event_date']),
      category: _nullableString(json['category']),
      imageUrl: _nullableString(json['image_url']),
      status: _readString(json['status']),
    );
  }

  String get displayTitle => title.isNotEmpty ? title : titleUr;

  String get cleanSummary {
    final withoutImages = summary.replaceAll(RegExp(r'\[img:[^\]]+\]'), ' ');
    final withoutHtml = withoutImages.replaceAll(RegExp(r'<[^>]*>'), ' ');
    return withoutHtml.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String summaryPreview([int maxLength = 220]) {
    final normalized = cleanSummary;
    if (normalized.length <= maxLength) {
      return normalized;
    }

    return '${normalized.substring(0, maxLength).trimRight()}...';
  }

  String get dateLabel {
    final parsedDate = DateTime.tryParse(eventDate);
    if (parsedDate == null) {
      return year.trim().isNotEmpty ? year.trim() : eventDate;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}';
  }

  Uri? get imageUri {
    final value = imageUrl?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Uri.tryParse(value);
    }

    return Uri.tryParse(
        'https://syedshayan.com/${value.replaceFirst(RegExp(r'^/+'), '')}');
  }

  static String _pickFirstValue(List<Object?> values) {
    for (final value in values) {
      final text = _readString(value).trim();
      if (text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }

  static String _readString(Object? value) => value?.toString() ?? '';

  static String? _nullableString(Object? value) {
    final text = _readString(value).trim();
    return text.isEmpty ? null : text;
  }
}
