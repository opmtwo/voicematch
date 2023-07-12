import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:voicematch/router.dart';

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

Future<void> redirectUser() async {
  List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();
  String isSetupDone = attributes
          .firstWhereOrNull((element) =>
              element.userAttributeKey ==
              const CognitoUserAttributeKey.custom('custom:is_setup_done'))
          ?.value ??
      '';
  if (isSetupDone == 'true') {
    Get.offNamedUntil(
      Routes.matchesIndex,
      (route) => false,
    );
  } else {
    Get.offNamedUntil(
      Routes.setupIntro,
      (route) => false,
    );
  }
}
