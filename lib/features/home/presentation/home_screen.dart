import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_fonts.dart';
import '../../events/data/events_repository.dart';
import 'widgets/website_embed_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.eventsRepository,
    super.key,
  });

  final EventsRepository eventsRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewController? _controller;

  var _selectedIndex = 0;
  var _progress = 0;
  var _webReloadToken = 0;
  var _canGoBack = false;
  var _canGoForward = false;

  static final _tabs = <_WebsiteTab>[
    _WebsiteTab(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      url: Uri.parse('https://syedshayan.com/'),
    ),
    _WebsiteTab(
      label: 'Portal',
      icon: Icons.language_outlined,
      selectedIcon: Icons.language_rounded,
      url: Uri.parse('https://syedshayan.com/web-portal.php'),
    ),
    _WebsiteTab(
      label: 'News',
      icon: Icons.article_outlined,
      selectedIcon: Icons.article_rounded,
      url: Uri.parse('https://syedshayan.com/news.php'),
    ),
    _WebsiteTab(
      label: 'Research',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
      url: Uri.parse('https://syedshayan.com/research-report.php'),
    ),
    _WebsiteTab(
      label: 'Contact',
      icon: Icons.call_outlined,
      selectedIcon: Icons.call_rounded,
      url: Uri.parse('https://syedshayan.com/contact.php'),
    ),
  ];

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              if (mounted) {
                setState(() => _progress = progress);
              }
            },
            onPageFinished: (_) => _refreshNavigationState(),
          ),
        )
        ..loadRequest(_tabs[_selectedIndex].url);
    }
  }

  Future<void> _refreshNavigationState() async {
    final controller = _controller;
    if (controller == null) {
      return;
    }

    final canGoBack = await controller.canGoBack();
    final canGoForward = await controller.canGoForward();
    if (!mounted) {
      return;
    }
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
      _progress = 100;
    });
  }

  Future<void> _selectTab(int index) async {
    if (_selectedIndex == index) {
      await _reloadCurrentPage();
      return;
    }

    setState(() {
      _selectedIndex = index;
      _progress = 0;
    });

    if (kIsWeb) {
      setState(() => _webReloadToken++);
      return;
    }

    await _controller?.loadRequest(_tabs[index].url);
  }

  Future<void> _reloadCurrentPage() async {
    setState(() => _progress = 0);
    if (kIsWeb) {
      setState(() => _webReloadToken++);
      return;
    }
    await _controller?.reload();
  }

  void _markWebLoadStarted() {
    if (!mounted) {
      return;
    }
    setState(() => _progress = 0);
  }

  void _markWebLoadFinished() {
    if (!mounted) {
      return;
    }
    setState(() => _progress = 100);
  }

  @override
  Widget build(BuildContext context) {
    final useRail = MediaQuery.sizeOf(context).width >= 820;
    final selectedTab = _tabs[_selectedIndex];
    final controller = _controller;
    final webContent = WebsiteEmbedView(
      key: ValueKey('${selectedTab.url}-$_webReloadToken'),
      url: selectedTab.url.toString(),
      reloadToken: _webReloadToken,
      onLoadStarted: _markWebLoadStarted,
      onLoadFinished: _markWebLoadFinished,
    );
    final body = Stack(
      children: [
        Positioned.fill(
          child: kIsWeb || controller == null
              ? webContent
              : WebViewWidget(controller: controller),
        ),
        if (_progress < 100) const _LoadingOverlay(),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: useRail
          ? Row(
              children: [
                _WebsiteNavigationRail(
                  tabs: _tabs,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectTab,
                ),
                Expanded(child: body),
              ],
            )
          : Column(
              children: [
                Expanded(child: body),
                _WebsiteBottomNavigation(
                  tabs: _tabs,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectTab,
                ),
              ],
            ),
    );
  }
}

class _WebsiteTab {
  const _WebsiteTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Uri url;
}

class _WebsiteNavigationRail extends StatelessWidget {
  const _WebsiteNavigationRail({
    required this.tabs,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_WebsiteTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      minWidth: 92,
      groupAlignment: -0.86,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE8F0F6),
      selectedIconTheme: const IconThemeData(color: _AppColors.navy),
      unselectedIconTheme: const IconThemeData(color: _AppColors.muted),
      selectedLabelTextStyle: GoogleFonts.poppins(
        color: _AppColors.navy,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelTextStyle: GoogleFonts.poppins(
        color: _AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        for (final tab in tabs)
          NavigationRailDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.selectedIcon),
            label: Text(tab.label),
          ),
      ],
    );
  }
}

class _WebsiteBottomNavigation extends StatelessWidget {
  const _WebsiteBottomNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_WebsiteTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      height: 58,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE8F0F6),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        for (final tab in tabs)
          NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.selectedIcon, color: _AppColors.navy),
            label: tab.label,
          ),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Container(
            width: 240,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(color: const Color(0xFFE7ECF2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: _AppColors.gold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading',
                  style: GoogleFonts.poppins(
                    color: _AppColors.deepNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Please wait...',
                  style: GoogleFonts.poppins(
                    color: _AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppColors {
  const _AppColors._();

  static const navy = Color(0xFF043F6C);
  static const deepNavy = Color(0xFF052945);
  static const gold = Color(0xFFC59420);
  static const muted = Color(0xFF687482);
}
