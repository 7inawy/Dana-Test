import 'package:dana/features/Appointments/logic/appointment_calendar_logic.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:flutter/material.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dio/dio.dart';

import '../../../core/api/api_endpoint.dart';
import '../../../core/api/api_response.dart';

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
  int experienceYears = 0;
  int? totalPatients;
  List<String> availableDateStrs = const [];
  List<TimeOfDay> timeSlots = const [];
  Map<String, List<String>> timesByDate = const {};
  Map<String, Set<String>> bookedTimesByDate = const {};
  Map<String, List<String>> availableTimesByDate = const {};
  Set<String> _selectedDateBookedTimes = const {};

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
    experienceYears = args.experienceYears;
    totalPatients = null;
    timesByDate = Map<String, List<String>>.from(args.timesByDate);
    bookedTimesByDate = {
      for (final e in args.bookedTimesByDate.entries)
        e.key: Set<String>.from(e.value),
    };
    availableDateStrs = timesByDate.isNotEmpty
        ? timesByDate.keys.toList()
        : List<String>.from(args.availableDates);
    // Slots should come from backend (`/available-slots?date=...`) for the
    // selected date, not from any prefilled/mock lists.
    timeSlots = const [];
    selectedDate = null;
    selectedTimeIndex = -1;
    _selectedDateBookedTimes = const {};
    notifyListeners();

    // Best-effort: public doctor list doesn't include patients count.
    // We'll try to fetch it from backend if the endpoint is accessible.
    _loadPatientsCount();
  }

  Future<void> refreshDoctorAvailability() async {
    final id = doctorId;
    if (id == null || id.isEmpty) return;
    try {
      final dio = sl<Dio>();
      final res = await dio.get('${ApiEndpoint.doctorById}$id');
      final decoded = ApiResponse.decode(res.data);
      final root = ApiResponse.unwrapMap(decoded);
      final av = root['availability'];
      if (av is! List) return;

      final nextTimesByDate = <String, List<String>>{};
      // Note: booked slots come from `/available-slots?date=...` (real-time),
      // not from the doctor object itself.

      for (final row in av) {
        if (row is! Map) continue;
        final date = row['date']?.toString() ?? '';
        if (date.isEmpty) continue;

        final timesRaw = row['times'];
        List<String> asStringList(dynamic v) {
          if (v is! List) return const [];
          return v.map((e) => e.toString()).toList();
        }

        final times = asStringList(timesRaw);
        nextTimesByDate[date] = times;
      }

      if (nextTimesByDate.isEmpty) return;

      timesByDate = nextTimesByDate;
      availableDateStrs = timesByDate.keys.toList();

      // Refresh selected date slots if already selected.
      final sel = selectedDate;
      if (sel != null) {
        await refreshAvailableSlotsForDate(sel);
      }

      notifyListeners();
    } catch (_) {
      // Silent: booking UI should still function with cached availability.
    }
  }

  Future<void> refreshAvailableSlotsForDate(DateTime date) async {
    final id = doctorId;
    if (id == null || id.isEmpty) return;
    final key = BookingDoctorArgs.dateKey(date);
    try {
      final dio = sl<Dio>();
      final res = await dio.get(
        ApiEndpoint.doctorAvailableSlotsPath(id, date: key),
      );
      final decoded = ApiResponse.decode(res.data);
      final data = ApiResponse.unwrapMap(decoded);

      List<String> asStringList(dynamic v) {
        if (v is! List) return const [];
        return v.map((e) => e.toString()).toList();
      }

      final availableTimes = asStringList(data['availableTimes']);
      final bookedTimes = asStringList(data['bookedTimes']).toSet();

      availableTimesByDate = {
        ...availableTimesByDate,
        key: availableTimes,
      };
      bookedTimesByDate = {
        ...bookedTimesByDate,
        key: bookedTimes,
      };

      // Show ONLY real available times returned by backend for the chosen date.
      timeSlots = BookingDraft.parseTimeStrings(availableTimes);
      // Keep bookedTimes for any UI logic that needs it (even though the grid
      // is driven by availableTimes only).
      _selectedDateBookedTimes = bookedTimes;
      selectedTimeIndex = -1;
      notifyListeners();
    } catch (_) {
      // Fallback: keep UI consistent by showing last known backend result.
      // If we don't have it cached, show nothing (avoid mock/fake slots).
      final cachedAvailable = availableTimesByDate[key] ?? const <String>[];
      timeSlots = BookingDraft.parseTimeStrings(cachedAvailable);
      _selectedDateBookedTimes = bookedTimesByDate[key] ?? const <String>{};
      selectedTimeIndex = -1;
      notifyListeners();
    }
  }

  Future<void> _loadPatientsCount() async {
    final id = doctorId;
    if (id == null || id.isEmpty) return;
    try {
      final dio = sl<Dio>();
      final res = await dio.post(ApiEndpoint.doctorPatientsGeneratePath(id));
      final data = res.data;
      int? count;
      if (data is Map) {
        final root = data['data'];
        if (root is Map) {
          final v = root['totalPatients'];
          if (v is num) count = v.toInt();
        }
      }
      if (count != null) {
        totalPatients = count;
        notifyListeners();
      }
    } catch (_) {
      // Silent: endpoint may be protected or unavailable for parent users.
    }
  }

  List<DateTime> get dateList {
    final base = AppointmentCalendarLogic.getMonthDays(
      currentMonth,
      DateTime.now(),
    );
    // Show only backend-provided available dates. No fallback to full month.
    if (availableDateStrs.isEmpty) return const <DateTime>[];
    final allowed = availableDateStrs.toSet();
    final filtered = base
        .where((d) => allowed.contains(BookingDoctorArgs.dateKey(d)))
        .toList();
    return filtered;
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
    final key = BookingDoctorArgs.dateKey(date);
    if (timesByDate.isNotEmpty && timesByDate.containsKey(key)) {
      selectedTimeIndex = -1;
    }
    notifyListeners();

    // Fetch real-time booked/available times for this date.
    refreshAvailableSlotsForDate(date);
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
    if (isTimeBooked(timeSlots[selectedTimeIndex])) return false;
    return true;
  }

  bool isDateFullyBooked(DateTime d) {
    final key = BookingDoctorArgs.dateKey(d);
    final offered = timesByDate[key];
    if (offered == null || offered.isEmpty) return false;
    final booked = bookedTimesByDate[key] ?? const {};
    return booked.length >= offered.length;
  }

  bool isTimeBooked(TimeOfDay t) {
    if (_selectedDateBookedTimes.isEmpty) return false;
    final api = BookingDraft.timeToApi(t);
    return _selectedDateBookedTimes.contains(api);
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
      timesByDate: timesByDate,
      bookedTimesByDate: bookedTimesByDate,
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
