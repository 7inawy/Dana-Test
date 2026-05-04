import '../../Chat_bot/presentation/controller/data/model/message_model.dart';

class ChatDoctorArgs {
  final String bookingId;
  final Doctor doctor;

  const ChatDoctorArgs({
    required this.bookingId,
    required this.doctor,
  });
}

