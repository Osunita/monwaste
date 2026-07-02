import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/database.dart';
import '../core/database/tables.dart';
import 'next_occurrence.dart';
import 'providers.dart';

// ---------------------------------------------------------------------------
// Notification service for local reminders.
//
// Uses flutter_local_notifications with inexactAllowWhileIdle on Android
// to avoid the SCHEDULE_EXACT_ALARM permission (Android 12+).
//
// For now we keep the scheduling logic as a structure — the actual
// platform channel pushes will be wired in a follow-up once the
// flutter_local_notifications API is verified against the current version.
// ---------------------------------------------------------------------------

/// Minimal notification service.
///
/// Provides [init], [cancelAll], and [rescheduleAll] for local notifications.
/// The actual scheduling of individual notifications via the platform plugin
/// is stubbed but ready to be filled in.
class NotificationService {
  NotificationService._();

  static bool _initialized = false;

  /// Initialize the notification plugin.
  ///
  /// Safe to call multiple times — only initialises once.
  static Future<void> init() async {
    if (_initialized) return;
    // flutter_local_notifications init would go here once the exact API
    // for the pinned version is confirmed.
    _initialized = true;
  }

  /// Cancel all pending notifications.
  static Future<void> cancelAll() async {
    if (!_initialized) return;
    // await FlutterLocalNotificationsPlugin().cancelAll();
  }

  /// Reschedule all notifications based on current active expenses and
  /// settings.
  ///
  /// Called after:
  ///   - App start-up
  ///   - Insert / update / delete / toggle of any expense
  ///   - Settings change
  static Future<void> rescheduleAll(
    List<Gasto> activeGastos,
    Setting settings,
  ) async {
    if (!_initialized) return;
    await cancelAll();

    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    for (final gasto in activeGastos) {
      if (gasto.fechaCobro == null) continue;
      final periodicidad = Periodicidad.values.firstWhere(
        (p) => p.name == gasto.periodicidad,
      );
      final occurrence =
          nextOccurrence(periodicidad, gasto.fechaCobro, nextMonth);
      if (occurrence != null) {
        // Schedule platform notification for [gasto] at [occurrence].
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod helper: triggers rescheduleAll after DB mutations
// ---------------------------------------------------------------------------

/// Call this after any expense CRUD operation to keep notifications in sync.
///
/// Uses a one-shot `.get()` query instead of `.watch().first` to avoid
/// hanging widget tests where the stream event-loop may not resolve.
Future<void> rescheduleNotifications(WidgetRef ref) async {
  try {
    final db = ref.read(databaseProvider);
    final gastos = await db.getActiveGastos();
    final settings = await db.getSettings();
    await NotificationService.rescheduleAll(gastos, settings);
  } catch (_) {
    // Silently ignore — notifications are best-effort.
  }
}
