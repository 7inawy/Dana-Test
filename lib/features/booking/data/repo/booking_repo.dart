import 'package:dio/dio.dart';

import '../services/booking_service.dart';
import '../models/booking_model.dart';
import '../models/booking_create_result.dart';
import '../../../../core/api/response_unwrap.dart';
import '../../../../core/api/api_response.dart';
import '../models/doctor_model.dart';

class BookingRepo {
  final BookingService service;

  BookingRepo(this.service);

  List<Booking> _parseBookings(dynamic root) {
    final list = ResponseUnwrap.unwrapList(root);
    return list
        .whereType<Map>()
        .map((e) => Booking.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Booking _parseBooking(dynamic root) {
    // Backend may return a 200 with an error envelope inside the body.
    // Example: { status: 500, message: "...", data: { response: { message: "Slot already booked" } } }
    if (root is Map && root['status'] == 500) {
      final data = root['data'];
      if (data is Map) {
        final resp = data['response'];
        final msg = resp is Map ? resp['message']?.toString() : null;
        if (msg != null && msg.isNotEmpty) {
          throw FormatException(msg);
        }
      }
    }
    final map = ResponseUnwrap.unwrapMap(root);
    return Booking.fromJson(map.cast<String, dynamic>());
  }

  Future<BookingCreateResult> createBooking({
    required String doctorId,
    required String parentId,
    required String childId,
    required String date,
    required String time,
    required String paymentMethod,
    required String visitStatus,
    required int detectionPrice,
    String? notes,
  }) async {
    final response = await service.createBooking(
      doctorId: doctorId,
      parentId: parentId,
      childId: childId,
      date: date,
      time: time,
      paymentMethod: paymentMethod,
      visitStatus: visitStatus,
      detectionPrice: detectionPrice,
      notes: notes,
    );

    final data = response.data;
    if (data is String && data.trim().startsWith('http')) {
      return BookingCreateResult.paymentUrl(data.trim());
    }

    final booking = _parseBooking(data);
    return BookingCreateResult.booking(booking);
  }

  Future<List<Booking>> getBookings() async {
    final response = await service.getBookings();
    return _parseBookings(response.data);
  }

  Future<List<Booking>> getMyAppointmentsByParent({
    required String parentId,
  }) async {
    final response = await service.getMyAppointmentsByParent(
      parentId: parentId,
    );
    final bookings = _parseBookings(response.data);
    // Backend may return `doctorId` as a string, so we enrich bookings with
    // doctor details to avoid showing mock placeholders in the UI.
    final needs = bookings.where((b) => b.doctor.name.trim().isEmpty && b.doctor.id.trim().isNotEmpty).toList();
    if (needs.isEmpty) return bookings;

    final byId = <String, Doctor>{};
    final failedIds = <String>{};
    for (final b in needs) {
      final did = b.doctor.id.trim();
      if (byId.containsKey(did) || failedIds.contains(did)) continue;
      try {
        final res = await service.getDoctorProfileForEnrichment(did);
        if (res.statusCode != 200) {
          failedIds.add(did);
          continue;
        }
        final decoded = ApiResponse.decode(res.data);
        final map = ApiResponse.unwrapMap(decoded);
        byId[did] = Doctor.fromJson(map);
      } catch (_) {
        failedIds.add(did);
      }
    }

    if (byId.isEmpty) return bookings;
    return bookings
        .map((b) {
          final did = b.doctor.id.trim();
          final d = byId[did];
          // One shared [Doctor] instance across many bookings confused debugging and
          // could interact badly with future equality/cache work; clone per row.
          return d == null ? b : b.copyWith(doctor: d.copyWith());
        })
        .toList();
  }

  Future<List<Booking>> getDoctorAppointments({required String doctorId}) async {
    final response = await service.getDoctorAppointments(doctorId: doctorId);
    return _parseBookings(response.data);
  }

  Future<List<Booking>> getTodayDoctorAppointments({
    required String doctorId,
  }) async {
    final response =
        await service.getTodayDoctorAppointments(doctorId: doctorId);
    return _parseBookings(response.data);
  }

  Future<void> rateBooking({
    required String bookingId,
    required num rating,
  }) async {
    try {
      await service.rateBooking(bookingId: bookingId, rating: rating);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final isValidation = code == 400 || code == 409 || code == 422;
      final isNonInt = rating is double && rating % 1 != 0;
      if (isValidation && isNonInt) {
        await service.rateBooking(
          bookingId: bookingId,
          rating: rating.round(),
        );
        return;
      }
      rethrow;
    }
  }

  Future<Booking> getBookingById({required String bookingId}) async {
    final response = await service.getBookingById(bookingId: bookingId);
    return _parseBooking(response.data);
  }

  Future<Booking> cancelByChildId({required String childId}) async {
    final response = await service.cancelByChildId(childId: childId);
    return _parseBooking(response.data);
  }

  Future<Booking> changeBookedAppointment({
    required String bookingId,
    required String doctorId,
    required String parentId,
    required String date,
    required String time,
  }) async {
    final response = await service.changeBookedAppointment(
      bookingId: bookingId,
      doctorId: doctorId,
      parentId: parentId,
      date: date,
      time: time,
    );
    return _parseBooking(response.data);
  }

  Future<void> deleteBooking({required String bookingId}) async {
    await service.deleteBooking(bookingId: bookingId);
  }
}
