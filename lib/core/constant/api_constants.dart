class ApiConstants {
  ApiConstants._();

  // NOTE:
  // Do NOT store a base URL in this file.
  // Base URL is configured via `AppConfig.apiBaseUrl` (`--dart-define=API_BASE_URL=...`)
  // to avoid accidentally shipping ngrok/local URLs.

  // ── Parent / Auth ────────────────────────────────────────────────────────────
  static const String preSignUp = '/v1/parent/pre-SignUp';
  static const String verifySignUp = '/v1/parent/verify-signUp';
  static const String preSignIn = '/v1/parent/pre-signIn';
  static const String verifySignIn = '/v1/parent/verify-signIn';
  static const String resetPassword = '/v1/parent/reset-password';
  static const String verifyPasswordOtp = '/v1/parent/verify-password-otp';
  static const String changePassword = '/v1/parent/change-password';

  // ── Parent / Google OAuth ────────────────────────────────────────────────────
  static const String googleSignIn = '/v1/parent/google'; // GET
  static const String googleComplete = '/v1/parent/google/compelete'; // POST

  // ── Parent Profile ───────────────────────────────────────────────────────────
  static const String parentMe = '/v1/parentMe'; // GET / PATCH / DELETE

  // ── Doctor ───────────────────────────────────────────────────────────────────
  static const String createDoctor = '/v1/doctor'; // POST
  static const String getAllDoctors = '/v1/doctor'; // GET
  static const String doctorById = '/v1/doctor/'; // GET/PATCH/DELETE + id

  // ── Booking ──────────────────────────────────────────────────────────────────
  static const String createBooking = '/v1/booking'; // POST
  static const String getAllBookings = '/v1/booking'; // GET
  static const String bookingById = '/v1/booking/'; // GET/DELETE + id

  // ── Paymob ───────────────────────────────────────────────────────────────────
  static const String paymobCallback = '/v1/paymob/callback'; // GET (internal)
}
