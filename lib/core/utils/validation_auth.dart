class ValidationAuth {
  static bool isPhoneOrEmailValid(String input) {
    if (input.contains('@')) {
      return isValidEmail(input);
    } else {
      return isPhoneValid(input);
    }
  }

  static bool isPhoneValid(String phone) {
    final RegExp phoneRegex = RegExp(r'^(?:\+84|0)(?:3|5|7|8|9)[0-9]{8}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isStrongPassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{6,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  static bool isCodeActive(String code) {
    final RegExp codeRegExp = RegExp(r'^\d{6}$');
    return codeRegExp.hasMatch(code);
  }
}
