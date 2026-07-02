import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/core/database/tables.dart';
import 'package:monwaste/shared/next_occurrence.dart';

void main() {
  group('nextOccurrence', () {
    // ===================================================================
    // Happy path — periodicidades alineadas
    // ===================================================================
    group('happy path — aligned periodicities', () {
      test(
        '#1 mensual: occurs in every reference month',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2026, 1, 15),
            DateTime(2026, 2),
          );
          expect(result, DateTime(2026, 2, 15));
        },
      );

      test(
        '#2 trimestral: aligns with reference month',
        () {
          final result = nextOccurrence(
            Periodicidad.trimestral,
            DateTime(2026, 1, 15),
            DateTime(2026, 4),
          );
          expect(result, DateTime(2026, 4, 15));
        },
      );

      test(
        '#3 semestral: aligns with reference month',
        () {
          final result = nextOccurrence(
            Periodicidad.semestral,
            DateTime(2026, 1, 15),
            DateTime(2026, 7),
          );
          expect(result, DateTime(2026, 7, 15));
        },
      );

      test(
        '#4 anual: aligns with reference month across years',
        () {
          final result = nextOccurrence(
            Periodicidad.anual,
            DateTime(2025, 3, 10),
            DateTime(2026, 3),
          );
          expect(result, DateTime(2026, 3, 10));
        },
      );
    });

    // ===================================================================
    // Periodicidades no alineadas → null
    // ===================================================================
    group('non-aligned periodicities return null', () {
      test(
        '#5 trimestral: does not align with reference month',
        () {
          final result = nextOccurrence(
            Periodicidad.trimestral,
            DateTime(2026, 1, 15),
            DateTime(2026, 2),
          );
          expect(result, isNull);
        },
      );

      test(
        '#6 semestral: does not align with reference month',
        () {
          final result = nextOccurrence(
            Periodicidad.semestral,
            DateTime(2026, 2, 15),
            DateTime(2026, 4),
          );
          expect(result, isNull);
        },
      );

      test(
        '#7 anual: does not align with reference month',
        () {
          final result = nextOccurrence(
            Periodicidad.anual,
            DateTime(2026, 6, 15),
            DateTime(2026, 12),
          );
          expect(result, isNull);
        },
      );
    });

    // ===================================================================
    // Day clamping — meses cortos
    // ===================================================================
    group('day clamping — short months', () {
      test(
        '#8 day 31 in February (non-leap) → Feb 28',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2026, 1, 31),
            DateTime(2026, 2),
          );
          expect(result, DateTime(2026, 2, 28));
        },
      );

      test(
        '#9 day 31 in 30-day month → last day (30)',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2026, 3, 31),
            DateTime(2026, 4),
          );
          expect(result, DateTime(2026, 4, 30));
        },
      );

      test(
        '#10 day 31 recovers in 31-day month',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2026, 1, 31),
            DateTime(2026, 3),
          );
          expect(result, DateTime(2026, 3, 31));
        },
      );

      test(
        '#14 day 31 in February leap year → Feb 29',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2026, 1, 31),
            DateTime(2028, 2),
          );
          expect(result, DateTime(2028, 2, 29));
        },
      );
    });

    // ===================================================================
    // February 29 handling
    // ===================================================================
    group('February 29 handling', () {
      test(
        '#11 Feb 29 in non-leap year → Feb 28',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2024, 2, 29),
            DateTime(2025, 2),
          );
          expect(result, DateTime(2025, 2, 28));
        },
      );

      test(
        '#12 after Feb 29, normal recurrence in next month',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            DateTime(2024, 2, 29),
            DateTime(2024, 3),
          );
          expect(result, DateTime(2024, 3, 29));
        },
      );
    });

    // ===================================================================
    // Null fechaCobro
    // ===================================================================
    group('null fechaCobro', () {
      test(
        '#13 returns null when anchor date is null',
        () {
          final result = nextOccurrence(
            Periodicidad.mensual,
            null,
            DateTime(2026, 3),
          );
          expect(result, isNull);
        },
      );
    });

    // ===================================================================
    // Compound edge cases
    // ===================================================================
    group('compound edge cases', () {
      test(
        '#15 trimestral + Feb 29 non-leap year clamping',
        () {
          // Anchor: 2024-02-29 (leap year).  Trimestral recurrence in
          // May 2025.  totalMonths = 15, 15 % 3 == 0 → aligns.
          // May has 31 days, so anchorDay=29 fits without clamping.
          final result = nextOccurrence(
            Periodicidad.trimestral,
            DateTime(2024, 2, 29),
            DateTime(2025, 5),
          );
          expect(result, DateTime(2025, 5, 29));
        },
      );
    });

    // ===================================================================
    // Additional edge: reference month before anchor → null
    // ===================================================================
    group('reference month before anchor', () {
      test('returns null when reference month is before anchor', () {
        final result = nextOccurrence(
          Periodicidad.mensual,
          DateTime(2026, 6, 15),
          DateTime(2026, 3),
        );
        expect(result, isNull);
      });
    });
  });
}
