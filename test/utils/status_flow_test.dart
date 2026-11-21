import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/utils/status_flow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wishlist can go to applied or withdrawn', () {
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.wishlist,
        ApplicationStatus.applied,
      ),
      isTrue,
    );
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.wishlist,
        ApplicationStatus.offer,
      ),
      isFalse,
    );
  });

  test('applied can move forward to any live stage', () {
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.applied,
        ApplicationStatus.interview,
      ),
      isTrue,
    );
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.applied,
        ApplicationStatus.rejected,
      ),
      isTrue,
    );
  });

  test('terminal statuses cannot move anywhere', () {
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.rejected,
        ApplicationStatus.applied,
      ),
      isFalse,
    );
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.withdrawn,
        ApplicationStatus.offer,
      ),
      isFalse,
    );
  });

  test('same status is always allowed', () {
    for (final status in ApplicationStatus.values) {
      expect(StatusFlow.canTransition(status, status), isTrue);
    }
  });

  test('needsAction is applied, assessment and interview', () {
    expect(StatusFlow.needsAction, [
      ApplicationStatus.applied,
      ApplicationStatus.assessment,
      ApplicationStatus.interview,
    ]);
  });
}
