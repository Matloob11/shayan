import 'package:flutter/material.dart';

class WebsiteEmbedView extends StatelessWidget {
  const WebsiteEmbedView({
    required this.url,
    required this.reloadToken,
    required this.onLoadStarted,
    required this.onLoadFinished,
    super.key,
  });

  final String url;
  final int reloadToken;
  final VoidCallback onLoadStarted;
  final VoidCallback onLoadFinished;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
