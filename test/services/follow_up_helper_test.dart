import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/services/follow_up_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  Application app({
    ApplicationStatus status = ApplicationStatus.applied,
    DateTime? applied,
    DateTime? followUp,
  }) {
    return Application(
      company: 'Acme',
      role: 'Dev',
      status: status,
      dateApplied: applied,
      followUpDate: followUp,
    );
  }

  test('flags applications quiet for 7+ days', () {
    final list = FollowUpHelper.needingFollowUp(
      [
        app(applied: DateTime(2026, 11, 10)),
        app(applied: DateTime(2026, 11, 19)),
        app(status: ApplicationStatus.wishlist, applied: DateTime(2026, 10, 1)),
        app(
          status: ApplicationStatus.rejected,
          applied: DateTime(2026, 10, 1),
        ),
      ],
      now: now,
    );
    expect(list.length, 1);
  });

  test('flags a follow-up date that has arrived', () {
    final list = FollowUpHelper.needingFollowUp(
      [app(followUp: DateTime(2026, 11, 21))],
      now: now,
    );
    expect(list.length, 1);
    final future = FollowUpHelper.needingFollowUp(
      [app(followUp: DateTime(2026, 11, 25))],
      now: now,
    );
    expect(future, isEmpty);
  });

  test('suggestFollowUpDate is 7 days after applying by default', () {
    final suggested = FollowUpHelper.suggestFollowUpDate(
      app(applied: DateTime(2026, 11, 10)),
    );
    expect(suggested, DateTime(2026, 11, 17));
  });
}
