import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/utils/status_flow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('offer can only be withdrawn', () {
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.offer,
        ApplicationStatus.withdrawn,
      ),
      isTrue,
    );
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.offer,
        ApplicationStatus.rejected,
      ),
      isFalse,
    );
  });

  test('assessment cannot go back to applied', () {
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.assessment,
        ApplicationStatus.applied,
      ),
      isFalse,
    );
  });

  test('interview can become an offer directly', () {
    expect(
      StatusFlow.canTransition(
        ApplicationStatus.interview,
        ApplicationStatus.offer,
      ),
      isTrue,
    );
  });
}
