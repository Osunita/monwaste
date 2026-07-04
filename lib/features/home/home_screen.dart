import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../shared/currency_utils.dart';
import '../expenses/providers.dart';
import 'providers.dart';

/// Home dashboard — shows the amount due next month and quick actions.
///
/// Design per AGENTS.md: minimalista, mucho espacio en blanco.  The total
/// is the LARGEST element on screen.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summary = ref.watch(nextMonthSummaryProvider);
    final activeGastos = ref.watch(activeGastoListProvider).valueOrNull ?? [];
    final activeCount = activeGastos.length;

    final currencyFormatter = ref.watch(currencyFormatterProvider);
    final totalFormatted = currencyFormatter.format(summary.total);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeNextMonthLabel),
      ),
      body: activeCount == 0
          ? _emptyState(l10n, context)
          : _dashboard(l10n, context, totalFormatted, summary.count, activeCount),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/expenses/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _emptyState(AppLocalizations l10n, BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeNoExpenses,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboard(
    AppLocalizations l10n,
    BuildContext context,
    String totalFormatted,
    int matchingCount,
    int activeCount,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: GestureDetector(
        onTap: () => context.go('/home/next-month'),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "El próximo mes pagarás" label above the circle
              Text(
                l10n.homeNextMonthPagaras,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Total inside a circle — the LARGEST element
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      totalFormatted,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeTapToSeeDetails,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.homeActiveCount(activeCount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
