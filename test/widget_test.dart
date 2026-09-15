import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:syed_shayan_app/app.dart';
import 'package:syed_shayan_app/features/events/data/events_repository.dart';
import 'package:syed_shayan_app/features/events/domain/published_event.dart';

void main() {
  testWidgets('renders redesigned homepage sections', (tester) async {
    tester.view.physicalSize = const Size(400, 592);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      SyedShayanApp(eventsRepository: _FakeEventsRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('SyedShayan.com'), findsOneWidget);
    expect(
        find.text(
            'Shaping Policy\nResources, Governance\nand National Direction'),
        findsOneWidget);
    expect(find.text('Media & Research Hub'), findsOneWidget);
  });
}

class _FakeEventsRepository implements EventsRepository {
  @override
  Future<List<PublishedEvent>> fetchPublishedEvents() async {
    return const [
      PublishedEvent(
        id: '260',
        title: 'Bombay was handed over to the East India Company',
        titleUr: '',
        summary:
            'On March 27 1668, the seven islands of Bombay were handed over to the East India Company and became a turning point in the city\'s development.',
        year: '1668',
        eventDate: '1668-03-27',
        category: 'history',
        imageUrl: 'Images/otd-27-mar.jpeg',
        status: 'published',
      ),
    ];
  }
}
