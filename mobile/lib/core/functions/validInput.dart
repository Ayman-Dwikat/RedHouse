import 'package:get/get.dart';

validInput(String val, int min, int max, String type) {
  if (val.isEmpty) {
    return "This field is required";
  }

  if (val.length < min) {
    return "value can't be less than $min";
  }

  if (val.length > max) {
    return "value can't be larger than $max";
  }

  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "not valid username";
    }
  }

  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "not valid email";
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "not valid phone";
    }
  }

  if (type == "password") {
    if (!isValidPassword(val)) {
      return "Must be contain letters, numbers, and symbols";
    }
  }

  // Return "" if input is valid
  return "";
}

bool isValidPassword(String password) {
  // Check if the password contains at least one letter
  if (!password.contains(RegExp(r'[a-zA-Z]'))) {
    return false;
  }

  // Check if the password contains at least one number
  if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  }

  // Check if the password contains at least one symbol (non-alphanumeric character)
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return false;
  }

  // If all conditions are met, the password is considered valid
  return true;
}
