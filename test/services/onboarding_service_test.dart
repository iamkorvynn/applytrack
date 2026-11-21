import 'package:applytrack/services/onboarding_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('welcome starts unseen and can be marked seen', () async {
    SharedPreferences.setMockInitialValues({});
    final service = await OnboardingService.load();
    expect(service.hasSeenWelcome, isFalse);
    await service.markWelcomeSeen();
    expect(service.hasSeenWelcome, isTrue);
  });

  test('welcome stays seen across loads', () async {
    SharedPreferences.setMockInitialValues({'has_seen_welcome': true});
    final service = await OnboardingService.load();
    expect(service.hasSeenWelcome, isTrue);
  });
}
