import 'package:applytrack/models/application_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('labels are human readable', () {
    expect(ApplicationStatus.wishlist.label, 'Wishlist');
    expect(ApplicationStatus.assessment.label, 'Assessment');
    expect(ApplicationStatus.offer.label, 'Offer');
  });

  test('order follows the pipeline', () {
    expect(ApplicationStatus.wishlist.order, 0);
    expect(ApplicationStatus.applied.order, 1);
    expect(ApplicationStatus.offer.order, 4);
    expect(
      ApplicationStatus.values
          .map((s) => s.order)
          .toList(),
      [0, 1, 2, 3, 4, 5, 6],
    );
  });

  test('terminal statuses are rejected and withdrawn only', () {
    expect(ApplicationStatus.rejected.isTerminal, isTrue);
    expect(ApplicationStatus.withdrawn.isTerminal, isTrue);
    expect(ApplicationStatus.offer.isTerminal, isFalse);
    expect(ApplicationStatus.interview.isTerminal, isFalse);
  });

  test('active excludes wishlist and terminal', () {
    expect(ApplicationStatus.wishlist.isActive, isFalse);
    expect(ApplicationStatus.applied.isActive, isTrue);
    expect(ApplicationStatus.interview.isActive, isTrue);
    expect(ApplicationStatus.rejected.isActive, isFalse);
  });

  test('reachedInterview is interview and offer', () {
    expect(ApplicationStatus.interview.reachedInterview, isTrue);
    expect(ApplicationStatus.offer.reachedInterview, isTrue);
    expect(ApplicationStatus.assessment.reachedInterview, isFalse);
  });
}
