import 'package:dana/features/Appointments/presentation/views/appointments_screen.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/screens/payment_add_page.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/screens/payment_method_page.dart';
import 'package:dana/features/auth/login/presentation/views/screens/login/screens/login_screen.dart';
import 'package:dana/features/auth/signUp/presentation/views/screens/sign_up/views/screens/signUp_screen.dart';
import 'package:dana/features/home/presentation/screens/doctors_page.dart';
import 'package:dana/features/home/presentation/screens/home_screen.dart';

import 'package:dana/features/onboarding/presentation/views/screens/onboard_screen.dart';
import 'package:dana/features/splash/views/screens/splash_screen.dart';
import 'package:dana/features/child_profile/presentation/screens/child_profile_page.dart';
import 'package:dana/features/booking/presentation/views/DoctorTime/screens/doctor_time_screen.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/screens/Online_Payment_Screen.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/screens/Payment_Confirm_Screen.dart';
import 'package:dana/features/notification/presentation/screens/notification_screen.dart';
import 'package:dana/features/vaccinations/presentation/screens/vaccine_page.dart';

import '../../features/Chat_bot/presentation/views/screens/aI_Chat_Screen.dart';
import '../../features/Chat_bot/presentation/views/screens/ai_chat_history_screen.dart';
import '../../features/Chat_with_doctor/presentation/views/screens/Doctor_chat/screens/chat_screen.dart';
import '../../features/Examination/presentation/views/screens/examination_screen.dart';
import '../../features/auth/signUp/presentation/views/screens/add_children/views/screens/child_info_screen.dart';
import '../../features/auth/signUp/presentation/views/screens/contact_info/presentation/views/screens/contant_Info_screen.dart';
import '../../features/auth/signUp/presentation/views/screens/create_password/views/screens/create_password_screen.dart';
import '../../features/books/presentation/views/screens/books_screen.dart';
import '../../features/videos/presentation/views/screens/search_Screen.dart';
import '../../features/videos/presentation/views/screens/videos_Screen.dart';

class AppRoutes {
  static const String splash = SplashScreen.routeName;
  static const String onboarding = OnBoardScreen.routeName;

  /// Auth
  static const String login = LoginScreen.routeName;
  static const String signup = SignUpScreen.routeName;
  static const String childInfo = ChildInfoScreen.routeName;
  static const String contactInfo = ContactInfoScreen.routeName;
  static const String createPassword = CreatePasswordScreen.routeName;

  /// Google Auth
  static const String googleAuthWebView = 'GoogleAuthWebView';
  static const String googleComplete = 'GoogleComplete';
  static const String googleRequestId = 'GoogleRequestId';

  /// Home
  static const String home = HomeScreen.routeName;

  /// Booking
  static const String doctorTime = DoctorTimeScreen.routeName;
  // static const String reviewBooking = ReviewBookingScreen.routeName;

  /// Appointments
  static const String appointments = AppointmentsScreen.routeName;

  /// Chat
  static const String chatDoctor = ChatScreen.routeName;
  static const String aiChat = AIChatScreen.routeName;
  static const String aiChatHistory = AIChatHistoryScreen.routeName;

  /// Videos
  static const String videos = VideosScreen.routeName;
  static const String search = SearchScreen.routeName;

  /// Books
  static const String books = BooksScreen.routeName;

  /// Examination
  static const String examination = ExaminationScreen.routeName;

  /// Child Profile
  static const String childProfile = ChildProfileScreen.routeName;

  /// Vaccine
  static const String vaccine = VaccineScreen.routeName;

  /// Doctors
  static const String doctors = DoctorsScreen.routeName;

  /// Notification
  static const String notification = NotificationScreen.routeName;

  /// Payment
  static const String paymentMethod = PaymentMethodScreen.routeName;
  static const String paymentSuccessScreen = PaymentSuccessScreen.routeName;
  static const String onlinePaymentScreen = OnlinePaymentScreen.routeName;
  static const String paymentAddScreen = PaymentAddScreen.routeName;
}
