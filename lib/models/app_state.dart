import 'package:meta/meta.dart';

@immutable
class AppState {
  final dynamic user;
  final List<dynamic> recordings;

  AppState({@required this.user, @required this.recordings});

  factory AppState.initial() {
    return AppState(user: null, recordings: []);
  }
}
