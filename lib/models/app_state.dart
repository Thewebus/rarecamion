import 'package:meta/meta.dart';
import 'package:rarecamion/models/user.dart';
import 'package:rarecamion/models/vehicule.dart';

@immutable
class AppState {
  final User user;
  final List<Vehicules> recordings;

  AppState({@required this.user, @required this.recordings});

  factory AppState.initial() {
    return AppState(user: null, recordings: []);
  }
}
