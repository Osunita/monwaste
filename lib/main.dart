import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme.dart';
import 'features/expenses/expense_form_screen.dart';
import 'features/expenses/expense_list_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/monwaste_glance_widget.dart';
import 'features/home/next_month_screen.dart';
import 'features/home/widget_data_provider.dart';
import 'features/settings/settings_screen.dart';
import 'l10n/l10n.dart';
import 'shared/notifications.dart';
import 'shared/providers.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // ── Branch 0: Home ──────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'home/next-month',
                  builder: (context, state) => const NextMonthScreen(),
                ),
              ],
            ),
          ],
        ),
        // ── Branch 1: Expenses ──────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/expenses',
              builder: (context, state) => const ExpenseListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const ExpenseFormScreen(),
                ),
                GoRoute(
                  path: 'edit/:id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return ExpenseFormScreen(editId: id);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Settings lives outside the bottom-nav shell.
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

/// Shell widget that provides the bottom navigation bar.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          if (index == navigationShell.currentIndex) {
            // Pop to root of the current branch
            navigationShell.goBranch(index, initialLocation: true);
          } else {
            navigationShell.goBranch(index);
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: l10n.homeNextMonthLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            label: l10n.expensesTitle,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: MonwasteApp(),
    ),
  );
}

class MonwasteApp extends ConsumerStatefulWidget {
  const MonwasteApp({super.key});

  @override
  ConsumerState<MonwasteApp> createState() => _MonwasteAppState();
}

class _MonwasteAppState extends ConsumerState<MonwasteApp>
    with WidgetsBindingObserver {
  Timer? _widgetDebounce;

  @override
  void initState() {
    super.initState();
    // Push initial widget data — ensures widget never shows fallback values.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final data = ref.read(widgetDataProvider);
        updateGlanceWidget(data);
      } catch (_) {
        // Provider may not be ready yet; listener handles it.
      }
      NotificationService.init().then((_) {
        _rescheduleNotifications();
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _widgetDebounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      try {
        final data = ref.read(widgetDataProvider);
        updateGlanceWidget(data);
      } catch (_) {}
    }
  }

  Future<void> _rescheduleNotifications() async {
    try {
      final db = ref.read(databaseProvider);
      final gastos = await db.watchActiveGastos().first;
      final settings = await db.getSettings();
      await NotificationService.rescheduleAll(gastos, settings);
    } catch (_) {
      // Best-effort.
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Listen for widget data changes and update the glance widget with
    // a simple debounce to coalesce rapid updates (batch edits, toggles).
    ref.listen<HomeWidgetData>(widgetDataProvider, (_, data) {
      _widgetDebounce?.cancel();
      _widgetDebounce = Timer(const Duration(milliseconds: 200), () {
        updateGlanceWidget(data);
      });
    });

    // Page transitions theme — subtle fade-up for push/pop navigation.
    const pageTransitions = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    );

    final lightTheme = AppTheme.light().copyWith(
      pageTransitionsTheme: pageTransitions,
    );
    final darkTheme = AppTheme.dark().copyWith(
      pageTransitionsTheme: pageTransitions,
    );

    return MaterialApp.router(
      title: 'Monwaste',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
