import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoint.dart';

class BookingService {
  final Dio dio;

  BookingService(this.dio);

  Future<Response> createBooking({
    required String doctorId,
    required String parentId,
    required String childId,
    required String date,
    required String time,
    required String paymentMethod,
    required String visitStatus,
    required int detectionPrice,
    String? notes,
  }) {
    return dio.post(
      ApiEndpoint.createBooking,
      data: {
        'doctorId': doctorId,
        'parentId': parentId,
        'childId': childId,
        'date': date,
        'time': time,
        'paymentMethod': paymentMethod,
        'visitStatus': visitStatus,
        'detectionPrice': detectionPrice,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<Response> getBookings() async {
    return dio.get(ApiEndpoint.getAllBookings);
  }

  Future<Response> getMyAppointmentsByParent({required String parentId}) {
    return dio.get('${ApiEndpoint.myAppointmentsByParent}$parentId');
  }

  Future<Response> rateBooking({
    required String bookingId,
    required int rating,
  }) {
    return dio.post(
      "/v1/booking/$bookingId/rate",
      data: {"rating": rating},
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  Future<Response> getBookingById({required String bookingId}) {
    return dio.get("/v1/booking/$bookingId");
  }

  Future<Response> cancelByChildId({required String childId}) {
    return dio.delete("/v1/booking/cancel/child/$childId");
  }

  Future<Response> changeBookedAppointment({
    required String bookingId,
    required String doctorId,
    required String parentId,
    required String date,
    required String time,
  }) {
    return dio.patch(
      "/v1/booking/$bookingId",
      data: {
        "doctorId": doctorId,
        "parentId": parentId,
        "date": date,
        "time": time,
      },
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  Future<Response> deleteBooking({required String bookingId}) {
    // Matches Postman "delete-appointment": DELETE /v1/booking/:id
    return dio.delete('${ApiEndpoint.bookingById}$bookingId');
  }
}
