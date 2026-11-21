import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the first-run welcome was shown.
class OnboardingService {
  OnboardingService(this._prefs);

  final SharedPreferences _prefs;

  static Future<OnboardingService> load() async {
    final prefs = await SharedPreferences.getInstance();
    return OnboardingService(prefs);
  }

  static const String _welcomeKey = 'has_seen_welcome';

  bool get hasSeenWelcome => _prefs.getBool(_welcomeKey) ?? false;

  Future<void> markWelcomeSeen() async {
    await _prefs.setBool(_welcomeKey, true);
  }
}
