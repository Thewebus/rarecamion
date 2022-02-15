import 'package:meta/meta.dart';

class User {
  int id;
  String username;
  String email;
  String jwt;
  String status;

  User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.jwt,
      this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        jwt: json['jwt'],
        status: json['status']);
  }
}
