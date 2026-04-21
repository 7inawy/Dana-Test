import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/booking_repo.dart';
import 'booking_state.dart';
import '../../data/models/booking_create_result.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo repo;
  String? _lastParentId;

  BookingCubit(this.repo) : super(BookingInitial());

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
      _lastParentId = parentId;
      final bookings = await repo.getMyAppointmentsByParent(parentId: parentId);
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> rateBooking({
    required String bookingId,
    required double rating,
  }) async {
    emit(BookingLoading());
    try {
      await repo.rateBooking(bookingId: bookingId, rating: rating.round());
      await getBookings();
    } catch (e) {
      emit(BookingError(e.toString()));
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

  Future<void> cancelByChildId({required String childId}) async {
    emit(BookingLoading());
    try {
      await repo.cancelByChildId(childId: childId);
      if (_lastParentId != null && _lastParentId!.isNotEmpty) {
        await getMyAppointmentsByParent(parentId: _lastParentId!);
      } else {
        await getBookings();
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> changeAppointment({
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
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
