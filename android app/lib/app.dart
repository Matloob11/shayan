import 'package:flutter/material.dart';

import 'features/events/data/events_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

class SyedShayanApp extends StatelessWidget {
  const SyedShayanApp({
    super.key,
    EventsRepository? eventsRepository,
  }) : eventsRepository = eventsRepository ?? const RemoteEventsRepository();

  final EventsRepository eventsRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyedShayan.com',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: HomeScreen(eventsRepository: eventsRepository),
    );
  }
}
