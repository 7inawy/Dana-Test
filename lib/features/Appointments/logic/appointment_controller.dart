import 'package:dana/features/Appointments/logic/appointment_calendar_logic.dart';
import 'package:dana/features/Appointments/presentation/widgets/appointment_time_data.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:flutter/material.dart';

class AppointmentController extends ChangeNotifier {
  AppointmentController();

  String? doctorId;
  String doctorName = '';
  String specialty = '';
  String locationLine = '';
  String imageUrl = 'assets/Images/home/doctor1.png';
  double detectionPrice = 0;
  int ratingQuantity = 0;
  double ratingAverage = 0;
  List<String> availableDateStrs = const [];
  List<TimeOfDay> timeSlots = AppointmentTimeData.availableTimes;

  int selectedTimeIndex = -1;
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? selectedDate;

  void applyBookingDoctor(BookingDoctorArgs args) {
    doctorId = args.doctorId;
    doctorName = args.doctorName;
    specialty = args.specialty;
    locationLine = args.locationLine;
    imageUrl = args.imageUrl;
    detectionPrice = args.detectionPrice;
    ratingAverage = args.ratingAverage;
    ratingQuantity = args.ratingQuantity;
    availableDateStrs = List<String>.from(args.availableDates);
    final parsed = BookingDraft.parseTimeStrings(args.availableTimes);
    timeSlots = parsed.isNotEmpty ? parsed : AppointmentTimeData.availableTimes;
    selectedDate = null;
    selectedTimeIndex = -1;
    notifyListeners();
  }

  List<DateTime> get dateList {
    final base = AppointmentCalendarLogic.getMonthDays(
      currentMonth,
      DateTime.now(),
    );
    if (availableDateStrs.isEmpty) {
      return base;
    }
    final allowed = availableDateStrs.toSet();
    final filtered = base
        .where((d) => allowed.contains(BookingDoctorArgs.dateKey(d)))
        .toList();
    return filtered.isNotEmpty ? filtered : base;
  }

  void goToPreviousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    selectedDate = null;
    notifyListeners();
  }

  void goToNextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    selectedDate = null;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void selectTime(int index) {
    selectedTimeIndex = index;
    notifyListeners();
  }

  bool get hasDoctor => doctorId != null && doctorId!.isNotEmpty;

  bool get canProceedToPayment {
    if (!hasDoctor) return false;
    if (selectedDate == null) return false;
    if (selectedTimeIndex < 0 || selectedTimeIndex >= timeSlots.length) {
      return false;
    }
    return true;
  }

  BookingDoctorArgs toDoctorArgs() {
    return BookingDoctorArgs(
      doctorId: doctorId ?? '',
      doctorName: doctorName,
      specialty: specialty,
      locationLine: locationLine,
      imageUrl: imageUrl,
      detectionPrice: detectionPrice,
      availableDates: availableDateStrs,
      availableTimes: timeSlots.map(BookingDraft.timeToApi).toList(),
    );
  }

  BookingDraft? buildDraftForPayment() {
    if (!canProceedToPayment) return null;
    final d = selectedDate!;
    return BookingDraft(
      doctor: toDoctorArgs(),
      dateIso: BookingDoctorArgs.dateKey(d),
      timeHm: BookingDraft.timeToApi(timeSlots[selectedTimeIndex]),
    );
  }
}
