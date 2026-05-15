import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/published_event.dart';

abstract class EventsRepository {
  Future<List<PublishedEvent>> fetchPublishedEvents();
}

class RemoteEventsRepository implements EventsRepository {
  const RemoteEventsRepository();

  static final Uri _eventsUri = Uri.parse(
    'https://syedshayan.com/admin_api.php?action=get_events&status=published',
  );

  @override
  Future<List<PublishedEvent>> fetchPublishedEvents() async {
    final response = await http.get(_eventsUri);
    if (response.statusCode != 200) {
      throw Exception('Events API returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected events API payload.');
    }

    final isSuccess = decoded['success'] == true;
    final events = decoded['events'];
    if (!isSuccess || events is! List) {
      throw const FormatException(
          'Events API did not return a valid events list.');
    }

    return events
        .whereType<Map>()
        .map(
          (item) => PublishedEvent.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);
  }
}
