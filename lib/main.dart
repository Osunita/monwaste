import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme.dart';
import 'features/expenses/expense_form_screen.dart';
import 'features/expenses/expense_list_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/next_month_screen.dart';
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
        onDestinationSelected: (index) => navigationShell.goBranch(index),
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

class _MonwasteAppState extends ConsumerState<MonwasteApp> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.init().then((_) {
        _rescheduleNotifications();
      });
    });
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

    return MaterialApp.router(
      title: 'Monwaste',
      routerConfig: _router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
