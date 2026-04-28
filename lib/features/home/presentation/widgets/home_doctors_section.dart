import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/home/presentation/cubit/doctors_list_cubit.dart';
import 'package:dana/features/home/presentation/cubit/doctors_list_state.dart';
import 'package:dana/features/home/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDoctorsSection extends StatelessWidget {
  const HomeDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.alwaysBestForChildCare,
              style: AppTextStyle.medium16TextHeading(context),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.doctors);
              },
              child: Text(
                context.l10n.viewAll,
                style: AppTextStyle.regular12TextBody(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Doctors list
        BlocBuilder<DoctorsListCubit, DoctorsListState>(
          builder: (context, dState) {
            if (dState is DoctorsListLoading || dState is DoctorsListInitial) {
              return SizedBox(
                height: 200.h,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (dState is DoctorsListError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  dState.message,
                  style: AppTextStyle.medium12TextBody(context),
                ),
              );
            }

            if (dState is DoctorsListLoaded) {
              final list = dState.doctors;
              if (list.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    context.l10n.doctorsListEmpty,
                    style: AppTextStyle.medium12TextBody(context),
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(list.length, (index) {
                    final d = list[index];
                    return Container(
                      margin: EdgeInsets.only(
                        right: index == 0 ? 0 : 4,
                        left: index == list.length - 1 ? 0 : 4,
                      ),
                      child: DoctorCard(
                        imageSrc: d.cardImageSrc,
                        doctorName: d.doctorName,
                        rate: d.ratingAverage,
                        width: 137.w,
                        specialtyText: d.specialty,
                        onBookNow: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.doctorTime,
                            arguments: BookingDoctorArgs.fromPublicDoctor(d),
                          );
                        },
                      ),
                    );
                  }),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
