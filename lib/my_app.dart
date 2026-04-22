import 'package:dana/features/Appointments/logic/appointment_controller.dart';
import 'package:dana/features/Appointments/presentation/views/appointments_screen.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/screens/payment_add_page.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/screens/payment_method_page.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/core/utils/app_theme.dart';
import 'package:dana/features/auth/login/presentation/views/screens/forget_password/screens/forget_password_page.dart';
import 'package:dana/features/auth/login/presentation/views/screens/login/screens/login_screen.dart';
import 'package:dana/features/auth/login/presentation/views/screens/new_password/screens/new_password_screen.dart';
import 'package:dana/features/auth/login/presentation/views/screens/sign_up_wired/sign_up_wired_screen.dart';
import 'package:dana/features/auth/signUp/presentation/views/screens/sign_up/views/screens/signUp_screen.dart';
import 'package:dana/features/home/presentation/views/screens/doctors_page.dart';
import 'package:dana/features/home/presentation/views/screens/home_screen.dart';
import 'package:dana/features/onboarding/presentation/views/screens/onboard_screen.dart';
import 'package:dana/features/splash/views/screens/splash_screen.dart';
import 'package:dana/l10n/app_localizations.dart';
import 'package:dana/core/navigation/app_navigator.dart';
import 'package:dana/providers/app_language_provider.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/child_profile/child_profile_args.dart';
import 'package:dana/features/child_profile/presentation/screens/child_profile_page.dart';
import 'package:dana/features/booking/booking_flow_models.dart';
import 'package:dana/features/booking/presentation/views/DoctorTime/screens/doctor_Time_screen.dart';
import 'package:dana/features/booking/presentation/views/OnlinePayment/screens/Online_Payment_Screen.dart';
import 'package:dana/features/booking/presentation/views/BookingScreen/screens/Payment_Confirm_Screen.dart';
import 'package:dana/features/notification/presentation/screens/notification_screen.dart';
import 'package:dana/features/vaccinations/presentation/screens/vaccine_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'features/Chat_bot/presentation/controller/data/model/message_model.dart';
import 'features/Chat_bot/presentation/views/screens/aI_Chat_Screen.dart';
import 'features/Chat_with_doctor/presentation/views/screens/Doctor_chat/screens/chat_screen.dart';
import 'features/Examination/presentation/views/screens/examination_screen.dart';
import 'features/auth/signUp/presentation/views/screens/add_children/views/screens/child_info_screen.dart';
import 'features/auth/signUp/presentation/views/screens/contact_info/presentation/views/screens/contant_Info_screen.dart';
import 'features/books/presentation/views/screens/books_screen.dart';
import 'features/videos/presentation/views/screens/search_Screen.dart';
import 'features/videos/presentation/views/screens/videos_Screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<AppLanguageProvider>();
    final themeProvider = context.watch<AppThemeProvider>();

    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: AppNavigator.key,
          debugShowCheckedModeBanner: false,
          theme: MyThemeData.lightTheme,
          darkTheme: MyThemeData.darkTheme,
          themeMode: themeProvider.appTheme,
          locale: Locale(languageProvider.appLanguage),

          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },

          initialRoute: AppRoutes.splash,
          routes: _buildRoutes(),
          onGenerateRoute: (settings) {
            if (settings.name == ChatScreen.routeName) {
              return MaterialPageRoute<void>(
                builder: (ctx) {
                  final arg = settings.arguments;
                  final doctor = arg is Doctor ? arg : null;
                  return ChatScreen(doctor: doctor ?? getSampleDoctor(ctx));
                },
              );
            }
            return null;
          },
        );
      },
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      /// Core
      AppRoutes.splash: (_) => const SplashScreen(),
      AppRoutes.onboarding: (_) => const OnBoardScreen(),
      AppRoutes.home: (_) => HomeScreen(),

      /// Auth
      AppRoutes.login: (_) => const LoginScreen(),
      ForgetPasswordDialog.routeName: (_) => const ForgetPasswordDialog(),
      NewPasswordScreen.routeName: (_) => const NewPasswordScreen(),

      /// Sign Up
      AppRoutes.signup: (_) => const SignUpWiredScreen(),
      AppRoutes.createPassword: (_) => const SignUpScreen(),
      AppRoutes.childInfo: (ctx) => ChildInfoScreen(
        onNext: () => Navigator.pushNamed(ctx, AppRoutes.contactInfo),
      ),
      AppRoutes.contactInfo: (ctx) => ContactInfoScreen(
        onNext: () => Navigator.pushNamed(ctx, AppRoutes.createPassword),
      ),

      /// Booking
      AppRoutes.doctorTime: (ctx) {
        final args = ModalRoute.of(ctx)?.settings.arguments;
        return ChangeNotifierProvider(
          create: (_) {
            final c = AppointmentController();
            if (args is BookingDoctorArgs) {
              c.applyBookingDoctor(args);
            }
            return c;
          },
          child: const DoctorTimeScreen(),
        );
      },

      /// Appointments
      AppRoutes.appointments: (_) => AppointmentsScreen(),

      /// Chat (doctor chat uses [onGenerateRoute] + optional [Doctor] arguments)
      AIChatScreen.routeName: (context) =>
          AIChatScreen(doctor: getAIDoctor(context)),
      AppRoutes.videos: (_) => const VideosScreen(),
      AppRoutes.search: (_) => const SearchScreen(),

      /// Books
      AppRoutes.books: (_) => const BooksScreen(),

      /// Examination
      AppRoutes.examination: (_) => const ExaminationScreen(),

      /// Child Profile
      AppRoutes.childProfile: (context) {
        final raw = ModalRoute.of(context)?.settings.arguments;
        return ChildProfileScreen(args: raw is ChildProfileArgs ? raw : null);
      },

      /// Vaccine
      AppRoutes.vaccine: (context) {
        final id = ModalRoute.of(context)?.settings.arguments as String?;
        return VaccineScreen(childId: id);
      },

      /// Doctors
      AppRoutes.doctors: (_) => const DoctorsScreen(),

      /// Notification
      AppRoutes.notification: (_) => const NotificationScreen(),

      /// Payment
      AppRoutes.paymentMethod: (_) => const PaymentMethodScreen(),
      AppRoutes.paymentSuccessScreen: (_) => const PaymentSuccessScreen(),
      AppRoutes.onlinePaymentScreen: (_) => const OnlinePaymentScreen(),
      AppRoutes.paymentAddScreen: (_) => const PaymentAddScreen(),
    };
  }
}
