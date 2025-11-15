import 'package:fridge_to_fork_ai/core/utils/validation_auth.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/login_model.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/register_model.dart';

import '../models/refresh_token_model.dart';

class AuthRemoteDataSource {
  LoginModel? _session;

  // Fake mock database of registered users
  final List<LoginModel> _mockUsers = [
    LoginModel(
      id: "u001",
      phone: "0987654321",
      email: "finpal.user@gmail.com",
      password: "Finpal@123",
      accessToken: "mock_access_token_123",
      refreshToken: "mock_refresh_token_456",
    ),
  ];

  /// LOGIN
  Future<LoginModel> login(String input, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!ValidationAuth.isPhoneOrEmailValid(input)) {
      throw Exception("Invalid phone number or email");
    }

    if (!ValidationAuth.isStrongPassword(password)) {
      throw Exception("Weak password");
    }

    // Find user from mock database
    final user = _mockUsers.firstWhere(
      (u) => (u.email == input || u.phone == input) && u.password == password,
      orElse: () => throw Exception("Incorrect credentials"),
    );

    // Simulate session
    _session = user;
    return user;
  }

  /// REGISTER (NEW)
  Future<RegisterModel> register(
    String email,
    String phone,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Validate email
    if (!ValidationAuth.isValidEmail(email)) {
      throw Exception("Invalid email");
    }

    // Validate phone
    if (!ValidationAuth.isPhoneValid(phone)) {
      throw Exception("Invalid phone");
    }

    // Validate password
    if (!ValidationAuth.isStrongPassword(password)) {
      throw Exception("Weak password");
    }

    // Mock success response
    return RegisterModel(
      message: "Register successfully",
      success: true,
      statusCode: 200,
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _session = null;
  }

  /// CURRENT USER
  Future<LoginModel?> currentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _session;
  }

  Future<RefreshTokenModel> refreshToken(String refreshToken) async {
    // Giả lập độ trễ gọi API (cho giống thật)
    await Future.delayed(const Duration(seconds: 1));

    // Bạn có thể kiểm tra refreshToken truyền vào
    if (refreshToken == "expired_token") {
      // Mô phỏng token hết hạn
      throw Exception("Refresh token expired");
    }

    // Dữ liệu mẫu mock theo cấu trúc API thật
    final mockJson = {
      "access_token": "mock_access_token_123456",
      "refresh_token": "mock_refresh_token_654321",
      "token_type": "Bearer",
      "expires_in": 3600, // 1 giờ
    };

    return RefreshTokenModel.fromJson(mockJson);
  }

  Future<void> verify(String username, String code, String purpose) async {
    // Giả lập delay khi gọi API
    await Future.delayed(const Duration(milliseconds: 800));

    // Mô phỏng các TH verify thất bại (để test UI)
    if (code == "000000") {
      throw Exception("Invalid verification code");
    }

    if (code == "expired") {
      throw Exception("Verification code has expired");
    }

    if (username == "unknown@example.com") {
      throw Exception("User not found");
    }

    // Nếu không rơi vào các TH lỗi → thành công
    return;
  }

  Future<void> sendRequest(String username) async {
    await Future.delayed(const Duration(seconds: 1));

    throw Exception("Mock: email does not exist");
  }
}
