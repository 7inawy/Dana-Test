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

String _questionDisplayText(SensoryQuestion q, String languageCode) {
  if (languageCode == 'ar') {
    final t = q.textAr?.trim();
    if (t != null && t.isNotEmpty) return t;
  } else {
    final t = q.textEn?.trim();
    if (t != null && t.isNotEmpty) return t;
  }
  return q.text;
}

int _apiValueForUiOption(SensoryQuestion q, ResponseOption opt) {
  if (q.options.isEmpty) return 1;

  // Robust mapping: prefer option values (1,2,3) ordering over labels.
  // Some deployments/localizations change option labels or ordering, which can
  // otherwise make all selections map to the same API value.
  final sorted = List<SensoryQuestionOption>.from(q.options)
    ..sort((a, b) => a.value.compareTo(b.value));

  SensoryQuestionOption pick(int index) {
    final i = index.clamp(0, sorted.length - 1);
    return sorted[i];
  }

  switch (opt) {
    case ResponseOption.rarely:
      return pick(0).value;
    case ResponseOption.sometimes:
      return pick(sorted.length ~/ 2).value;
    case ResponseOption.always:
      return pick(sorted.length - 1).value;
  }
}

ResponseOption? _uiOptionFromApiValue(SensoryQuestion q, int v) {
  if (q.options.isEmpty) return null;
  final sorted = List<SensoryQuestionOption>.from(q.options)
    ..sort((a, b) => a.value.compareTo(b.value));

  // Map to nearest of {low/mid/high} based on value ordering.
  if (v == sorted.first.value) return ResponseOption.rarely;
  if (v == sorted.last.value) return ResponseOption.always;
  return ResponseOption.sometimes;
}

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
  List<SensoryQuestion>? _stableQuestions;

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

  List<ExamSection> _buildSectionsFromQuestions(
    BuildContext context,
    List<SensoryQuestion> questions,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

    String titleFor(String category) {
      switch (category) {
        case 'seeking':
          return l10n.touchAndSoundTitle;
        case 'avoiding':
          return l10n.motorInteractionTitle;
        case 'sensitivity':
          return l10n.behaviorAndTantrumsTitle;
        case 'registration':
          return l10n.examination;
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
            questions: e.value
                .map(
                  (q) => ExamQuestion(
                    text: _questionDisplayText(q, lang),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  void _applyStoredAnswersToSections() {
    for (var si = 0; si < _sectionQuestions.length; si++) {
      final row = _sectionQuestions[si];
      for (var qi = 0; qi < row.length; qi++) {
        final q = row[qi];
        final v = _answersByQuestionId[q.id];
        if (v != null) {
          _sections[si].questions[qi].selectedOption = _uiOptionFromApiValue(
            q,
            v,
          );
        }
      }
    }
  }

  void _rebuildUiFromStableQuestions(BuildContext context) {
    final q = _stableQuestions;
    if (q == null) return;
    _sections = _buildSectionsFromQuestions(context, q);
    _applyStoredAnswersToSections();
  }

  void _showResultForLevel(BuildContext context, SensoryTestResult result) {
    final l = result.level.toLowerCase();
    if (l == 'low') {
      ResultBottomSheet.show(context, result: result);
    } else if (l == 'medium') {
      SensitivityResultBottomSheet.show(context, result: result);
    } else {
      SpecialistResultBottomSheet.show(context, result: result);
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
        listenWhen: (prev, next) =>
            next is SensoryTestLoaded ||
            (next is SensoryTestSubmitError && prev is! SensoryTestSubmitError),
        listener: (context, state) {
          if (state is SensoryTestLoaded) {
            setState(() {
              _stableQuestions = List<SensoryQuestion>.from(state.questions);
              _rebuildUiFromStableQuestions(context);
            });
          } else if (state is SensoryTestSubmitError) {
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
          }
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
                        if (_stableQuestions == null &&
                            (state is SensoryTestLoading ||
                                state is SensoryTestInitial)) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (_stableQuestions == null &&
                            state is SensoryTestError) {
                          return Center(child: Text(state.message));
                        }
                        if (_stableQuestions == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ExaminationBody(
                          sections: _sections,
                          onAnswerChanged: (sectionIndex, questionIndex, option) {
                            if (sectionIndex >= _sectionQuestions.length) {
                              return;
                            }
                            final row = _sectionQuestions[sectionIndex];
                            if (questionIndex >= row.length) return;
                            final sensoryQ = row[questionIndex];
                            final apiVal = _apiValueForUiOption(
                              sensoryQ,
                              option,
                            );
                            setState(() {
                              _answersByQuestionId[sensoryQ.id] = apiVal;
                              _sections[sectionIndex]
                                  .questions[questionIndex]
                                  .selectedOption = option;
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
                      // Use [_cubit] — [State.context] is above [BlocProvider.value], so
                      // context.read<SensoryTestCubit>() would throw ProviderNotFoundException.
                      final result =
                          await _cubit.submit(_answersByQuestionId);
                      if (result == null || !mounted) return;
                      _showResultForLevel(context, result);
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
    final qs = _stableQuestions;
    if (qs == null || qs.isEmpty) return false;
    for (final q in qs) {
      if (q.id.isEmpty) continue;
      if (!_answersByQuestionId.containsKey(q.id)) return false;
    }
    return true;
  }
}
