import 'package:applytrack/utils/reminder_lead_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('labels read naturally', () {
    expect(ReminderLeadOptions.label(0), 'On the deadline day');
    expect(ReminderLeadOptions.label(1), '1 day before');
    expect(ReminderLeadOptions.label(3), '3 days before');
    expect(ReminderLeadOptions.label(14), '14 days before');
  });

  test('options are ordered and include the default', () {
    expect(ReminderLeadOptions.options, [0, 1, 3, 7, 14]);
    expect(ReminderLeadOptions.options, contains(3));
  });
}
