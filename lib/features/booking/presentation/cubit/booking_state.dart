import 'package:dana/features/booking/data/models/booking_model.dart';
import 'package:dana/features/booking/data/models/booking_create_result.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<Booking> bookings;

  BookingSuccess(this.bookings);
}

class BookingSingleSuccess extends BookingState {
  final Booking booking;

  BookingSingleSuccess(this.booking);
}

class BookingCreateSuccess extends BookingState {
  final BookingCreateResult result;

  BookingCreateSuccess(this.result);
}

class BookingError extends BookingState {
  final String error;

  BookingError(this.error);
}
