import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.instance.initialise();
  } catch (_) {
    // Reminders are optional; the app must start without them.
  }
  runApp(const ApplyTrackApp());
}
