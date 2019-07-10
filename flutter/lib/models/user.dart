class User {
  int id;
  String firstName, lastName, universityRegistration;
  User.fromJson(json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    universityRegistration = json['university_registration'];
  }
}
