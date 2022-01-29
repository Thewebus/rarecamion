import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/user.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/fournisseur.dart';
import 'package:rarecamion/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    recordings: recordingsReducer(state.recordings, action),
    statusvehicule: statusVehiculeReducer(state.statusvehicule, action),
    fournisseurs: fournisseursReducer(state.fournisseurs, action),
  );
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

List<Vehicules> recordingsReducer(List<Vehicules> recordings, dynamic action) {
  if (action is GetRecordingsAction) {
    return action.recordings;
  }
  return recordings;
}

List<StatusVehicule> statusVehiculeReducer(
    List<StatusVehicule> statusvehicule, dynamic action) {
  if (action is GetStatusAction) {
    return action.statusvehicule;
  }
  return statusvehicule;
}

List<Fournisseur> fournisseursReducer(
    List<Fournisseur> fournisseurs, dynamic action) {
  if (action is GetFournisseursAction) {
    return action.fournisseurs;
  }
  return fournisseurs;
}
