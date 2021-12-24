import 'package:meta/meta.dart';
import 'package:rarecamion/models/recording.dart';
import 'package:rarecamion/models/user.dart';

@immutable
class AppState {
  final User user;
  final List<Recording> recordings;

  AppState({@required this.user, @required this.recordings});

  factory AppState.initial() {
    return AppState(user: null, recordings: []);
  }
}
