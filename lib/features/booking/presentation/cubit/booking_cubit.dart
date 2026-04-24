import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dana/core/errors/error_mapper.dart';
import '../../data/repo/booking_repo.dart';
import 'booking_state.dart';
import '../../data/models/booking_create_result.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo repo;
  String? _lastParentId;
  String? _lastDoctorId;

  BookingCubit(this.repo) : super(BookingInitial());

  void reportLoadError(String message) => emit(BookingError(message));

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
      emit(BookingError(ErrorMapper.message(e)));
      return null;
    }
  }

  Future<void> getBookings() async {
    emit(BookingLoading());

    try {
      final bookings = await repo.getBookings();
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingError(ErrorMapper.message(e)));
    }
  }

  Future<void> getMyAppointmentsByParent({required String parentId}) async {
    emit(BookingLoading());
    try {
      await _reloadParentBookings(parentId);
    } catch (e) {
      emit(BookingError(ErrorMapper.message(e)));
    }
  }

  Future<void> getDoctorAppointments({required String doctorId}) async {
    emit(BookingLoading());
    _lastDoctorId = doctorId;
    try {
      final bookings = await repo.getDoctorAppointments(doctorId: doctorId);
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingError(ErrorMapper.message(e)));
    }
  }

  Future<void> getTodayDoctorAppointments({required String doctorId}) async {
    emit(BookingLoading());
    _lastDoctorId = doctorId;
    try {
      final bookings = await repo.getTodayDoctorAppointments(doctorId: doctorId);
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingError(ErrorMapper.message(e)));
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
      } else if (_lastDoctorId != null && _lastDoctorId!.isNotEmpty) {
        final did = _lastDoctorId!;
        final list = await repo.getDoctorAppointments(doctorId: did);
        emit(BookingSuccess(list));
      } else {
        await getBookings();
      }
    } catch (e) {
      emit(BookingError(ErrorMapper.message(e)));
    }
  }

  Future<void> getBookingById({required String bookingId}) async {
    emit(BookingLoading());
    try {
      final b = await repo.getBookingById(bookingId: bookingId);
      emit(BookingSingleSuccess(b));
    } catch (e) {
      emit(BookingError(ErrorMapper.message(e)));
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
      final msg = ErrorMapper.message(e);
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
      final msg = ErrorMapper.message(e);
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
      final msg = ErrorMapper.message(e);
      try {
        await getMyAppointmentsByParent(parentId: parentId);
      } catch (_) {
        emit(BookingError(msg));
      }
      return msg;
    }
  }
}
