import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/core/utils/app_sizes.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_colors.dart';
import 'package:dana/extensions/localization_extension.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/app_theme_provider.dart';

import '../../../../videos/presentation/views/widgets/videos_TabBar.dart';
import '../../../data/model/examination_model.dart';
import '../../../data/model/sensory_test_models.dart';
import '../../cubit/sensory_test_cubit.dart';
import '../../cubit/sensory_test_state.dart';
import '../widgets/examination_Body.dart';
import '../widgets/show_Result_Button.dart';
import '../widgets/result_Bottom_Sheet.dart';
import '../widgets/sensitivity_Result_BottomSheet.dart';
import '../widgets/specia_listResult_BottomSheet.dart';

class ExaminationScreen extends StatefulWidget {
  static const String routeName = 'ExaminationScreen';

  const ExaminationScreen({super.key});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  late String _activeTab;
  late List<ExamSection> _sections;
  bool _initialized = false;
  late final SensoryTestCubit _cubit;
  final Map<String, int> _answersByQuestionId = {};
  List<List<SensoryQuestion>> _sectionQuestions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final l10n = AppLocalizations.of(context)!;
    _activeTab = l10n.examination;

    _sections = [];
    _cubit = sl<SensoryTestCubit>()..loadQuestions();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  int _mapOption(ResponseOption option) {
    switch (option) {
      case ResponseOption.rarely:
        return 1;
      case ResponseOption.sometimes:
        return 2;
      case ResponseOption.always:
        return 3;
    }
  }

  List<ExamSection> _buildSectionsFromQuestions(
    BuildContext context,
    List<SensoryQuestion> questions,
  ) {
    final l10n = AppLocalizations.of(context)!;

    String titleFor(String category) {
      switch (category) {
        case 'seeking':
          return l10n.touchAndSoundTitle;
        case 'avoiding':
          return l10n.motorInteractionTitle;
        case 'sensitivity':
          return l10n.behaviorAndTantrumsTitle;
        case 'registration':
          return l10n.examination; // fallback label
        default:
          return l10n.examination;
      }
    }

    final grouped = <String, List<SensoryQuestion>>{};
    for (final q in questions) {
      grouped.putIfAbsent(q.category, () => []).add(q);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    _sectionQuestions = entries.map((e) => e.value).toList();

    return entries
        .map(
          (e) => ExamSection(
            title: titleFor(e.key),
            subtitle: null,
            questions: e.value.map((q) => ExamQuestion(text: q.text)).toList(),
          ),
        )
        .toList();
  }

  void _showResultForLevel(BuildContext context, String level) {
    final l = level.toLowerCase();
    if (l == 'low') {
      ResultBottomSheet.show(context);
    } else if (l == 'medium') {
      SensitivityResultBottomSheet.show(context);
    } else {
      SpecialistResultBottomSheet.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SensoryTestCubit, SensoryTestState>(
        listenWhen: (_, s) => s is SensoryTestSubmitError,
        listener: (context, state) {
          if (state is! SensoryTestSubmitError) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message.isNotEmpty
                    ? state.message
                    : context.l10n.sensorySubmitFailed,
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Scaffold(
          appBar: CustomAppBar(title: l10n.examinationTitle, isDark: isDark),
          backgroundColor: isDark
              ? AppColors.bg_surface_default_dark
              : AppColors.bg_surface_default_light,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.h12),
                  VideosTabBar(
                    activeTab: _activeTab,
                    onTabChanged: (t) => setState(() => _activeTab = t),
                  ),
                  SizedBox(height: AppSizes.h12),
                  Expanded(
                    child: BlocBuilder<SensoryTestCubit, SensoryTestState>(
                      builder: (context, state) {
                        if (state is SensoryTestLoading ||
                            state is SensoryTestInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is SensoryTestError) {
                          return Center(child: Text(state.message));
                        }
                        final questions = state is SensoryTestLoaded
                            ? state.questions
                            : state is SensoryTestSubmitting
                            ? state.questions
                            : state is SensoryTestSubmitError
                            ? state.questions
                            : <SensoryQuestion>[];
                        _sections = _buildSectionsFromQuestions(
                          context,
                          questions,
                        );
                        return ExaminationBody(
                          sections: _sections,
                          onAnswerChanged: (sectionIndex, questionIndex, option) {
                            setState(() {
                              _sections[sectionIndex]
                                      .questions[questionIndex]
                                      .selectedOption =
                                  option;

                              if (sectionIndex < _sectionQuestions.length &&
                                  questionIndex <
                                      _sectionQuestions[sectionIndex].length) {
                                final qid =
                                    _sectionQuestions[sectionIndex][questionIndex]
                                        .id;
                                if (qid.isNotEmpty) {
                                  _answersByQuestionId[qid] = _mapOption(
                                    option,
                                  );
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ShowResultButton(
                    isEnabled: _allAnswered(),
                    label: l10n.showResult,
                    onTap: () async {
                      final result = await context
                          .read<SensoryTestCubit>()
                          .submit(_answersByQuestionId);
                      if (result == null || !mounted) return;
                      _showResultForLevel(context, result.level);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _allAnswered() {
    return _sections.every(
      (s) => s.questions.every((q) => q.selectedOption != null),
    );
  }
}
