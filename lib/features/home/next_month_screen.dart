import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../shared/widgets/expense_card.dart';
import 'providers.dart';

/// Shows the filtered list of expenses whose next occurrence falls
/// in the month following the current month.
class NextMonthScreen extends ConsumerWidget {
  const NextMonthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summary = ref.watch(nextMonthSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeNextMonthLabel),
      ),
      body: summary.matchingGastos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.homeNextMonthEmpty,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: summary.matchingGastos.length,
              itemBuilder: (context, index) {
                final gasto = summary.matchingGastos[index];
                return ExpenseCard(
                  gasto: gasto,
                  // No toggle on this detail screen — just a chevron
                  onTap: () {
                    // No additional navigation for now
                  },
                );
              },
            ),
    );
  }
}
