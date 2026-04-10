class Validator {
  static String? validateNationality(String nationality) {
    if (nationality.isEmpty) {
      return 'Nationality is required';
    }

    if (nationality.length <= 3) {
      return 'too short';
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length <= 4) {
      return 'Name is too short!';
    }

    if(name.length > 10) {
      return 'Not more 10 characters';
    }

    return null;
  }

  static String? validateLeagueName(String name) {
    if (name.isEmpty) {
      return 'League name is required';
    }

    if (name.length <= 4) {
      return 'League name is too short!';
    }

    if(name.length > 20) {
      return 'Not more 20 characters';
    }

    return null;
  }

  static String? validateCoinsGoal(String goal) {
    if (goal.isEmpty) {
      return 'Coins goal is required';
    }

    if (int.parse(goal.replaceAll(',', '')) > 500000) {
      return 'Coins goal maximum is 500,000';
    }

    if (int.parse(goal.replaceAll(',', '')) < 5000) {
      return 'Coins goal minimum is 5,000';
    }

    return null;
  }


  static String? validateCountry(String country) {
    if (country.isEmpty) {
      return 'Country is required';
    }

    if (country.length <= 4) {
      return 'Country is too short!';
    }

    return null;
  }

  static String? validateConfirmPassword(String confirmPassword, String password){
    if(confirmPassword.isEmpty){
      return 'Confirm Password is Required';
    }
    if(confirmPassword != password){
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePassword(String password) {

    if (password.isEmpty) {
      return 'Password is Required';
    }

    if (password.length <= 4) {
      return 'Password is too short!';
    }

    return null;
  }


  static String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return 'Phone number is Required';
    }

    if (phoneNumber.length < 10 || phoneNumber.length > 14) {
      return 'should between 10 and 14 digits';
    }

    return null;
  }

  static String? validateEmail(String newEmailId, {String oldEmailId = ''}) {
    if (newEmailId.isEmpty) {
      return 'Email Address is Required';
    }

    String exp =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(exp);

    if (!regExp.hasMatch(newEmailId)) {
      return 'Please enter a valid email address';
    }

    if (newEmailId == oldEmailId) {
      return 'You are currently using this email address. Select a new one';
    }

    return null;
  }


}
