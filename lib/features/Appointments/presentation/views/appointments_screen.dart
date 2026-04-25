import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/Appointments/data/models/appointment_model.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointments_list.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointments_tab_bar.dart';
import 'package:dana/features/booking/data/models/booking_model.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:dana/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:dana/features/booking/presentation/cubit/booking_state.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/core/errors/error_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsScreen extends StatefulWidget {
  static const String routeName = 'AppointmentsScreen';

  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String activeTab = 'upcoming';

  late final BookingCubit _bookingCubit;

  @override
  void initState() {
    super.initState();
    _bookingCubit = sl<BookingCubit>();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final me = await sl<ParentProfileRepository>().getMe();
      if (!mounted) return;
      await _bookingCubit.getMyAppointmentsByParent(parentId: me.id);
    } catch (e) {
      if (!mounted) return;
      _bookingCubit.reportLoadError(ErrorMapper.message(e));
    }
  }

  @override
  void dispose() {
    _bookingCubit.close();
    super.dispose();
  }

  Status _mapStatus(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('cancel')) return Status.cancelled;
    if (s.contains('complete')) return Status.completed;
    // "confirmed" / "pending" stay upcoming until visit is done.
    return Status.upcoming;
  }

  TimeOfDay _parseTime(String raw) {
    final parts = raw.split(':');
    final h = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  Appointment _mapBookingToAppointment(BuildContext context, Booking b) {
    final start = _parseTime(b.time);
    final end = TimeOfDay(hour: (start.hour + 1) % 24, minute: start.minute);
    final date = DateTime.tryParse(b.date) ?? DateTime.now();
    final image = b.doctor.profileImage?.isNotEmpty == true
        ? b.doctor.profileImage!
        : 'assets/Images/appointment/doctor_image.png';
    final plainName = b.doctor.name.trim().isNotEmpty ? b.doctor.name.trim() : '-';
    final specialty = b.doctor.specialty.trim();
    final loc = b.doctor.locationLine.trim();

    return Appointment(
      bookingId: b.id,
      childId: b.child.id,
      doctorId: b.doctor.id,
      doctorName: '${context.l10n.dr} $plainName',
      doctorNamePlain: plainName,
      specialty: specialty.isNotEmpty ? specialty : context.l10n.physiotherapist,
      detectionPrice: b.doctor.price.toDouble(),
      image: image,
      date: date,
      startTime: start,
      endTime: end,
      address: loc.isNotEmpty ? loc : '—',
      status: _mapStatus(b.status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocProvider.value(
      value: _bookingCubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.appointments,
          isDark: isDark,
          onBack: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.pushNamed(context, AppRoutes.home);
            }
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              AppointmentsTabBar(
                activeTab: activeTab,
                onTabChanged: (value) {
                  setState(() {
                    activeTab = value;
                  });
                },
              ),
              Expanded(
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is BookingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is BookingError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.error, textAlign: TextAlign.center),
                            SizedBox(height: 12.h),
                            ElevatedButton(
                              onPressed: _loadBookings,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }
                    final bookings = state is BookingSuccess
                        ? state.bookings
                        : <Booking>[];
                    final appts =
                        bookings
                            .map((b) => _mapBookingToAppointment(context, b))
                            .toList()
                          ..sort((a, b) => a.date.compareTo(b.date));
                    return buildBody(appts);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(List<Appointment> appointments) {
    switch (activeTab) {
      case 'upcoming':
        return AppointmentsList(
          appointments: appointments,
          status: Status.upcoming,
          onRefresh: _loadBookings,
        );

      case 'completed':
        return AppointmentsList(
          appointments: appointments,
          status: Status.completed,
          onRefresh: _loadBookings,
        );

      case 'cancelled':
        return AppointmentsList(
          appointments: appointments,
          status: Status.cancelled,
          onRefresh: _loadBookings,
        );

      default:
        return const SizedBox();
    }
  }
}
