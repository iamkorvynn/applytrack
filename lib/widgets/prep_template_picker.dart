import 'package:material_ui/material_ui.dart';

import '../models/interview_round.dart';
import '../services/prep_templates.dart';

/// Buttons to add the default prep tasks for a round type.
class PrepTemplatePicker extends StatelessWidget {
  const PrepTemplatePicker({
    super.key,
    required this.onAdd,
  });

  final ValueChanged<RoundType> onAdd;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: RoundType.values.map((type) {
        final count = PrepTemplates.titlesFor(type).length;
        return ActionChip(
          label: Text('${type.label} prep ($count)'),
          onPressed: () => onAdd(type),
        );
      }).toList(),
    );
  }
}
