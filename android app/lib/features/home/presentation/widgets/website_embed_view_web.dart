import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class WebsiteEmbedView extends StatefulWidget {
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
  State<WebsiteEmbedView> createState() => _WebsiteEmbedViewState();
}

class _WebsiteEmbedViewState extends State<WebsiteEmbedView> {
  late final String _viewType;
  late final html.DivElement _host;
  late final html.IFrameElement _iframe;

  @override
  void initState() {
    super.initState();
    _viewType = 'syed-shayan-iframe-${DateTime.now().microsecondsSinceEpoch}';
    _host = html.DivElement()
      ..style.position = 'relative'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.overflow = 'hidden'
      ..style.pointerEvents = 'auto';
    _iframe = html.IFrameElement()
      ..style.border = '0'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.right = '0'
      ..style.bottom = '0'
      ..style.left = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.display = 'block'
      ..style.pointerEvents = 'auto'
      ..style.zIndex = '10'
      ..style.backgroundColor = '#ffffff'
      ..allow =
          'fullscreen; geolocation; microphone; camera; clipboard-read; clipboard-write'
      ..src = widget.url;

    _host.append(_iframe);
    _iframe.onLoad.listen((_) => widget.onLoadFinished());
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (_) => _host);
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onLoadStarted());
  }

  @override
  void didUpdateWidget(covariant WebsiteEmbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url ||
        oldWidget.reloadToken != widget.reloadToken) {
      widget.onLoadStarted();
      _iframe.src = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
