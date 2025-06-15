class UserModel {
  final int id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? phone;
  final String? password;

  UserModel({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.middleName,
    this.phone,
    this.password,
  });

  // Factory constructor to create a User from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (middleName != null) 'middleName': middleName,
      if (phone != null) 'phone': phone,
      if (password != null) 'password': password,
    };
  }
}
