import 'package:meta/meta.dart';
import 'package:rarecamion/models/user.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/models/status_vehicule.dart';

@immutable
class AppState {
  final User user;
  final List<Vehicules> recordings;
  final List<StatusVehicule> statusvehicule;

  AppState(
      {@required this.user,
      @required this.recordings,
      @required this.statusvehicule});

  factory AppState.initial() {
    return AppState(user: null, recordings: [], statusvehicule: []);
  }
}
