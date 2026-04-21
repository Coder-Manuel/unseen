import 'package:unseen/core/models/enums.dart';

class LoginInput {
  final String? email;
  final String? phone;
  final String? password;

  LoginInput({this.email, this.phone, this.password})
    : assert(
        (email != null || phone != null) && password != null,
        'Provide (email or phone) and password',
      );

  Map<String, dynamic> toMap() => {
    'email': email,
    'phone': phone,
    'password': password,
  };
}

class OAuthInput {
  final String idToken;
  final String? accessToken;

  OAuthInput({required this.idToken, this.accessToken});

  Map<String, dynamic> toMap() => {
    'idToken': idToken,
    'accessToken': accessToken,
  };
}

class SignupInput {
  final String email;
  final String password;
  final UserRole role;

  SignupInput({
    required this.email,
    required this.password,
    this.role = UserRole.client,
  });

  Map<String, dynamic> toMap() => {
    'email': email,
    'password': password,
    'meta': {'role': role.name},
  };
}

class VerifyOtpInput {
  final String otp;
  final String? email;
  final String? phone;

  VerifyOtpInput.email({required this.otp, required String this.email})
    : phone = null;

  VerifyOtpInput.phone({required this.otp, required String this.phone})
    : email = null;

  Map<String, dynamic> toMap() => {'otp': otp, 'email': email, 'phone': phone};
}

class PhoneSetupInput {
  final String phone;

  PhoneSetupInput({required this.phone});
}

class NamesInput {
  final String firstName;
  final String lastName;

  NamesInput({required this.firstName, required this.lastName});

  Map<String, dynamic> toMap() => {
    'first_name': firstName,
    'last_name': lastName,
  };
}
