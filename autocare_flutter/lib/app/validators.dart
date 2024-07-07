class FormValidators {
  static String? validatePassword(String? value) {
    if (value == null) {
      return null;
    }

    if (!value.contains(RegExp(r'((?=.*\d)(?=.*[A-z]).{6,20})'))) {
      return 'Password should contain 6 to 20 characters and at least one digit and letter.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null) {
      return null;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Enter valid email.';
    }
    return null;
  }

  static String? validateText(String? value) {
    if (value == null) {
      return null;
    }

    if (value.length < 3) {
      return 'Enter valid text.';
    }
    return null;
  }

  static String? validateNumber(String? value) {
    if (value == null) {
      return null;
    }
    RegExp regex = RegExp(r'^\d+(?:\.\d+)?$');
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Number';
    } else {
      return null;
    }
  }

  static String? validatePin(String? value) {
    if (value == null) {
      return null;
    }
    if (value.length != 4) {
      return 'Enter valid PIN of length 4 digits.';
    }
    RegExp regex = RegExp(r'^\d+(?:\.\d+)?$');
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Number';
    } else {
      return null;
    }
  }
}
