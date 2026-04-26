class ApiEndpoint {
  /// Routes that must not send `Authorization` (signup/login/reset), even if a
  /// stale token exists in storage — some backends error or 500 when they see
  /// a JWT on these endpoints.
  static bool isPublicParentAuthPath(String path) {
    final p = path.toLowerCase();
    const suffixes = <String>[
      '/v1/parent/pre-signup',
      '/v1/parent/verify-signup',
      '/v1/parent/pre-signin',
      '/v1/parent/verify-signin',
      '/v1/parent/reset-password',
      '/v1/parent/verify-password-otp',
    ];
    for (final s in suffixes) {
      if (p.contains(s)) return true;
    }
    return false;
  }

  // ── Parent / Auth ────────────────────────────────────────────────────────────
  static const String preSignUp = '/v1/parent/pre-SignUp';
  static const String verifySignUp = '/v1/parent/verify-signUp';
  static const String addPassword = '/v1/parent/add-password';
  static const String preSignIn = '/v1/parent/pre-signIn';
  static const String verifySignIn = '/v1/parent/verify-signIn';
  static const String resetPassword = '/v1/parent/reset-password';
  static const String verifyPasswordOtp = '/v1/parent/verify-password-otp';
  static const String changePassword = '/v1/parent/change-password';

  // ── Parent / Google OAuth ────────────────────────────────────────────────────
  static const String googleSignIn = '/v1/parent/google'; // GET
  static const String googleCallback =
      '/v1/parent/google/callback'; // GET (handled by server)
  static const String googleComplete =
      '/v1/parent/google/compelete'; // GET + body

  // ── Parent Profile ───────────────────────────────────────────────────────────
  static const String parentMe = '/v1/parentMe'; // GET / PATCH / DELETE
  static const String parentAddChild = '/v1/parentMe/addChild'; // POST
  static const String parentUpdateChild =
      '/v1/parentMe/updateChild/'; // PATCH + childId (JSON)

  // ── Profile images (note 2) ──────────────────────────────────────────────────
  /// Multipart image upload endpoints (as used in Postman):
  /// - PATCH /v1/parent/:id/add-profile-image
  /// - PATCH /v1/child/:id/add-profile-image
  static String parentAddProfileImagePath(String parentId) =>
      '/v1/parent/$parentId/add-profile-image';

  static String childAddProfileImagePath(String childId) =>
      '/v1/child/$childId/add-profile-image';

  // ── Doctor ───────────────────────────────────────────────────────────────────
  static const String createDoctor = '/v1/doctor'; // POST
  static const String getAllDoctors = '/v1/doctor'; // GET
  static const String doctorById = '/v1/doctor/'; // GET / PATCH / DELETE + id

  /// GET /v1/doctor/:id/available-slots?date=YYYY-MM-DD
  static String doctorAvailableSlotsPath(String doctorId, {required String date}) =>
      '/v1/doctor/$doctorId/available-slots?date=$date';

  static String doctorPatientsGeneratePath(String doctorId) =>
      '/v1/doctor/$doctorId/patients/generate'; // POST

  // ── Videos ───────────────────────────────────────────────────────────────────
  static const String videos = '/v1/videos'; // GET all
  static const String videoById = '/v1/videos/'; // GET by id
  static const String videosSearch = '/v1/videos/search'; // GET ?q=

  // ── Booking ──────────────────────────────────────────────────────────────────
  static const String createBooking = '/v1/booking'; // POST
  static const String getAllBookings = '/v1/booking'; // GET
  static const String bookingById = '/v1/booking/'; // GET / DELETE + id
  static const String myAppointmentsByParent =
      '/v1/booking/myAppointment/'; // GET + parentId
  static const String doctorAppointmentsByDoctor =
      '/v1/booking/doctorAppointment/'; // GET + doctorId
  static const String todayDoctorAppointmentsByDoctor =
      '/v1/booking/todayDoctorAppointment/'; // GET + doctorId
  static const String bookingRate = '/v1/booking/'; // POST + bookingId + /rate

  static String bookingDetail(String bookingId) => '$bookingById$bookingId';

  static String bookingRatePath(String bookingId) =>
      '$bookingById$bookingId/rate';

  static String bookingCancelChildPath(String childId) =>
      '/v1/booking/cancel/child/$childId';

  static String doctorAppointmentsPath(String doctorId) =>
      '$doctorAppointmentsByDoctor$doctorId';

  static String todayDoctorAppointmentsPath(String doctorId) =>
      '$todayDoctorAppointmentsByDoctor$doctorId';

  // ── Paymob ───────────────────────────────────────────────────────────────────
  static const String paymobCallback = '/v1/paymob/callback'; // GET (internal)

  // ── Books ────────────────────────────────────────────────────────────────────
  static const String textBooks = '/v1/textBooks'; // GET all
  static const String bookById = '/v1/textBooks/'; // GET by id
  static const String textBooksSearch = '/v1/textBooks/search'; // GET ?q=

  // ── Skills ───────────────────────────────────────────────────────────────────
  static const String skills = '/v1/skills';

  static String skillsChecklist(String skillId, String childId) =>
      '/v1/skills/$skillId/child/$childId/checklist';

  static String skillsToggleChild(String childId) =>
      '/v1/skills/toggle/child/$childId';

  // ── Sensory test ────────────────────────────────────────────────────────────
  static const String sensoryTestList = '/v1/sensory-test/';

  static String sensoryTestSubmit(String childId) => '/v1/sensory-test/$childId';

  // ── Child Vaccinations ───────────────────────────────────────────────────────
  static const String childVaccinationTake =
      '/v1/child/'; // PATCH childId/childVaccinations/vaccinationId/take
  static const String childVaccinations =
      '/v1/child/'; // GET childId/childVaccinations
  static const String childVaccinationsGenerate =
      '/v1/child/'; // POST childId/childVaccinations/generate
  static const String vaccinations = '/v1/vaccinations'; // GET all vaccines

  static String childVaccinationTakePath(String childId, String vaccinationId) =>
      '$childVaccinationTake$childId/childVaccinations/$vaccinationId/take';

  // ── Child growth (same /v1/child/:id prefix as [childVaccinations]) ───────────
  static String childGrowthRecords(String childId) =>
      '$childVaccinations$childId/growth';

  static String childGrowthLatest(String childId) =>
      '$childVaccinations$childId/growth/latest';
}
