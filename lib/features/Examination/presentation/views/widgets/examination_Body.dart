import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/features/Examination/presentation/views/widgets/examination_Section_Header.dart';
import 'package:dana/features/Examination/presentation/views/widgets/warning_Banner.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/model/examination_model.dart';
import 'exam_Section_Card.dart';

class ExaminationBody extends StatelessWidget {
  final List<ExamSection> sections;
  final Function(int sectionIndex, int questionIndex, ResponseOption option)
  onAnswerChanged;

  const ExaminationBody({
    super.key,
    required this.sections,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const WarningBanner(),
        SizedBox(height: AppSizes.h24),
        const ExaminationSectionHeader(),
        SizedBox(height: AppSizes.h16),

        ...List.generate(
          sections.length,
          (sectionIndex) => ExamSectionCard(
            section: sections[sectionIndex],
            onAnswerChanged: (questionIndex, option) =>
                onAnswerChanged(sectionIndex, questionIndex, option),
          ),
        ),
      ],
    );
  }
}
