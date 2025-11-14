class RefreshToken {
  final String accessToken;
  final String tokenType;
  final String expiresIn;

  const RefreshToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });
}
