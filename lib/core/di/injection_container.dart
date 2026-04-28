// // lib/core/di/injection_container.dart
// // ignore_for_file: cascade_invocations

// import 'package:dana/features/booking/data/repo/booking_repo.dart';
// import 'package:dana/features/booking/data/services/booking_service.dart';
// import 'package:dana/features/booking/presentation/cubit/booking_cubit.dart';
// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// import '../../features/auth/login/data/datasources/auth_remote_data_source.dart';
// import '../../features/auth/login/data/repo/auth_repository_impl.dart';
// import '../../features/auth/login/domain/repo/auth_repository.dart';
// import '../../features/auth/login/domain/usecases/change_password_usecase.dart';
// import '../../features/auth/login/domain/usecases/create_doctor_usecase.dart';
// import '../../features/auth/login/domain/usecases/pre_sign_in_usecase.dart';
// import '../../features/auth/login/domain/usecases/pre_sign_up_usecase.dart';
// import '../../features/auth/login/domain/usecases/reset_password_usecase.dart';
// import '../../features/auth/login/domain/usecases/verify_password_otp_usecase.dart';
// import '../../features/auth/login/domain/usecases/verify_sign_in_usecase.dart';
// import '../../features/auth/login/domain/usecases/verify_sign_up_usecase.dart';
// import '../../features/auth/login/presentation/cubit/change_password_cubit.dart';
// import '../../features/auth/login/presentation/cubit/create_doctor_cubit.dart';
// import '../../features/auth/login/presentation/cubit/reset_password_cubit.dart';
// import '../../features/auth/login/presentation/cubit/sign_in_cubit.dart';
// import '../../features/auth/login/presentation/cubit/sign_up_cubit.dart';
// import '../constant/api_constants.dart';
// import '../network/network_info.dart';
// import '../network/network_info_impl.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // ══════════════════════════════════════════════════════════════════════════
//   //  Cubits
//   // ══════════════════════════════════════════════════════════════════════════

//   sl.registerFactory(
//     () => SignUpCubit(preSignUpUseCase: sl(), verifySignUpUseCase: sl()),
//   );

//   sl.registerFactory(
//     () => SignInCubit(preSignInUseCase: sl(), verifySignInUseCase: sl()),
//   );

//   sl.registerFactory(
//     () => ResetPasswordCubit(
//       resetPasswordUseCase: sl(),
//       verifyPasswordOtpUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(() => ChangePasswordCubit(changePasswordUseCase: sl()));

//   sl.registerFactory(() => CreateDoctorCubit(createDoctorUseCase: sl()));

//   sl.registerFactory<BookingCubit>(() => BookingCubit(sl<BookingRepo>()));

//   // ══════════════════════════════════════════════════════════════════════════
//   //  Use Cases
//   // ══════════════════════════════════════════════════════════════════════════

//   sl.registerLazySingleton(() => PreSignUpUseCase(repository: sl()));
//   sl.registerLazySingleton(() => VerifySignUpUseCase(repository: sl()));
//   sl.registerLazySingleton(() => PreSignInUseCase(repository: sl()));
//   sl.registerLazySingleton(() => VerifySignInUseCase(repository: sl()));
//   sl.registerLazySingleton(() => ResetPasswordUseCase(repository: sl()));
//   sl.registerLazySingleton(() => VerifyPasswordOtpUseCase(repository: sl()));
//   sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
//   sl.registerLazySingleton(() => CreateDoctorUseCase(repository: sl()));

//   // ══════════════════════════════════════════════════════════════════════════
//   //  Repository
//   // ══════════════════════════════════════════════════════════════════════════

//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
//   );

//   // ══════════════════════════════════════════════════════════════════════════
//   //  Data Sources
//   // ══════════════════════════════════════════════════════════════════════════

//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(dio: sl()),
//   );

//   // ══════════════════════════════════════════════════════════════════════════
//   //  Core
//   // ══════════════════════════════════════════════════════════════════════════

//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//   sl.registerLazySingleton(() => InternetConnection());

//   sl.registerLazySingleton<Dio>(
//     () => Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout: const Duration(seconds: 15),
//         receiveTimeout: const Duration(seconds: 15),
//         headers: {'Accept': 'application/json'},
//       ),
//     ),
//   );

//   sl.registerLazySingleton<BookingService>(() => BookingService(sl<Dio>()));

//   sl.registerLazySingleton<BookingRepo>(
//     () => BookingRepo(sl<BookingService>()),
//   );
// }

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../config/app_config.dart';
import '../auth/auth_session.dart';
import '../auth/dio_auth_interceptor.dart';
import '../auth/dio_error_interceptor.dart';
import '../auth/dio_unauthorized_interceptor.dart';
import '../auth/token_storage.dart';
import '../log/debug_audit_log.dart';
import '../../features/auth/login/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/login/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/login/data/repo/auth_repository_impl.dart';
import '../../features/auth/login/domain/repo/auth_repository.dart';
import '../../features/auth/login/domain/usecases/change_password_usecase.dart';
import '../../features/auth/login/domain/usecases/create_doctor_usecase.dart';
import '../../features/auth/login/domain/usecases/add_sign_up_password_usecase.dart';
import '../../features/auth/login/domain/usecases/pre_sign_in_usecase.dart';
import '../../features/auth/login/domain/usecases/pre_sign_up_usecase.dart';
import '../../features/auth/login/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/login/domain/usecases/verify_password_otp_usecase.dart';
import '../../features/auth/login/domain/usecases/verify_sign_in_usecase.dart';
import '../../features/auth/login/domain/usecases/verify_sign_up_usecase.dart';
import '../../features/auth/login/presentation/cubit/change_password_cubit.dart';
import '../../features/auth/login/presentation/cubit/create_doctor_cubit.dart';
import '../../features/auth/login/presentation/cubit/google_auth_cubit.dart';
import '../../features/auth/login/presentation/cubit/reset_password_cubit.dart';
import '../../features/auth/login/presentation/cubit/sign_in_cubit.dart';
import '../../features/auth/login/presentation/cubit/sign_up_cubit.dart';
import '../../features/booking/data/repo/booking_repo.dart';
import '../../features/booking/data/services/booking_service.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';
import '../../features/parent_profile/data/datasources/parent_profile_remote_data_source.dart';
import '../../features/parent_profile/data/datasources/parent_profile_remote_data_source_impl.dart';
import '../../features/parent_profile/data/repo/parent_profile_repository.dart';
import '../../features/parent_profile/presentation/cubit/parent_profile_cubit.dart';
import '../../features/vaccinations/data/repo/child_vaccination_repo.dart';
import '../../features/vaccinations/data/repo/child_vaccination_schedule_repo.dart';
import '../../features/vaccinations/data/repo/vaccinations_catalog_repo.dart';
import '../../features/vaccinations/data/services/child_vaccination_service.dart';
import '../../features/vaccinations/data/services/child_vaccination_schedule_service.dart';
import '../../features/vaccinations/data/services/vaccinations_catalog_service.dart';
import '../../features/vaccinations/presentation/cubit/vaccination_schedule_cubit.dart';
import '../../features/Examination/data/repo/sensory_test_repo.dart';
import '../../features/Examination/data/services/sensory_test_service.dart';
import '../../features/Examination/presentation/cubit/sensory_test_cubit.dart';
import '../../features/child_profile/data/repo/skills_repo.dart';
import '../../features/child_profile/data/services/skills_service.dart';
import '../../features/child_profile/presentation/cubit/skills_cubit.dart';
import '../../features/videos/data/repo/videos_repo.dart';
import '../../features/videos/data/services/videos_service.dart';
import '../../features/videos/presentation/cubit/videos_cubit.dart';
import '../../features/books/data/repo/textbooks_repo.dart';
import '../../features/books/data/services/textbooks_service.dart';
import '../../features/books/presentation/cubit/textbooks_cubit.dart';
import '../../features/child_profile/data/repo/growth_repo.dart';
import '../../features/child_profile/data/services/growth_service.dart';
import '../../features/child_profile/presentation/cubit/growth_cubit.dart';
import '../../features/home/data/datasources/doctors_list_remote_data_source.dart';
import '../../features/home/data/datasources/doctors_list_remote_data_source_impl.dart';
import '../../features/home/presentation/cubit/doctors_list_cubit.dart';
// import '../../features/home/data/datasource/Parent_Remote_DataSource_Impl.dart';
// import '../../features/home/data/datasource/doctor_repository_impl.dart';
// import '../../features/home/data/repo/Parent_Remote_DataSource.dart';
// import '../../features/home/data/repo/doctor_remote_data_source.dart';
// import '../../features/home/domain/repo/doctor_repository.dart';
// import '../../features/home/domain/repo/parent_repository.dart';
// import '../../features/home/domain/usecase/get_all_doctors_usecase.dart';
// import '../../features/home/domain/usecase/get_doctor_by_id_usecase.dart';
// import '../../features/home/domain/usecase/get_parent_profile_usecase.dart';
// import '../../features/home/presentation/cubit/doctor_cubit.dart';
// import '../../features/home/presentation/cubit/get_parent_profile_cubit.dart';
// import '../../features/videos/data/datasource/Video_Remote_DataSource_Impl.dart';
// import '../../features/videos/data/datasource/Video_Repository_Impl.dart';
// import '../../features/videos/data/repo/VideoRepositoryImpl.dart';
// import '../../features/videos/domain/repo/Video_Repository.dart';
// import '../../features/videos/domain/usecase/Get_All_Videos_UseCase.dart';
// import '../../features/videos/domain/usecase/Get_Video_By_Id.dart';
// import '../../features/videos/domain/usecase/Search_VideosUseCase.dart';
// import '../../features/videos/presentation/cubit/video_cubit.dart';
import '../api/api_manger.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';

// final sl = GetIt.instance;
//
// Future<void> init() async {
//   // ══════════════════════════════════════════════════════════════════════════
//   //  Cubits
//   // ══════════════════════════════════════════════════════════════════════════
//
//   sl.registerFactory(
//         () => SignUpCubit(
//       preSignUpUseCase: sl(),
//       verifySignUpUseCase: sl(),
//     ),
//   );
//
//   sl.registerFactory(
//         () => SignInCubit(
//       preSignInUseCase: sl(),
//       verifySignInUseCase: sl(),
//     ),
//   );
//
//   sl.registerFactory(
//         () => ResetPasswordCubit(
//       resetPasswordUseCase: sl(),
//       verifyPasswordOtpUseCase: sl(),
//     ),
//   );
//
//   sl.registerFactory(
//         () => ChangePasswordCubit(
//       changePasswordUseCase: sl(),
//     ),
//   );
//
//   sl.registerFactory(
//         () => CreateDoctorCubit(
//       createDoctorUseCase: sl(),
//     ),
//   );
//
//   // ══════════════════════════════════════════════════════════════════════════
//   //  Use Cases
//   // ══════════════════════════════════════════════════════════════════════════
//
//   sl.registerLazySingleton(() => PreSignUpUseCase(repository: sl()));
//   sl.registerLazySingleton(() => VerifySignUpUseCase(repository: sl()));
//   sl.registerLazySingleton(() => PreSignInUseCase(repository: sl()));
//   sl.registerLazySingleton(() => VerifySignInUseCase(repository: sl()));
//   sl.registerLazySingleton(() => ResetPasswordUseCase(repository: sl()));
//   sl.registerLazySingleton(() => VerifyPasswordOtpUseCase(repository: sl()));
//   sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
//   sl.registerLazySingleton(() => CreateDoctorUseCase(repository: sl()));
//
//   // ══════════════════════════════════════════════════════════════════════════
//   //  Repository
//   // ══════════════════════════════════════════════════════════════════════════
//
//   sl.registerLazySingleton<AuthRepository>(
//         () => AuthRepositoryImpl(
//       remoteDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );
//
//   // ══════════════════════════════════════════════════════════════════════════
//   //  Data Sources
//   // ══════════════════════════════════════════════════════════════════════════
//
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//         () => AuthRemoteDataSourceImpl(dio: sl()),
//   );
//
//   // ══════════════════════════════════════════════════════════════════════════
//   //  Core
//   // ══════════════════════════════════════════════════════════════════════════
//
//   sl.registerLazySingleton<NetworkInfo>(
//         () => NetworkInfoImpl(sl()),
//   );
//
//   sl.registerLazySingleton(
//         () => InternetConnection(),
//   );
//
//   sl.registerLazySingleton<Dio>(
//         () => Dio(
//       BaseOptions(
//         baseUrl: ApiConstant.baseUrl,
//         connectTimeout: const Duration(seconds: 15),
//         receiveTimeout: const Duration(seconds: 15),
//         headers: {'Accept': 'application/json'},
//       ),
//     ),
//   );
// }
final sl = GetIt.instance;

Future<void> init() async {
  DebugAuditLog.log(
    runId: 'pre-fix',
    hypothesisId: 'H2',
    location: 'lib/core/di/injection_container.dart:init',
    message: 'DI init starting',
    data: {
      'dioRegistered': sl.isRegistered<Dio>(),
      'authSessionRegistered': sl.isRegistered<AuthSession>(),
      'tokenStorageRegistered': sl.isRegistered<TokenStorage>(),
    },
  );

  // ═══════════════════════════════════════
  // Core
  // ═══════════════════════════════════════

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton<AuthSession>(() => AuthSession(sl()));

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(DioErrorInterceptor());
    dio.interceptors.add(DioAuthInterceptor(sl<AuthSession>()));
    dio.interceptors.add(DioUnauthorizedInterceptor(sl<AuthSession>()));
    return dio;
  });

  sl.registerLazySingleton<ApiManger>(() => ApiManger(sl()));

  sl.registerLazySingleton(() => InternetConnection());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ═══════════════════════════════════════
  // Data Sources
  // ═══════════════════════════════════════

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<ParentProfileRemoteDataSource>(
    () => ParentProfileRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<DoctorsListRemoteDataSource>(
    () => DoctorsListRemoteDataSourceImpl(dio: sl()),
  );

  // sl.registerLazySingleton<ParentRemoteDataSource>(
  //   () => ParentRemoteDataSourceImpl(dio: sl()),
  // );

  // sl.registerLazySingleton<DoctorRemoteDataSource>(
  //   () => DoctorRemoteDataSourceImpl(apiManager: sl()),
  // );

  // sl.registerLazySingleton<VideoRemoteDataSource>(
  //   () => VideoRemoteDataSourceImpl(apiManger: sl()),
  // );

  // ═══════════════════════════════════════
  // Repositories
  // ═══════════════════════════════════════

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<ParentProfileRepository>(
    () => ParentProfileRepository(sl()),
  );

  // ═══════════════════════════════════════
  // Booking
  // ═══════════════════════════════════════
  sl.registerLazySingleton<BookingService>(() => BookingService(sl()));
  sl.registerLazySingleton<BookingRepo>(() => BookingRepo(sl()));

  sl.registerLazySingleton<ChildVaccinationService>(
    () => ChildVaccinationService(sl()),
  );
  sl.registerLazySingleton<ChildVaccinationRepo>(
    () => ChildVaccinationRepo(sl()),
  );

  sl.registerLazySingleton<ChildVaccinationScheduleService>(
    () => ChildVaccinationScheduleService(sl()),
  );
  sl.registerLazySingleton<ChildVaccinationScheduleRepo>(
    () => ChildVaccinationScheduleRepo(sl()),
  );

  sl.registerLazySingleton<VaccinationsCatalogService>(
    () => VaccinationsCatalogService(sl()),
  );
  sl.registerLazySingleton<VaccinationsCatalogRepo>(
    () => VaccinationsCatalogRepo(sl()),
  );

  sl.registerLazySingleton<SensoryTestService>(() => SensoryTestService(sl()));
  sl.registerLazySingleton<SensoryTestRepo>(() => SensoryTestRepo(sl()));

  sl.registerLazySingleton<SkillsService>(() => SkillsService(sl()));
  sl.registerLazySingleton<SkillsRepo>(() => SkillsRepo(sl()));

  sl.registerLazySingleton<VideosService>(() => VideosService(sl()));
  sl.registerLazySingleton<VideosRepo>(() => VideosRepo(sl()));

  sl.registerLazySingleton<TextBooksService>(() => TextBooksService(sl()));
  sl.registerLazySingleton<TextBooksRepo>(() => TextBooksRepo(sl()));

  sl.registerLazySingleton<GrowthService>(() => GrowthService(sl()));
  sl.registerLazySingleton<GrowthRepo>(() => GrowthRepo(sl()));

  // sl.registerLazySingleton<ParentRepository>(
  //   () => ParentRepositoryImpl(remoteDataSource: sl()),
  // );

  // sl.registerLazySingleton<DoctorRepository>(
  //   () => DoctorRepositoryImpl(remoteDataSource: sl()),
  // );

  // sl.registerLazySingleton<VideoRepository>(
  //   () => VideoRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  // );

  // ═══════════════════════════════════════
  // UseCases
  // ═══════════════════════════════════════

  sl.registerLazySingleton(() => PreSignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifySignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddSignUpPasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => PreSignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifySignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyPasswordOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateDoctorUseCase(repository: sl()));
  // sl.registerLazySingleton(() => GetParentProfileUseCase(repository: sl()));
  // sl.registerLazySingleton(() => GetAllDoctorsUseCase(repository: sl()));
  // sl.registerLazySingleton(() => GetDoctorByIdUseCase(repository: sl()));

  // 🔥 FIXED: proper injection style
  // sl.registerLazySingleton<GetAllVideosUseCase>(
  //   () => GetAllVideosUseCase(sl()),
  // );

  // sl.registerLazySingleton<SearchVideosUseCase>(
  //   () => SearchVideosUseCase(sl()),
  // );

  // sl.registerLazySingleton<GetVideoByIdUseCase>(
  //   () => GetVideoByIdUseCase(sl()),
  // );

  // ═══════════════════════════════════════
  // Cubits
  // ═══════════════════════════════════════

  sl.registerFactory(
    () => SignUpCubit(
      preSignUpUseCase: sl(),
      verifySignUpUseCase: sl(),
      addSignUpPasswordUseCase: sl(),
      changePasswordUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => SignInCubit(preSignInUseCase: sl(), verifySignInUseCase: sl()),
  );

  sl.registerFactory(
    () => ResetPasswordCubit(
      resetPasswordUseCase: sl(),
      verifyPasswordOtpUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ChangePasswordCubit(changePasswordUseCase: sl()));

  sl.registerFactory(() => CreateDoctorCubit(createDoctorUseCase: sl()));

  sl.registerFactory<GoogleAuthCubit>(() => GoogleAuthCubit(sl()));

  sl.registerFactory<BookingCubit>(() => BookingCubit(sl()));
  sl.registerFactory<ParentProfileCubit>(() => ParentProfileCubit(sl()));
  sl.registerFactory<DoctorsListCubit>(() => DoctorsListCubit(sl()));
  sl.registerFactory<VaccinationScheduleCubit>(
    () => VaccinationScheduleCubit(
      parentRepo: sl(),
      scheduleRepo: sl(),
      vaccinationRepo: sl(),
      catalogRepo: sl(),
    ),
  );

  sl.registerFactory<SensoryTestCubit>(
    () => SensoryTestCubit(repo: sl(), parentRepo: sl()),
  );

  sl.registerFactory<SkillsCubit>(
    () => SkillsCubit(repo: sl(), parentRepo: sl()),
  );

  sl.registerFactory<VideosCubit>(() => VideosCubit(sl()));
  sl.registerFactory<TextBooksCubit>(() => TextBooksCubit(sl()));

  sl.registerFactory<GrowthCubit>(
    () => GrowthCubit(repo: sl(), parentRepo: sl()),
  );

  // sl.registerFactory(() => ParentCubit(getParentProfileUseCase: sl()));

  // sl.registerFactory(
  //   () => DoctorCubit(getAllDoctorsUseCase: sl(), getDoctorByIdUseCase: sl()),
  // );

  // // 🔥 FIXED: full injection (NOT sl() only)
  // sl.registerFactory<VideoCubit>(
  //   () => VideoCubit(
  //     getAllVideosUseCase: sl(),
  //     getVideoByIdUseCase: sl(),
  //     searchVideosUseCase: sl(),
  //   ),
  // );
}
