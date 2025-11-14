class Login {
  final String id;
  final String email;
  final String password;
  final String phone;
  final String accessToken;
  final String refreshToken;

  const Login({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
    required this.accessToken,
    required this.refreshToken,
  });
}
