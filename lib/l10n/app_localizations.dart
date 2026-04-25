import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @dana.
  ///
  /// In en, this message translates to:
  /// **'Dana'**
  String get dana;

  /// No description provided for @myBabyHealth.
  ///
  /// In en, this message translates to:
  /// **'My Baby Health'**
  String get myBabyHealth;

  /// No description provided for @babyHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Baby Health Record'**
  String get babyHealthRecord;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @relatedVideos.
  ///
  /// In en, this message translates to:
  /// **'Related Videos'**
  String get relatedVideos;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'You can find the videos you need through search'**
  String get searchHint;

  /// No description provided for @doctorConsult.
  ///
  /// In en, this message translates to:
  /// **'Doctor Consult'**
  String get doctorConsult;

  /// No description provided for @guideBooks.
  ///
  /// In en, this message translates to:
  /// **'Complete Awareness Guide'**
  String get guideBooks;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// Bottom navigation home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @ageFormat.
  ///
  /// In en, this message translates to:
  /// **'{years} years and {months} months'**
  String ageFormat(Object years, Object months);

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get kg;

  /// No description provided for @headCircumference.
  ///
  /// In en, this message translates to:
  /// **'Head circumference'**
  String get headCircumference;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @checkYourChild.
  ///
  /// In en, this message translates to:
  /// **'Check Your Child'**
  String get checkYourChild;

  /// No description provided for @booksAndArticles.
  ///
  /// In en, this message translates to:
  /// **'Books & Articles'**
  String get booksAndArticles;

  /// No description provided for @vaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinations;

  /// No description provided for @alwaysBestForChildCare.
  ///
  /// In en, this message translates to:
  /// **'Always the best for your child’s care'**
  String get alwaysBestForChildCare;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @dr.
  ///
  /// In en, this message translates to:
  /// **'Dr.'**
  String get dr;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @physiotherapist.
  ///
  /// In en, this message translates to:
  /// **'Physiotherapist'**
  String get physiotherapist;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @addNewChild.
  ///
  /// In en, this message translates to:
  /// **'Add New Child'**
  String get addNewChild;

  /// No description provided for @addChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Your Children and Start Your Journey with Them'**
  String get addChildTitle;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @yearSingular.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get yearSingular;

  /// No description provided for @yearDual.
  ///
  /// In en, this message translates to:
  /// **'2 years'**
  String get yearDual;

  /// No description provided for @yearPlural.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String yearPlural(Object years);

  /// No description provided for @monthSingular.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get monthSingular;

  /// No description provided for @monthDual.
  ///
  /// In en, this message translates to:
  /// **'2 months'**
  String get monthDual;

  /// No description provided for @monthPlural.
  ///
  /// In en, this message translates to:
  /// **'{months} months'**
  String monthPlural(Object months);

  /// No description provided for @ageFormatBoth.
  ///
  /// In en, this message translates to:
  /// **'{years} and {months}'**
  String ageFormatBoth(Object years, Object months);

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @growthTracking.
  ///
  /// In en, this message translates to:
  /// **'Growth tracking'**
  String get growthTracking;

  /// No description provided for @danaChat.
  ///
  /// In en, this message translates to:
  /// **'Dana chat'**
  String get danaChat;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettingsTitle;

  /// No description provided for @accountSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Help us keep your data accurate and secure. Choose the action you want.'**
  String get accountSettingsDesc;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Information'**
  String get editProfileTitle;

  /// No description provided for @editProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your information is always accurate and up to date so we can better assist you.'**
  String get editProfileDesc;

  /// No description provided for @editData.
  ///
  /// In en, this message translates to:
  /// **'Edit Data'**
  String get editData;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'To keep your account secure, we need to verify that you own this number. Enter your phone number and we will send you a verification code to reset your password.'**
  String get changePasswordDesc;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageTitle;

  /// No description provided for @languageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the language that suits you and makes tracking your children\'s health easier.'**
  String get languageDesc;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'Arabic Language'**
  String get arabicLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English Language'**
  String get englishLanguage;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @techSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical support'**
  String get techSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'App Appearance'**
  String get themeTitle;

  /// No description provided for @themeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the appearance that suits your comfort and eye relaxation.'**
  String get themeDesc;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode (Day)'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode (Night)'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemMode;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutTitle;

  /// No description provided for @logoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s data is safely stored. To keep tracking vaccinations, it\'s better to stay logged in.'**
  String get logoutDesc;

  /// No description provided for @stayButton.
  ///
  /// In en, this message translates to:
  /// **'Stay Logged In'**
  String get stayButton;

  /// No description provided for @confirmLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogoutButton;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @appointmentsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get appointmentsUpcoming;

  /// No description provided for @changeAppointment.
  ///
  /// In en, this message translates to:
  /// **'Change appointment'**
  String get changeAppointment;

  /// No description provided for @needBetterTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Need a better time?'**
  String get needBetterTimeTitle;

  /// No description provided for @needBetterTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'You can cancel your current appointment and choose another time that fits your schedule in one step, because your comfort and your child\'s comfort always matter to us.'**
  String get needBetterTimeDesc;

  /// No description provided for @confirmNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm new appointment'**
  String get confirmNewAppointment;

  /// No description provided for @selectAppointment.
  ///
  /// In en, this message translates to:
  /// **'Select appointment'**
  String get selectAppointment;

  /// No description provided for @availableTime.
  ///
  /// In en, this message translates to:
  /// **'Available Time'**
  String get availableTime;

  /// No description provided for @reviewBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Booking'**
  String get reviewBookingTitle;

  /// No description provided for @reviewBookingDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure all details are correct before confirming.'**
  String get reviewBookingDesc;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @confirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming...'**
  String get confirming;

  /// No description provided for @visitTypeExam.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get visitTypeExam;

  /// No description provided for @visitTypeFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get visitTypeFollowUp;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelAppointment;

  /// No description provided for @appointmentsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get appointmentsCompleted;

  /// No description provided for @rebook.
  ///
  /// In en, this message translates to:
  /// **'Rebook'**
  String get rebook;

  /// No description provided for @followUpAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Set follow-up appointment'**
  String get followUpAppointmentTitle;

  /// No description provided for @followUpAppointmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow-up makes a big difference! Book your follow-up session now and track your child\'s progress with the same doctor. Step by step, we are with you.'**
  String get followUpAppointmentDesc;

  /// No description provided for @bookFollowUpSession.
  ///
  /// In en, this message translates to:
  /// **'Book follow-up session'**
  String get bookFollowUpSession;

  /// No description provided for @rateDoctor.
  ///
  /// In en, this message translates to:
  /// **'Rate doctor'**
  String get rateDoctor;

  /// No description provided for @rateDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your consultation?'**
  String get rateDoctorTitle;

  /// No description provided for @rateDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'We’d love your feedback on your experience with Dr. Islam Ghoneim. Your rating helps us improve care.'**
  String get rateDoctorDesc;

  /// No description provided for @ratingNotAllowedTitle.
  ///
  /// In en, this message translates to:
  /// **'Rating not available yet'**
  String get ratingNotAllowedTitle;

  /// No description provided for @ratingNotAllowedDesc.
  ///
  /// In en, this message translates to:
  /// **'You can rate the doctor only after the appointment is completed.'**
  String get ratingNotAllowedDesc;

  /// No description provided for @ratingSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t submit your rating right now. Please try again later.'**
  String get ratingSubmitFailed;

  /// No description provided for @sendRating.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get sendRating;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @appointmentsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointmentsCancelled;

  /// No description provided for @changeAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue the journey?'**
  String get changeAppointmentTitle;

  /// No description provided for @changeAppointmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s journey continues. Choose a time that suits you to continue your progress.'**
  String get changeAppointmentDesc;

  /// No description provided for @selectNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'Select new appointment'**
  String get selectNewAppointment;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get notificationsNew;

  /// No description provided for @notificationsOld.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsOld;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications yet.'**
  String get notificationsEmpty;

  /// No description provided for @doctorsListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No doctors to show yet.'**
  String get doctorsListEmpty;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @vaccineReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination appointment today!'**
  String get vaccineReminderTitle;

  /// No description provided for @vaccineReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Our little hero Noah has a vaccination appointment today (Pentavalent vaccine). This is a very important step for his immunity. Let us know, did he take it?'**
  String get vaccineReminderDesc;

  /// No description provided for @consultationReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your consultation is soon'**
  String get consultationReminderTitle;

  /// No description provided for @consultationReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminder for your follow-up session with Dr. [Doctor Name] tomorrow at 4 PM. Prepare your questions, we are always with you.'**
  String get consultationReminderDesc;

  /// No description provided for @supportSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Support session'**
  String get supportSessionTitle;

  /// No description provided for @supportSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'We look forward to meeting you in tomorrow’s live support session to discuss your progress.'**
  String get supportSessionDesc;

  /// No description provided for @appointmentReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminder'**
  String get appointmentReminderTitle;

  /// No description provided for @appointmentReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Don’t forget that follow-up appointments are very important. Be ready to share any updates or questions with Dr. [Doctor Name] tomorrow.'**
  String get appointmentReminderDesc;

  /// No description provided for @feedbackSurveyTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback survey'**
  String get feedbackSurveyTitle;

  /// No description provided for @feedbackSurveyDesc.
  ///
  /// In en, this message translates to:
  /// **'After the session, we will send you a satisfaction survey. Your feedback helps us improve our service.'**
  String get feedbackSurveyDesc;

  /// No description provided for @prepareDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare documents'**
  String get prepareDocumentsTitle;

  /// No description provided for @prepareDocumentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure to prepare all required documents for the follow-up session. This will help us provide the best support.'**
  String get prepareDocumentsDesc;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @faqDesc.
  ///
  /// In en, this message translates to:
  /// **'For more information, you can check the frequently asked questions available on our website.'**
  String get faqDesc;

  /// No description provided for @statusUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Status updates'**
  String get statusUpdatesTitle;

  /// No description provided for @statusUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'We will send regular updates about your status via email. Please check your inbox.'**
  String get statusUpdatesDesc;

  /// No description provided for @supportProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Support program'**
  String get supportProgramTitle;

  /// No description provided for @supportProgramDesc.
  ///
  /// In en, this message translates to:
  /// **'We are pleased to announce the launch of a new support program aimed at improving quality of life.'**
  String get supportProgramDesc;

  /// No description provided for @personalConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal consultation'**
  String get personalConsultationTitle;

  /// No description provided for @personalConsultationDesc.
  ///
  /// In en, this message translates to:
  /// **'If you have any specific questions, you can book a personal consultation with Dr. [Doctor Name].'**
  String get personalConsultationDesc;

  /// No description provided for @additionalResourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional resources'**
  String get additionalResourcesTitle;

  /// No description provided for @additionalResourcesDesc.
  ///
  /// In en, this message translates to:
  /// **'You can explore a collection of helpful additional resources on our website.'**
  String get additionalResourcesDesc;

  /// No description provided for @shareExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get shareExperienceTitle;

  /// No description provided for @shareExperienceDesc.
  ///
  /// In en, this message translates to:
  /// **'We invite you to share your experiences with others in the upcoming session.'**
  String get shareExperienceDesc;

  /// No description provided for @confirmAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm attendance'**
  String get confirmAttendanceTitle;

  /// No description provided for @confirmAttendanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your attendance via the link sent to you.'**
  String get confirmAttendanceDesc;

  /// No description provided for @billingReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing review'**
  String get billingReviewTitle;

  /// No description provided for @billingReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure to review your service invoices and contact us if you have any questions.'**
  String get billingReviewDesc;

  /// No description provided for @availableServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Available services'**
  String get availableServicesTitle;

  /// No description provided for @availableServicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore all the services we offer and how we can help you achieve your goals.'**
  String get availableServicesDesc;

  /// No description provided for @vaccineWarningDescription.
  ///
  /// In en, this message translates to:
  /// **'The vaccination schedule shown here matches the latest official mandatory schedules, helping you track your child\'s protection with full confidence and safety.'**
  String get vaccineWarningDescription;

  /// No description provided for @vaccineDelayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get vaccineDelayed;

  /// No description provided for @vaccineTaken.
  ///
  /// In en, this message translates to:
  /// **'Dose Taken'**
  String get vaccineTaken;

  /// No description provided for @vaccineNotTaken.
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get vaccineNotTaken;

  /// No description provided for @vaccineSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'A new protection step completed!'**
  String get vaccineSuccessTitle;

  /// No description provided for @vaccineSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Well done! Save the vaccination date to track upcoming doses accurately.'**
  String get vaccineSuccessDesc;

  /// No description provided for @vaccineDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Date'**
  String get vaccineDateLabel;

  /// No description provided for @vaccineDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get vaccineDateHint;

  /// No description provided for @saveToRecord.
  ///
  /// In en, this message translates to:
  /// **'Save to record'**
  String get saveToRecord;

  /// No description provided for @vaccineAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit the nearest health unit'**
  String get vaccineAlertTitle;

  /// No description provided for @vaccineAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'No worries.. this vaccine is important for immunity. Please visit the nearest health unit as soon as possible.'**
  String get vaccineAlertDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @vaccinePolioZeroDose.
  ///
  /// In en, this message translates to:
  /// **'Polio Vaccine (Zero Dose)'**
  String get vaccinePolioZeroDose;

  /// No description provided for @vaccineHepBZeroDose.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B Vaccine (Zero Dose)'**
  String get vaccineHepBZeroDose;

  /// No description provided for @vaccineBCG.
  ///
  /// In en, this message translates to:
  /// **'BCG Vaccine'**
  String get vaccineBCG;

  /// No description provided for @vaccinePolioSabin.
  ///
  /// In en, this message translates to:
  /// **'Polio Vaccine (Sabin)'**
  String get vaccinePolioSabin;

  /// No description provided for @vaccinePolioSalk.
  ///
  /// In en, this message translates to:
  /// **'Polio Vaccine (Salk)'**
  String get vaccinePolioSalk;

  /// No description provided for @vaccinePentavalent.
  ///
  /// In en, this message translates to:
  /// **'Pentavalent Vaccine'**
  String get vaccinePentavalent;

  /// No description provided for @vaccinePolioNineMonths.
  ///
  /// In en, this message translates to:
  /// **'Polio Vaccine (9 Months Dose)'**
  String get vaccinePolioNineMonths;

  /// No description provided for @vaccineDescPolioZeroDose.
  ///
  /// In en, this message translates to:
  /// **'Protection for the nervous system within the first 24 hours after birth.'**
  String get vaccineDescPolioZeroDose;

  /// No description provided for @vaccineDescHepBZeroDose.
  ///
  /// In en, this message translates to:
  /// **'Essential protection within the first 40 days, given as an injection.'**
  String get vaccineDescHepBZeroDose;

  /// No description provided for @vaccineDescBCG.
  ///
  /// In en, this message translates to:
  /// **'Essential protection against TB in early life.'**
  String get vaccineDescBCG;

  /// No description provided for @vaccineDescPolioTwoMonths.
  ///
  /// In en, this message translates to:
  /// **'A booster dose at 2 months to strengthen immunity.'**
  String get vaccineDescPolioTwoMonths;

  /// No description provided for @vaccineDescSalk.
  ///
  /// In en, this message translates to:
  /// **'Additional protection dose at 2 months injected in the thigh.'**
  String get vaccineDescSalk;

  /// No description provided for @vaccineDescPentavalent.
  ///
  /// In en, this message translates to:
  /// **'One injection protecting against 5 diseases at 2 months.'**
  String get vaccineDescPentavalent;

  /// No description provided for @vaccineDescNineMonths.
  ///
  /// In en, this message translates to:
  /// **'A booster dose at 9 months to maintain strong immunity.'**
  String get vaccineDescNineMonths;

  /// No description provided for @childWorldTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Child’s World'**
  String get childWorldTitle;

  /// No description provided for @growthIndicator.
  ///
  /// In en, this message translates to:
  /// **'Growth Indicator'**
  String get growthIndicator;

  /// No description provided for @growthStatusHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy and growing normally'**
  String get growthStatusHealthy;

  /// No description provided for @currentMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Current Measurements'**
  String get currentMeasurements;

  /// No description provided for @growthCurveTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Curve'**
  String get growthCurveTitle;

  /// No description provided for @updateData.
  ///
  /// In en, this message translates to:
  /// **'Update Data'**
  String get updateData;

  /// No description provided for @updateChildMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Update {childName}\'s Measurements'**
  String updateChildMeasurements(Object childName);

  /// No description provided for @updateDataTitle.
  ///
  /// In en, this message translates to:
  /// **'How is your child doing today?'**
  String get updateDataTitle;

  /// No description provided for @updateDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your data is always accurate and up to date so we can help you.'**
  String get updateDataDesc;

  /// No description provided for @exampleValue.
  ///
  /// In en, this message translates to:
  /// **'Example: 12'**
  String get exampleValue;

  /// No description provided for @saveNewMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Save New Measurements'**
  String get saveNewMeasurements;

  /// No description provided for @growthCelebrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Growing before our eyes!'**
  String get growthCelebrationTitle;

  /// No description provided for @growthSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Great job! The child\'s new measurements have been safely saved. Regular tracking of weight and height is important for healthy growth.'**
  String get growthSavedMessage;

  /// No description provided for @growthDuplicateMonth.
  ///
  /// In en, this message translates to:
  /// **'Growth data for this calendar month is already saved. You can add a new measurement next month.'**
  String get growthDuplicateMonth;

  /// No description provided for @growthNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Child data is not ready. Please try again.'**
  String get growthNotLoaded;

  /// No description provided for @addChildMissingFields.
  ///
  /// In en, this message translates to:
  /// **'Enter the child\'s name and birth date.'**
  String get addChildMissingFields;

  /// No description provided for @addChildMinimumAge.
  ///
  /// In en, this message translates to:
  /// **'The child must be at least one month old.'**
  String get addChildMinimumAge;

  /// No description provided for @parentPhotoNoProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile is not loaded. Open the profile tab and try again.'**
  String get parentPhotoNoProfile;

  /// No description provided for @newSkills.
  ///
  /// In en, this message translates to:
  /// **'New Skills'**
  String get newSkills;

  /// No description provided for @childGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Growing and learning every day'**
  String get childGrowthTitle;

  /// No description provided for @skillMotor.
  ///
  /// In en, this message translates to:
  /// **'Motor skills & activity'**
  String get skillMotor;

  /// No description provided for @skillSpeech.
  ///
  /// In en, this message translates to:
  /// **'Speech & expression'**
  String get skillSpeech;

  /// No description provided for @skillCognition.
  ///
  /// In en, this message translates to:
  /// **'Understanding & cognition'**
  String get skillCognition;

  /// No description provided for @skillSocial.
  ///
  /// In en, this message translates to:
  /// **'Social & emotions'**
  String get skillSocial;

  /// No description provided for @developmentJourney.
  ///
  /// In en, this message translates to:
  /// **'Development Journey'**
  String get developmentJourney;

  /// No description provided for @skill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get skill;

  /// No description provided for @skillMotorDesc.
  ///
  /// In en, this message translates to:
  /// **'His movement and physical development day by day'**
  String get skillMotorDesc;

  /// No description provided for @motorBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Motor Development'**
  String get motorBottomTitle;

  /// No description provided for @motorBottomDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell us, what new things has your child started doing recently? (You can select more than one skill… every child develops at their own pace.)'**
  String get motorBottomDesc;

  /// No description provided for @motorItem1.
  ///
  /// In en, this message translates to:
  /// **'Walks and runs steadily without falling.'**
  String get motorItem1;

  /// No description provided for @motorItem2.
  ///
  /// In en, this message translates to:
  /// **'Can go up and down the stairs on his own.'**
  String get motorItem2;

  /// No description provided for @motorItem3.
  ///
  /// In en, this message translates to:
  /// **'Can jump in place using both feet.'**
  String get motorItem3;

  /// No description provided for @motorItem4.
  ///
  /// In en, this message translates to:
  /// **'Holds a pencil and tries to scribble clearly.'**
  String get motorItem4;

  /// No description provided for @skillSpeechDesc.
  ///
  /// In en, this message translates to:
  /// **'His new words and how he communicates'**
  String get skillSpeechDesc;

  /// No description provided for @speechBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Speech & Expression'**
  String get speechBottomTitle;

  /// No description provided for @speechBottomDesc.
  ///
  /// In en, this message translates to:
  /// **'Every new word is an achievement… share your child’s speech progress. (You can select more than one skill… every child develops at their own pace.)'**
  String get speechBottomDesc;

  /// No description provided for @speechItem1.
  ///
  /// In en, this message translates to:
  /// **'Can say his first name and age when asked.'**
  String get speechItem1;

  /// No description provided for @speechItem2.
  ///
  /// In en, this message translates to:
  /// **'Can form simple sentences of 3 to 4 words.'**
  String get speechItem2;

  /// No description provided for @speechItem3.
  ///
  /// In en, this message translates to:
  /// **'Strangers can understand most of what he says.'**
  String get speechItem3;

  /// No description provided for @speechItem4.
  ///
  /// In en, this message translates to:
  /// **'Started asking many questions like \"Why?\" and \"What’s this?\".'**
  String get speechItem4;

  /// No description provided for @skillCognitionDesc.
  ///
  /// In en, this message translates to:
  /// **'His understanding and how he explores the world around him'**
  String get skillCognitionDesc;

  /// No description provided for @cognitionBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Exploring the World'**
  String get cognitionBottomTitle;

  /// No description provided for @cognitionBottomDesc.
  ///
  /// In en, this message translates to:
  /// **'Their mind is growing and understanding more… what skills have you noticed recently? (You can select more than one skill… every child develops at their own pace.)'**
  String get cognitionBottomDesc;

  /// No description provided for @cognitionItem1.
  ///
  /// In en, this message translates to:
  /// **'Can match shapes and colors together.'**
  String get cognitionItem1;

  /// No description provided for @cognitionItem2.
  ///
  /// In en, this message translates to:
  /// **'Can complete a simple puzzle (3–4 pieces).'**
  String get cognitionItem2;

  /// No description provided for @cognitionItem3.
  ///
  /// In en, this message translates to:
  /// **'Remembers where his toys and favorite items are at home.'**
  String get cognitionItem3;

  /// No description provided for @cognitionItem4.
  ///
  /// In en, this message translates to:
  /// **'Understands simple instructions like \"Bring the ball\".'**
  String get cognitionItem4;

  /// No description provided for @skillSocialDesc.
  ///
  /// In en, this message translates to:
  /// **'His interactions and emotional development'**
  String get skillSocialDesc;

  /// No description provided for @socialBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotions & Social Skills'**
  String get socialBottomTitle;

  /// No description provided for @socialBottomDesc.
  ///
  /// In en, this message translates to:
  /// **'Their personality is growing… what changes have you noticed in their interactions? (You can select more than one skill… every child develops at their own pace.)'**
  String get socialBottomDesc;

  /// No description provided for @socialItem1.
  ///
  /// In en, this message translates to:
  /// **'Enjoys playing with other children (not just alone).'**
  String get socialItem1;

  /// No description provided for @socialItem2.
  ///
  /// In en, this message translates to:
  /// **'Understands the idea of taking turns.'**
  String get socialItem2;

  /// No description provided for @socialItem3.
  ///
  /// In en, this message translates to:
  /// **'Shows empathy when another child is upset.'**
  String get socialItem3;

  /// No description provided for @socialItem4.
  ///
  /// In en, this message translates to:
  /// **'Tries to be independent (like eating on his own).'**
  String get socialItem4;

  /// No description provided for @saveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save progress'**
  String get saveProgress;

  /// No description provided for @growthConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'A new step in his journey!'**
  String get growthConfirmTitle;

  /// No description provided for @growthConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Well done… we’ve successfully saved his new skills. Every day he grows and learns something new, and we’re proud to follow this journey with you.'**
  String get growthConfirmDesc;

  /// No description provided for @nextVaccineTitle.
  ///
  /// In en, this message translates to:
  /// **'Next vaccine'**
  String get nextVaccineTitle;

  /// No description provided for @mmrVaccineName.
  ///
  /// In en, this message translates to:
  /// **'MMR vaccine'**
  String get mmrVaccineName;

  /// No description provided for @vaccineTimeInfo.
  ///
  /// In en, this message translates to:
  /// **'in {days} days ({date})'**
  String vaccineTimeInfo(Object date, Object days);

  /// No description provided for @fullVaccinationRecord.
  ///
  /// In en, this message translates to:
  /// **'Full vaccination record'**
  String get fullVaccinationRecord;

  /// No description provided for @responseRarely.
  ///
  /// In en, this message translates to:
  /// **'Rarely / Never'**
  String get responseRarely;

  /// No description provided for @responseSometimes.
  ///
  /// In en, this message translates to:
  /// **'Sometimes'**
  String get responseSometimes;

  /// No description provided for @responseAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get responseAlways;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get views;

  /// No description provided for @doctorSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Physical Therapy Specialist'**
  String get doctorSpecialty;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @writeMessage.
  ///
  /// In en, this message translates to:
  /// **'Write a message to the doctor'**
  String get writeMessage;

  /// No description provided for @endToEndEncrypted.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted.'**
  String get endToEndEncrypted;

  /// No description provided for @encryptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Messages are secured with end-to-end encryption.'**
  String get encryptionSubtitle;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @messageRead.
  ///
  /// In en, this message translates to:
  /// **'Read at'**
  String get messageRead;

  /// No description provided for @warningTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get warningTitle;

  /// No description provided for @aiAssistantName.
  ///
  /// In en, this message translates to:
  /// **'Dana AI Assistant'**
  String get aiAssistantName;

  /// No description provided for @suggestedQuestionsHint.
  ///
  /// In en, this message translates to:
  /// **'Here are some suggested questions to help you get started...\nPick what suits you and we\'ll go from there.'**
  String get suggestedQuestionsHint;

  /// No description provided for @suggestedQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I assess my child\'s condition?'**
  String get suggestedQ1;

  /// No description provided for @suggestedQ2.
  ///
  /// In en, this message translates to:
  /// **'What are the steps to start at home?'**
  String get suggestedQ2;

  /// No description provided for @suggestedQ3.
  ///
  /// In en, this message translates to:
  /// **'General health tips'**
  String get suggestedQ3;

  /// No description provided for @suggestedQ4.
  ///
  /// In en, this message translates to:
  /// **'Does this problem affect my child\'s development?'**
  String get suggestedQ4;

  /// No description provided for @suggestedQ5.
  ///
  /// In en, this message translates to:
  /// **'Prevention and safe treatment methods'**
  String get suggestedQ5;

  /// No description provided for @askAboutChild.
  ///
  /// In en, this message translates to:
  /// **'Ask me about your child\'s condition here...'**
  String get askAboutChild;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Dr. Islam Ghoneim'**
  String get doctorName;

  /// No description provided for @doctorLocation.
  ///
  /// In en, this message translates to:
  /// **'Cairo - Heliopolis'**
  String get doctorLocation;

  /// No description provided for @sampleMessage1.
  ///
  /// In en, this message translates to:
  /// **'Doctor, I came to check on my son.'**
  String get sampleMessage1;

  /// No description provided for @sampleMessage2.
  ///
  /// In en, this message translates to:
  /// **'Thank you for sharing. Are these movements involuntary?'**
  String get sampleMessage2;

  /// No description provided for @sampleMessage3.
  ///
  /// In en, this message translates to:
  /// **'Yes doctor, they happen without him meaning to.'**
  String get sampleMessage3;

  /// No description provided for @sampleMessage4.
  ///
  /// In en, this message translates to:
  /// **'It seems like simple involuntary movements.'**
  String get sampleMessage4;

  /// No description provided for @sampleMessage5.
  ///
  /// In en, this message translates to:
  /// **'Okay doctor... does this need immediate treatment?'**
  String get sampleMessage5;

  /// No description provided for @sampleMessage6.
  ///
  /// In en, this message translates to:
  /// **'We usually start with a simple assessment.'**
  String get sampleMessage6;

  /// No description provided for @sampleMessage7.
  ///
  /// In en, this message translates to:
  /// **'Sure doctor. We will monitor and record all observations.'**
  String get sampleMessage7;

  /// No description provided for @sampleMessage8.
  ///
  /// In en, this message translates to:
  /// **'It is best to schedule a visit soon.'**
  String get sampleMessage8;

  /// No description provided for @warningDescription.
  ///
  /// In en, this message translates to:
  /// **'This assessment is a guidance tool to help you and does not replace specialized medical consultation.'**
  String get warningDescription;

  /// No description provided for @resultSpecialistTitle.
  ///
  /// In en, this message translates to:
  /// **'Consult a Specialist for Support.'**
  String get resultSpecialistTitle;

  /// No description provided for @resultSpecialistDescription.
  ///
  /// In en, this message translates to:
  /// **'The assessment shows that your child faces sensory challenges affecting their daily life. This is not a failure in your parenting, but a difference in their nervous system. Early intervention is important, so we recommend booking a consultation with a sensory integration specialist.'**
  String get resultSpecialistDescription;

  /// No description provided for @bookSpecialistConsultation.
  ///
  /// In en, this message translates to:
  /// **'Book a Specialist Consultation Now'**
  String get bookSpecialistConsultation;

  /// No description provided for @resultNormalTitle.
  ///
  /// In en, this message translates to:
  /// **'Reassuring Result: Your Child is Developing Normally'**
  String get resultNormalTitle;

  /// No description provided for @resultNormalDescription.
  ///
  /// In en, this message translates to:
  /// **'Based on your answers, your child\'s responses to sensory stimuli are normal and appropriate for their age. Any discomfort or tantrums they experience now are a very natural part of their emotional growth. Keep providing a safe and supportive environment.'**
  String get resultNormalDescription;

  /// No description provided for @browseActivities.
  ///
  /// In en, this message translates to:
  /// **'Browse Activities to Develop Their Skills'**
  String get browseActivities;

  /// No description provided for @readBook.
  ///
  /// In en, this message translates to:
  /// **'Read Book'**
  String get readBook;

  /// No description provided for @resultSensitivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention: Your Child Has Some Sensitivity'**
  String get resultSensitivityTitle;

  /// No description provided for @resultSensitivityDescription.
  ///
  /// In en, this message translates to:
  /// **'Your answers show that your child is more affected by certain sensory stimuli (such as sounds or touch) than usual, which may be causing some of their reactions. They need you to observe what bothers them and avoid it, while trying some calming sensory activities at home to help them adapt.'**
  String get resultSensitivityDescription;

  /// No description provided for @sensoryActivitiesPlan.
  ///
  /// In en, this message translates to:
  /// **'Sensory Activities Plan for Home'**
  String get sensoryActivitiesPlan;

  /// No description provided for @sensorySubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t submit your answers right now. Please try again later.'**
  String get sensorySubmitFailed;

  /// No description provided for @skillsNotAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills are not available yet'**
  String get skillsNotAvailableTitle;

  /// No description provided for @skillsNotAvailableDesc.
  ///
  /// In en, this message translates to:
  /// **'We’ll show your child’s skills and progress as soon as they are available on the server.'**
  String get skillsNotAvailableDesc;

  /// No description provided for @sectionHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Initial Assessment of Sensory Challenges'**
  String get sectionHeaderTitle;

  /// No description provided for @sectionHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick questions to help us understand how your child responds to surrounding stimuli.'**
  String get sectionHeaderSubtitle;

  /// No description provided for @examinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Examine Your Child'**
  String get examinationTitle;

  /// No description provided for @touchAndSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Response to Touch and Sound'**
  String get touchAndSoundTitle;

  /// No description provided for @touchAndSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'(Sensitivity)'**
  String get touchAndSoundSubtitle;

  /// No description provided for @motorInteractionTitle.
  ///
  /// In en, this message translates to:
  /// **'Motor and Environmental Interaction'**
  String get motorInteractionTitle;

  /// No description provided for @motorInteractionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'(Seeking or Avoiding Sensation)'**
  String get motorInteractionSubtitle;

  /// No description provided for @behaviorAndTantrumsTitle.
  ///
  /// In en, this message translates to:
  /// **'Behavior and Tantrums'**
  String get behaviorAndTantrumsTitle;

  /// No description provided for @behaviorAndTantrumsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'(Sensory Breakdown)'**
  String get behaviorAndTantrumsSubtitle;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'Does your child get severely bothered by normal sounds like a vacuum cleaner, blender, or a sudden loud noise, covering their ears?'**
  String get question1;

  /// No description provided for @question2.
  ///
  /// In en, this message translates to:
  /// **'Does your child strongly refuse to wear certain clothes due to their texture, or cry excessively about clothing tags or sock seams?'**
  String get question2;

  /// No description provided for @question3.
  ///
  /// In en, this message translates to:
  /// **'Does your child overreact when suddenly touched, or strongly avoid hugging and cuddling even from close relatives?'**
  String get question3;

  /// No description provided for @question4.
  ///
  /// In en, this message translates to:
  /// **'Does your child move constantly and excessively (as if motor-driven) and have great difficulty sitting still for a period appropriate for their age?'**
  String get question4;

  /// No description provided for @question5.
  ///
  /// In en, this message translates to:
  /// **'When your child gets angry, does the tantrum last for a long time (more than 15 minutes) and is it very difficult to calm them down or distract them?'**
  String get question5;

  /// No description provided for @question6.
  ///
  /// In en, this message translates to:
  /// **'Do you notice that tantrums or meltdowns often happen after being in a crowded or noisy place (like supermarkets, parties, or family gatherings)?'**
  String get question6;

  /// No description provided for @showResult.
  ///
  /// In en, this message translates to:
  /// **'Show Result'**
  String get showResult;

  /// No description provided for @publishedYear.
  ///
  /// In en, this message translates to:
  /// **'Published in'**
  String get publishedYear;

  /// No description provided for @featuredBooks.
  ///
  /// In en, this message translates to:
  /// **'Our Picks for Your Journey'**
  String get featuredBooks;

  /// No description provided for @childDoctorOptions.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Child\'s Doctor'**
  String get childDoctorOptions;

  /// No description provided for @smartAssistant.
  ///
  /// In en, this message translates to:
  /// **'Smart Assistant'**
  String get smartAssistant;

  /// No description provided for @smartSymptomCheck.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step Symptom Check'**
  String get smartSymptomCheck;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'All Your Kids\' Health in One Place!'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Forget the paperwork. Keep track of all your child\'s health details safely from the first vaccinations to growth tracking and development updates, all from your phone.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Doctor Consultation Made Easier & Faster!'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Select a specialist for your child anytime. Book appointments online or at the clinic and consult the doctor securely from your home.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Assistant, Step by Step'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Have a smart assistant that helps you track your child\'s symptoms, gives guidance, and provides tips in real-time.'**
  String get onboarding3Desc;

  /// No description provided for @personalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get to Know You'**
  String get personalInfoTitle;

  /// No description provided for @personalInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in your basic information so we can personalize your experience and help you easily track your child\'s health.'**
  String get personalInfoDesc;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @governorateLabel.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorateLabel;

  /// No description provided for @governorateHint.
  ///
  /// In en, this message translates to:
  /// **'Select your governorate'**
  String get governorateHint;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full address'**
  String get addressHint;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountLabel;

  /// No description provided for @accountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get accountHint;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @registerWith.
  ///
  /// In en, this message translates to:
  /// **'Register the Way You Prefer'**
  String get registerWith;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @addChildDesc.
  ///
  /// In en, this message translates to:
  /// **'Start now and keep everything about your child always close to you.'**
  String get addChildDesc;

  /// No description provided for @childNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child name'**
  String get childNameLabel;

  /// No description provided for @childNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your child\'s name'**
  String get childNameHint;

  /// No description provided for @birthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birthDateLabel;

  /// No description provided for @birthDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select the date of birth'**
  String get birthDateHint;

  /// No description provided for @childGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Child Gender'**
  String get childGenderLabel;

  /// No description provided for @childGenderBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get childGenderBoy;

  /// No description provided for @childGenderGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get childGenderGirl;

  /// No description provided for @bloodTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodTypeLabel;

  /// No description provided for @bloodTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select the blood type'**
  String get bloodTypeHint;

  /// No description provided for @addAnotherChild.
  ///
  /// In en, this message translates to:
  /// **'Want to add another child?'**
  String get addAnotherChild;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @childGender.
  ///
  /// In en, this message translates to:
  /// **'Child Gender'**
  String get childGender;

  /// No description provided for @boy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get boy;

  /// No description provided for @girl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get girl;

  /// No description provided for @howCanWeReachYou.
  ///
  /// In en, this message translates to:
  /// **'How can we reach you?'**
  String get howCanWeReachYou;

  /// No description provided for @howCanWeReachYouHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and email so we can send you updates and important notifications as soon as possible.'**
  String get howCanWeReachYouHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @countrySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for country'**
  String get countrySearchHint;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @getVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Get Verification Code'**
  String get getVerificationCode;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you'**
  String get verificationTitle;

  /// No description provided for @verificationDescLine1.
  ///
  /// In en, this message translates to:
  /// **'We sent you a 6-digit code to your number +{phoneNumber}'**
  String verificationDescLine1(String phoneNumber);

  /// No description provided for @verificationDescLine2.
  ///
  /// In en, this message translates to:
  /// **'Enter the code here to confirm your number is correct.'**
  String get verificationDescLine2;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'00:20'**
  String get timer;

  /// No description provided for @choosePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a password to protect your account'**
  String get choosePasswordTitle;

  /// No description provided for @choosePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Make it easy for you and hard for others, so you can log in safely anytime.'**
  String get choosePasswordDesc;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a strong password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsMismatch;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBackTitle;

  /// No description provided for @loginDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to continue managing your baby\'s health easily and securely.'**
  String get loginDesc;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginWith.
  ///
  /// In en, this message translates to:
  /// **'Login with email'**
  String get loginWith;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number so we can verify that the account is yours, then you can choose a new password.'**
  String get forgotPasswordDesc;

  /// No description provided for @newPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Make it easy for you and hard for others, but strong enough to keep your account safe.'**
  String get newPasswordDesc;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a strong password'**
  String get newPasswordHint;

  /// No description provided for @confirmPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordButton;

  /// No description provided for @choosDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get choosDate;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get yearsExperience;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @reviewBookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check the details before completing the booking.'**
  String get reviewBookingSubtitle;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @bookingConfirmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will contact you soon to confirm the appointment.'**
  String get bookingConfirmedSubtitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @bookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking Number'**
  String get bookingNumber;

  /// No description provided for @serviceCost.
  ///
  /// In en, this message translates to:
  /// **'Service Cost'**
  String get serviceCost;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @electronicPayment.
  ///
  /// In en, this message translates to:
  /// **'Electronic Payment'**
  String get electronicPayment;

  /// No description provided for @paymentAtVisit.
  ///
  /// In en, this message translates to:
  /// **'Pay at Visit'**
  String get paymentAtVisit;

  /// No description provided for @bookVisit.
  ///
  /// In en, this message translates to:
  /// **'Book your visit'**
  String get bookVisit;

  /// No description provided for @lastStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Step... To Make Sure Your Child is Safe'**
  String get lastStepTitle;

  /// No description provided for @lastStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the patient and payment method... and confirm the booking.'**
  String get lastStepSubtitle;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @selectYorChildName.
  ///
  /// In en, this message translates to:
  /// **'Select your child name'**
  String get selectYorChildName;

  /// No description provided for @visitType.
  ///
  /// In en, this message translates to:
  /// **'Visit type'**
  String get visitType;

  /// No description provided for @doctorNote.
  ///
  /// In en, this message translates to:
  /// **'Note to doctor'**
  String get doctorNote;

  /// No description provided for @writeNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write any simple comment… (optional)'**
  String get writeNoteHint;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @payOnVisit.
  ///
  /// In en, this message translates to:
  /// **'Pay on visit'**
  String get payOnVisit;

  /// No description provided for @bookingSuccessMessageOnVisit.
  ///
  /// In en, this message translates to:
  /// **'Your booking was successful. Payment will be made at the clinic during your visit.'**
  String get bookingSuccessMessageOnVisit;

  /// No description provided for @payWithCard.
  ///
  /// In en, this message translates to:
  /// **'Pay with card'**
  String get payWithCard;

  /// No description provided for @priceValue.
  ///
  /// In en, this message translates to:
  /// **'250'**
  String get priceValue;

  /// No description provided for @currencyPound.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyPound;

  /// No description provided for @thousand.
  ///
  /// In en, this message translates to:
  /// **'K'**
  String get thousand;

  /// No description provided for @seven.
  ///
  /// In en, this message translates to:
  /// **'7'**
  String get seven;

  /// No description provided for @fourPointFive.
  ///
  /// In en, this message translates to:
  /// **'4.5'**
  String get fourPointFive;

  /// No description provided for @threePointFive.
  ///
  /// In en, this message translates to:
  /// **'3.5'**
  String get threePointFive;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @examination.
  ///
  /// In en, this message translates to:
  /// **'Examination'**
  String get examination;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results ....'**
  String get searchResults;

  /// No description provided for @heroGrowthJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Little Hero\'s Growth Journey'**
  String get heroGrowthJourney;

  /// No description provided for @searchVideos.
  ///
  /// In en, this message translates to:
  /// **'Search for the video you need...'**
  String get searchVideos;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results match your search'**
  String get noResults;

  /// No description provided for @understandSPD.
  ///
  /// In en, this message translates to:
  /// **'Understand His Sensory World (SPD)'**
  String get understandSPD;

  /// No description provided for @sensoryActivities.
  ///
  /// In en, this message translates to:
  /// **'Fun Sensory Activities at Home'**
  String get sensoryActivities;

  /// No description provided for @angerManagement.
  ///
  /// In en, this message translates to:
  /// **'Managing Sensory Anger Episodes'**
  String get angerManagement;

  /// No description provided for @sensoryDisorder.
  ///
  /// In en, this message translates to:
  /// **'What is Sensory Processing Disorder?'**
  String get sensoryDisorder;

  /// No description provided for @babyGrowth.
  ///
  /// In en, this message translates to:
  /// **'Your Baby\'s Growth Journey'**
  String get babyGrowth;

  /// No description provided for @motorDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Motor Development: From Crawling to Walking'**
  String get motorDevelopment;

  /// No description provided for @firstWords.
  ///
  /// In en, this message translates to:
  /// **'First Words: How to Encourage Speech?'**
  String get firstWords;

  /// No description provided for @healthCapsules.
  ///
  /// In en, this message translates to:
  /// **'Better Awareness Capsules'**
  String get healthCapsules;

  /// No description provided for @sleepCapsule.
  ///
  /// In en, this message translates to:
  /// **'Healthy Sleep Capsule'**
  String get sleepCapsule;

  /// No description provided for @nutritionCapsule.
  ///
  /// In en, this message translates to:
  /// **'Healthy Nutrition Capsule'**
  String get nutritionCapsule;

  /// No description provided for @noResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Please check the spelling, or try searching in the main library sections.'**
  String get noResultsDesc;

  /// No description provided for @bookSensoryIntegrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sensory Integration and the Child'**
  String get bookSensoryIntegrationTitle;

  /// No description provided for @bookSensoryIntegrationAuthor.
  ///
  /// In en, this message translates to:
  /// **'Lindsay Biel & Nancy Peske'**
  String get bookSensoryIntegrationAuthor;

  /// No description provided for @bookSensoryIntegrationDesc.
  ///
  /// In en, this message translates to:
  /// **'A specialized book on understanding children\'s sensory systems and how to handle daily challenges in a scientific and simplified way.'**
  String get bookSensoryIntegrationDesc;

  /// No description provided for @bookSensoryChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'What is Sensory Integration?'**
  String get bookSensoryChapter1Title;

  /// No description provided for @bookSensoryChapter1Body.
  ///
  /// In en, this message translates to:
  /// **'Sensory integration is the process by which the brain organizes information from different senses. When this system works properly, the child can respond to the environment appropriately.'**
  String get bookSensoryChapter1Body;

  /// No description provided for @bookSensoryChapter2Title.
  ///
  /// In en, this message translates to:
  /// **'Signs of Sensory Integration Difficulties'**
  String get bookSensoryChapter2Title;

  /// No description provided for @bookSensoryChapter2Body.
  ///
  /// In en, this message translates to:
  /// **'There are many signs that may indicate sensory integration difficulties, including: refusing to wear certain clothes due to texture, extreme sensitivity to loud sounds.'**
  String get bookSensoryChapter2Body;

  /// No description provided for @bookAsyncChildTitle.
  ///
  /// In en, this message translates to:
  /// **'The Out-of-Sync Child'**
  String get bookAsyncChildTitle;

  /// No description provided for @bookAsyncChildAuthor.
  ///
  /// In en, this message translates to:
  /// **'Carol Stock Kranowitz'**
  String get bookAsyncChildAuthor;

  /// No description provided for @bookAsyncChildDesc.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive guide for dealing with children who develop at a different pace than their peers and need special understanding and support.'**
  String get bookAsyncChildDesc;

  /// No description provided for @bookAsyncChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'Who is the Out-of-Sync Child?'**
  String get bookAsyncChapter1Title;

  /// No description provided for @bookAsyncChapter1Body.
  ///
  /// In en, this message translates to:
  /// **'The out-of-sync child is one whose developmental levels vary significantly, being very advanced in one area like intelligence or language, while being at an earlier stage emotionally or socially.'**
  String get bookAsyncChapter1Body;

  /// No description provided for @bookAsyncChapter2Title.
  ///
  /// In en, this message translates to:
  /// **'How to Support Your Out-of-Sync Child?'**
  String get bookAsyncChapter2Title;

  /// No description provided for @bookAsyncChapter2Body.
  ///
  /// In en, this message translates to:
  /// **'Real support starts with acceptance and understanding. You must accept that your child moves at their own pace, and that this is not a flaw but a characteristic that needs different care.'**
  String get bookAsyncChapter2Body;

  /// No description provided for @bookSensorySignalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept Your Child\'s Sensory Signals'**
  String get bookSensorySignalsTitle;

  /// No description provided for @bookSensorySignalsAuthor.
  ///
  /// In en, this message translates to:
  /// **'Dr. Karen Sourkav'**
  String get bookSensorySignalsAuthor;

  /// No description provided for @bookSensorySignalsDesc.
  ///
  /// In en, this message translates to:
  /// **'A practical book that helps you understand and read your child\'s sensory signals and deal with them correctly and effectively.'**
  String get bookSensorySignalsDesc;

  /// No description provided for @bookSensorySignalsChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'What are Sensory Signals?'**
  String get bookSensorySignalsChapter1Title;

  /// No description provided for @bookSensorySignalsChapter1Body.
  ///
  /// In en, this message translates to:
  /// **'Sensory signals are the way your child\'s body expresses its sensory needs.'**
  String get bookSensorySignalsChapter1Body;

  /// No description provided for @bookSensorySignalsChapter2Title.
  ///
  /// In en, this message translates to:
  /// **'How to Respond to Your Child\'s Signals?'**
  String get bookSensorySignalsChapter2Title;

  /// No description provided for @bookSensorySignalsChapter2Body.
  ///
  /// In en, this message translates to:
  /// **'The correct response to sensory signals depends on the type of signal and its context.'**
  String get bookSensorySignalsChapter2Body;

  /// No description provided for @bookGuide1Author.
  ///
  /// In en, this message translates to:
  /// **'Anji Qaws'**
  String get bookGuide1Author;

  /// No description provided for @bookGuide1Desc.
  ///
  /// In en, this message translates to:
  /// **'A quick reference book explaining how to understand your child\'s behaviors and how to intervene calmly to contain tantrums.'**
  String get bookGuide1Desc;

  /// No description provided for @bookGuide1Chapter1Title.
  ///
  /// In en, this message translates to:
  /// **'To Every Parent Who Feels Their Child is Hard to Handle'**
  String get bookGuide1Chapter1Title;

  /// No description provided for @bookGuide1Chapter1Body.
  ///
  /// In en, this message translates to:
  /// **'We focus on the dynamic movement that begins from the moment your child wakes up.'**
  String get bookGuide1Chapter1Body;

  /// No description provided for @bookGuide1Chapter2Title.
  ///
  /// In en, this message translates to:
  /// **'Imagine if Every Touch was Sandpaper'**
  String get bookGuide1Chapter2Title;

  /// No description provided for @bookGuide1Chapter2Body.
  ///
  /// In en, this message translates to:
  /// **'Imagine walking inside a city filled with millions of sounds.'**
  String get bookGuide1Chapter2Body;

  /// No description provided for @bookBodyLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Guide to Understanding Your Child\'s Body Language'**
  String get bookBodyLanguageTitle;

  /// No description provided for @bookBodyLanguageAuthor.
  ///
  /// In en, this message translates to:
  /// **'Mariam Al-Abdullah'**
  String get bookBodyLanguageAuthor;

  /// No description provided for @bookBodyLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Introduces you to physical signals that help improve communication with your child and better understand their needs.'**
  String get bookBodyLanguageDesc;

  /// No description provided for @bookBodyLanguageChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'Introduction - Body Language in Children'**
  String get bookBodyLanguageChapter1Title;

  /// No description provided for @bookBodyLanguageChapter1Body.
  ///
  /// In en, this message translates to:
  /// **'Children communicate in many ways before they master speech.'**
  String get bookBodyLanguageChapter1Body;

  /// No description provided for @bookAngerTitle.
  ///
  /// In en, this message translates to:
  /// **'Strategies for Dealing with Tantrums'**
  String get bookAngerTitle;

  /// No description provided for @bookAngerAuthor.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Qasim'**
  String get bookAngerAuthor;

  /// No description provided for @bookAngerDesc.
  ///
  /// In en, this message translates to:
  /// **'A collection of effective tips for understanding how to deal with tantrums in a positive and effective way.'**
  String get bookAngerDesc;

  /// No description provided for @bookAngerChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'Why Does Your Child Get Angry?'**
  String get bookAngerChapter1Title;

  /// No description provided for @bookAngerChapter1Body.
  ///
  /// In en, this message translates to:
  /// **'Tantrums in children are usually not rebellion or stubbornness, but a clear message: I cannot handle what is happening now.'**
  String get bookAngerChapter1Body;

  /// No description provided for @bookEmotionsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Identify Your Child\'s Emotions'**
  String get bookEmotionsTitle;

  /// No description provided for @bookEmotionsAuthor.
  ///
  /// In en, this message translates to:
  /// **'Rana Samir'**
  String get bookEmotionsAuthor;

  /// No description provided for @bookEmotionsDesc.
  ///
  /// In en, this message translates to:
  /// **'A guide that helps you identify your child\'s emotions and guide them to express themselves in a healthy way.'**
  String get bookEmotionsDesc;

  /// No description provided for @bookEmotionsChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'Emotional Intelligence Starts at Home'**
  String get bookEmotionsChapter1Title;

  /// No description provided for @bookEmotionsChapter1Body.
  ///
  /// In en, this message translates to:
  /// **'Children are not born knowing the names of their feelings, nor do they know how to deal with them. This is a skill that is taught and acquired.'**
  String get bookEmotionsChapter1Body;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
