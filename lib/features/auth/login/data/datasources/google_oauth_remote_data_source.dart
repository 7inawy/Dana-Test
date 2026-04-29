import 'package:dana/features/auth/login/data/datasources/auth_remote_data_source.dart';
import 'package:dana/features/auth/login/data/model/user_model.dart';

abstract class GoogleOAuthRemoteDataSource {
  Future<dynamic> googleSignIn();

  Future<UserModel> googleComplete({
    required String requestId,
    required String phone,
    required String password,
    required String government,
    required String address,
    required List<ChildData> children,
  });
}

