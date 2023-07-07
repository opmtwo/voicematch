import 'package:email_validator/email_validator.dart';

bool isPasswordValid(String value) {
  RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\S]{8,}$');
  if (!regex.hasMatch(value)) {
    return false;
  }
  return true;
}

bool isEmailValid(String value) {
  return EmailValidator.validate(value);
}
