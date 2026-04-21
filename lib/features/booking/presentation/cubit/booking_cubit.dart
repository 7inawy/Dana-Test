import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/booking_repo.dart';
import 'booking_state.dart';
import '../../data/models/booking_create_result.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo repo;
  String? _lastParentId;

  BookingCubit(this.repo) : super(BookingInitial());

  void reportLoadError(String message) => emit(BookingError(message));

  String _apiErrorMessage(Object e) {
    if (e is DioException) {
      final d = e.response?.data;
      if (d is Map) {
        final m = d['message']?.toString();
        if (m != null && m.isNotEmpty) return m;
        final resp = d['response'];
        if (resp is Map) {
          final m2 = resp['message']?.toString();
          if (m2 != null && m2.isNotEmpty) return m2;
        }
      }
      if (e.message != null && e.message!.isNotEmpty) return e.message!;
    }
    return e.toString();
  }

  Future<void> _reloadParentBookings(String parentId) async {
    _lastParentId = parentId;
    final list = await repo.getMyAppointmentsByParent(parentId: parentId);
    emit(BookingSuccess(list));
  }

  Future<BookingCreateResult?> createBooking({
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
    emit(BookingLoading());
    try {
      final result = await repo.createBooking(
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
      emit(BookingCreateSuccess(result));
      return result;
    } catch (e) {
      emit(BookingError(e.toString()));
      return null;
    }
  }

  Future<void> getBookings() async {
    emit(BookingLoading());

    try {
      final bookings = await repo.getBookings();
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> getMyAppointmentsByParent({required String parentId}) async {
    emit(BookingLoading());
    try {
      await _reloadParentBookings(parentId);
    } catch (e) {
      emit(BookingError(_apiErrorMessage(e)));
    }
  }

  Future<void> rateBooking({
    required String bookingId,
    required double rating,
  }) async {
    emit(BookingLoading());
    try {
      await repo.rateBooking(bookingId: bookingId, rating: rating.round());
      final pid = _lastParentId;
      if (pid != null && pid.isNotEmpty) {
        await _reloadParentBookings(pid);
      } else {
        await getBookings();
      }
    } catch (e) {
      emit(BookingError(_apiErrorMessage(e)));
    }
  }

  Future<void> getBookingById({required String bookingId}) async {
    emit(BookingLoading());
    try {
      final b = await repo.getBookingById(bookingId: bookingId);
      emit(BookingSingleSuccess(b));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  /// Cancels the booking for this child (backend: `DELETE …/cancel/child/:childId`).
  /// Prefer [cancelBookingById] when a booking id is known.
  Future<String?> cancelByChildId({required String childId}) async {
    emit(BookingLoading());
    final parentId = _lastParentId;
    try {
      await repo.cancelByChildId(childId: childId);
      if (parentId != null && parentId.isNotEmpty) {
        await _reloadParentBookings(parentId);
      } else {
        await getBookings();
      }
      return null;
    } catch (e) {
      final msg = _apiErrorMessage(e);
      if (parentId != null && parentId.isNotEmpty) {
        try {
          await _reloadParentBookings(parentId);
        } catch (_) {
          emit(BookingError(msg));
        }
      } else {
        emit(BookingError(msg));
      }
      return msg;
    }
  }

  /// Cancels a single appointment (`DELETE /v1/booking/:bookingId`).
  Future<String?> cancelBookingById({required String bookingId}) async {
    emit(BookingLoading());
    final parentId = _lastParentId;
    try {
      await repo.deleteBooking(bookingId: bookingId);
      if (parentId != null && parentId.isNotEmpty) {
        await _reloadParentBookings(parentId);
      } else {
        await getBookings();
      }
      return null;
    } catch (e) {
      final msg = _apiErrorMessage(e);
      if (parentId != null && parentId.isNotEmpty) {
        try {
          await _reloadParentBookings(parentId);
        } catch (_) {
          emit(BookingError(msg));
        }
      } else {
        emit(BookingError(msg));
      }
      return msg;
    }
  }

  /// Reschedules an existing booking (`PATCH /v1/booking/:bookingId`).
  /// Returns `null` on success, or an error message string on failure.
  Future<String?> changeAppointment({
    required String bookingId,
    required String doctorId,
    required String parentId,
    required String date,
    required String time,
  }) async {
    emit(BookingLoading());
    try {
      await repo.changeBookedAppointment(
        bookingId: bookingId,
        doctorId: doctorId,
        parentId: parentId,
        date: date,
        time: time,
      );
      await getMyAppointmentsByParent(parentId: parentId);
      return null;
    } catch (e) {
      final msg = _apiErrorMessage(e);
      try {
        await getMyAppointmentsByParent(parentId: parentId);
      } catch (_) {
        emit(BookingError(msg));
      }
      return msg;
    }
  }
}
