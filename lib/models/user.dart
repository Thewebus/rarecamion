import 'package:meta/meta.dart';

class User {
  int id;
  String username;
  String email;
  String jwt;
  String status;
  bool confirmed;
  bool blocked;

  User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.jwt,
      @required this.status,
      @required this.confirmed,
      @required this.blocked});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        jwt: json['jwt'],
        status: json['status'],
        confirmed: json['confirmed'],
        blocked: json['blocked']);
  }
}
