import 'package:flutter/foundation.dart';
import 'package:glance_widget/glance_widget.dart';

import 'widget_data_provider.dart';

/// Widget identifier for the Monwaste glance home-screen widget.
const _monwasteWidgetId = 'monwaste_total';

/// Unique widget ID for the Monwaste glance home-screen widget.
String get monwasteWidgetId => _monwasteWidgetId;

/// Updates the glance home-screen widget with the current [HomeWidgetData].
///
/// Called from [MonwasteApp] whenever expense or settings data changes.
/// Uses the [theme] from [HomeWidgetData.isDark] to match the app theme.
Future<void> updateGlanceWidget(HomeWidgetData data) async {
  try {
    GlanceWidget.simple(
      id: _monwasteWidgetId,
      title: data.title,
      value: data.total,
      subtitle: data.subtitle,
      deepLinkUri: 'monwaste://',
      theme: data.isDark ? GlanceTheme.dark() : GlanceTheme.light(),
    );
  } catch (e, st) {
    debugPrint('updateGlanceWidget error: $e\n$st');
  }
}
