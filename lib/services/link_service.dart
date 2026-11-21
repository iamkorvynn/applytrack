import 'package:url_launcher/url_launcher.dart';

/// Open a job posting link in the browser. Pure validation is separate
/// so it can be unit tested without a platform.
class LinkService {
  static bool isLaunchableUrl(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return false;
    final uri = Uri.tryParse(text);
    if (uri == null) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    return uri.host.contains('.');
  }

  static Future<bool> openUrl(String raw) async {
    if (!isLaunchableUrl(raw)) return false;
    try {
      return await launchUrl(
        Uri.parse(raw.trim()),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}
