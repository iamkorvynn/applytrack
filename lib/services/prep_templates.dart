import '../models/interview_round.dart';

/// Default prep checklist for each round type. The user can add their
/// own items and tick these off; nothing is forced on them.
class PrepTemplates {
  static const Map<RoundType, List<String>> templates = {
    RoundType.hr: [
      'Read the job description again',
      'Prepare your 2-minute intro',
      'Know why you want this company',
      'Prepare 2 questions to ask them',
      'Check salary expectations',
    ],
    RoundType.technical: [
      'Revise core DSA topics',
      'Practise 3 coding problems',
      'Review your past projects',
      'Prepare system design basics',
      'Charge laptop and test mic/camera',
    ],
    RoundType.managerial: [
      'Prepare STAR stories for teamwork',
      'Think of a conflict you resolved',
      'Know your strengths and gaps',
      'Prepare questions about the team',
    ],
    RoundType.assignment: [
      'Read the brief twice',
      'Plan the solution before coding',
      'Test edge cases',
      'Write a short README for the work',
      'Submit before the deadline',
    ],
    RoundType.finalRound: [
      'Re-read all earlier round notes',
      'Prepare your salary ask',
      'Know the notice period / joining date',
      'Prepare final questions for leadership',
    ],
  };

  static List<String> titlesFor(RoundType type) =>
      List<String>.from(templates[type] ?? const []);
}
