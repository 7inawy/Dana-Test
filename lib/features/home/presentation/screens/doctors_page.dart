import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/widgets/custom_app_bar_button.dart';
import 'package:dana/core/utils/app_colors.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/home/presentation/cubit/doctors_list_cubit.dart';
import 'package:dana/features/home/presentation/cubit/doctors_list_state.dart';
import 'package:dana/features/home/presentation/widgets/doctor_card.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  static const String routeName = 'DoctorsScreen';

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  late final DoctorsListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DoctorsListCubit>()..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.bg_card_default_dark
              : AppColors.bg_card_default_light,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 56.w,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.doctors,
                  style: AppTextStyle.medium16TextHeading(context),
                ),
                CustomAppBarButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: BlocBuilder<DoctorsListCubit, DoctorsListState>(
            builder: (context, state) {
              if (state is DoctorsListLoading || state is DoctorsListInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DoctorsListError) {
                return Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.medium12TextBody(context),
                  ),
                );
              }
              if (state is DoctorsListLoaded) {
                final doctors = state.doctors;
                if (doctors.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.doctorsListEmpty,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.medium12TextBody(context),
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: doctors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 192.w / 206.w,
                  ),
                  itemBuilder: (context, index) {
                    final d = doctors[index];
                    return DoctorCard(
                      imageSrc: d.cardImageSrc,
                      doctorName: d.doctorName,
                      rate: d.ratingAverage,
                      specialtyText: d.specialty,
                      onBookNow: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.doctorTime,
                          arguments: BookingDoctorArgs.fromPublicDoctor(d),
                        );
                      },
                      onOpenChat: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.chatDoctor,
                          arguments: d.toChatDoctor(),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
