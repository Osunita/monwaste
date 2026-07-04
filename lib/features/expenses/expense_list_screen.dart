import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/database.dart';
import '../../l10n/l10n.dart';
import '../../shared/notifications.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/expense_card.dart';
import 'providers.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  List<Gasto> _items = [];
  bool _initialized = false;

  /// Handles data changes from the provider.
  ///
  /// On first data arrival, inserts all items into the [AnimatedList] with
  /// zero duration (immediate).  On subsequent changes, diffs old vs new
  /// and animates insertions / removals.
  void _onDataChange(List<Gasto> newItems) {
    if (!_initialized) {
      _initialized = true;
      _items = List.from(newItems);
      for (var i = 0; i < _items.length; i++) {
        _listKey.currentState?.insertItem(i, duration: Duration.zero);
      }
      return;
    }

    // Subsequent changes — diff and animate
    final oldIds = _items.map((g) => g.id).toSet();
    final newIds = newItems.map((g) => g.id).toSet();

    // Remove stale items (iterate backwards to preserve indices).
    for (var i = _items.length - 1; i >= 0; i--) {
      if (!newIds.contains(_items[i].id)) {
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: const SizedBox.shrink(),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Insert new items.
    for (var i = 0; i < newItems.length; i++) {
      if (!oldIds.contains(newItems[i].id)) {
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Always update the local list and signal rebuild so that
    // updated items (e.g. toggle activo) re-render.
    _items = List.from(newItems);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    final gastosAsync = ref.watch(gastoListProvider);

    // Listen for provider changes and schedule animated updates.
    ref.listen<AsyncValue<List<Gasto>>>(gastoListProvider, (_, next) {
      final nextItems = next.valueOrNull ?? [];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onDataChange(nextItems);
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.expensesTitle)),
      body: gastosAsync.when(
        data: (gastos) {
          if (gastos.isEmpty && _items.isEmpty) {
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
          return AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) {
              if (index >= _items.length) return const SizedBox.shrink();
              final gasto = _items[index];
              return SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: ExpenseCard(
                    gasto: gasto,
                    showToggle: true,
                    onTap: () => context.push('/expenses/edit/${gasto.id}'),
                    onToggle: (_) async {
                      await db.toggleGastoActivo(gasto.id);
                      rescheduleNotifications(ref);
                    },
                  ),
                ),
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
