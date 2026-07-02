import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/database.dart';
import '../../l10n/l10n.dart';
import '../providers.dart';

/// Shared card widget for displaying a single [Gasto].
///
/// Can show a toggle (for the main expense list) or a chevron (for detail
/// screens), depending on [showToggle] and [onTap].
class ExpenseCard extends ConsumerWidget {
  final Gasto gasto;
  final VoidCallback? onTap;
  final bool showToggle;
  final ValueChanged<bool>? onToggle;

  const ExpenseCard({
    super.key,
    required this.gasto,
    this.onTap,
    this.showToggle = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final currencyCode = ref.watch(currencyCodeProvider);

    final color = Color(
      int.parse(gasto.color.substring(1), radix: 16) | 0xFF000000,
    );

    final periodicidadLabel = switch (gasto.periodicidad) {
      'mensual' => l10n.periodicidadMensual,
      'trimestral' => l10n.periodicidadTrimestral,
      'semestral' => l10n.periodicidadSemestral,
      'anual' => l10n.periodicidadAnual,
      _ => gasto.periodicidad,
    };

    final amountFormatted = NumberFormat.currency(
      symbol: _currencySymbol(currencyCode),
      decimalDigits: 2,
    ).format(gasto.importe);

    final dateFormatted = gasto.fechaCobro != null
        ? DateFormat.MMMd().format(gasto.fechaCobro!)
        : l10n.expenseFormDateNotSet;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              // Color indicator — small circle on the left
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Middle content: name, amount, periodicity, date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gasto.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      amountFormatted,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$periodicidadLabel · $dateFormatted',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Right side: toggle or chevron
              if (showToggle)
                Switch(
                  value: gasto.activo,
                  onChanged: onToggle,
                )
              else if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _currencySymbol(String code) {
    switch (code) {
      case 'EUR':
        return '€';
      case 'USD':
        return r'$';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'CA\$';
      case 'BRL':
        return 'R\$';
      case 'ARS':
        return 'AR\$';
      case 'MXN':
        return 'MX\$';
      default:
        return code;
    }
  }
}
