import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/database.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/expense_card.dart';
import 'providers.dart';

class NextMonthScreen extends ConsumerStatefulWidget {
  const NextMonthScreen({super.key});

  @override
  ConsumerState<NextMonthScreen> createState() => _NextMonthScreenState();
}

class _NextMonthScreenState extends ConsumerState<NextMonthScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  List<Gasto> _items = [];
  bool _initialized = false;

  /// Processes data changes from the provider for AnimatedList diffing.
  ///
  /// On [first] data arrival, [build] already populated [_items] directly
  /// from [nextMonthSummaryProvider] (see [build]) — so this branch is hit
  /// only when the provider value changes *after* the screen is already
  /// showing (e.g. the user toggles a gasto).
  ///
  /// Subsequent calls diff old vs new and animate insertions / removals.
  void _onDataChange(List<Gasto> newItems) {
    if (!_initialized) {
      // Still handles the edge case where build runs before provider data
      // is ready (e.g. stream hasn't emitted yet).
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
    final summary = ref.watch(nextMonthSummaryProvider);

    // Initialize _items from the provider on first build.
    //
    // ref.listen (below) does NOT fire for the current/initial value — it
    // only fires on *changes*.  If the provider already has data when this
    // screen mounts (which it does, because HomeScreen watches the same
    // provider), the listener callback never runs, _onDataChange is never
    // called, and _items stays empty.
    //
    // We must seed _items synchronously from the current provider value
    // so the AnimatedList renders with the correct items from the start.
    if (!_initialized) {
      _initialized = true;
      _items = List.from(summary.matchingGastos);
    }

    // Listen for provider changes and schedule animated updates.
    ref.listen<NextMonthSummary>(nextMonthSummaryProvider, (_, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onDataChange(next.matchingGastos);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeNextMonthLabel),
      ),
      body: _items.isEmpty
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
          : AnimatedList(
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
                      onTap: () => context.push('/expenses/edit/${gasto.id}'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
