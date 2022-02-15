import 'package:meta/meta.dart';
import 'package:rarecamion/models/fournisseur.dart';
import 'package:rarecamion/models/user.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/models/status_vehicule.dart';

@immutable
class AppState {
  final User user;
  final List<Vehicule> vehicules;
  final List<StatusVehicule> vehiculeAllStatus;
  final List<Fournisseur> fournisseurs;
  final List<User> usersList;

  AppState(
      {@required this.user,
      @required this.vehicules,
      @required this.vehiculeAllStatus,
      @required this.fournisseurs,
      @required this.usersList});

  factory AppState.initial() {
    return AppState(
        user: null,
        vehicules: [],
        vehiculeAllStatus: [],
        fournisseurs: [],
        usersList: []);
  }
}
