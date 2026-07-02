import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../../shared/notifications.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/expense_card.dart';
import 'providers.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    final gastosAsync = ref.watch(gastoListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.expensesTitle)),
      body: gastosAsync.when(
        data: (gastos) {
          if (gastos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.expensesEmpty,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: gastos.length,
            itemBuilder: (context, index) {
              final gasto = gastos[index];
              return ExpenseCard(
                gasto: gasto,
                showToggle: true,
                onTap: () => context.push('/expenses/edit/${gasto.id}'),
                onToggle: (_) async {
                  await db.toggleGastoActivo(gasto.id);
                  // Fire-and-forget — see _save() in expense_form_screen.
                  rescheduleNotifications(ref);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('$err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/expenses/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
