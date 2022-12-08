var regEx = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

String emailValidator(String value) {
  if (!regEx.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String nameValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your name';
  }
  return null;
}

String professionValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your profession';
  }
  return null;
}

String workValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your place of work';
  }
  return null;
}

String eduValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your place of education';
  }
  return null;
}

String bioValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your bio';
  }
  return null;
}

String jumpValidator(String value) {
  if (value.isEmpty) {
    return 'Field required';
  }
  return null;
}

String unameValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your user name';
  }
  if (value.length > 30) {
    return 'Exceeded 30 characters';
  }
  if (value.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
    return null;
  }
  return 'Only alphanumeric characters allowed';
}

String phoneValidator(String value) {
  if (value.isEmpty) {
    return 'Enter your phone number';
  }
  return null;
}
