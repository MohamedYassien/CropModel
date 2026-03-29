import 'package:easy_localization/easy_localization.dart';

class Helpers {
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'full_name_required'.tr();
    }
    if (value.trim().length < 3) {
      return 'full_name_too_short'.tr();
    }
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value)) {
      return 'full_name_invalid'.tr();
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'email_required'.tr();
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'email_invalid'.tr();
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'phone_number_required'.tr();
    }

    final trimmedValue = value.trim();

    final phoneRegex = RegExp(r'^(?:\+20|20|0)?1[0125][0-9]{8}$');

    if (!phoneRegex.hasMatch(trimmedValue)) {
      return 'phone_invalid'.tr();
    }

    return null;
  }
}
