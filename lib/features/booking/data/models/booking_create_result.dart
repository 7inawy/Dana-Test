import 'booking_model.dart';

class BookingCreateResult {
  final Booking? booking;
  final String? paymentUrl;

  const BookingCreateResult._({this.booking, this.paymentUrl});

  const BookingCreateResult.booking(Booking booking) : this._(booking: booking);

  const BookingCreateResult.paymentUrl(String url) : this._(paymentUrl: url);

  bool get isPaymentRequired => paymentUrl != null && paymentUrl!.isNotEmpty;
}
