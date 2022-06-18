import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/user.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/fournisseur.dart';
import 'package:rarecamion/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    vehicules: vehiculesReducer(state.vehicules, action),
    vehiculesAll: vehiculesAllReducer(state.vehiculesAll, action),
    vehiculeAllStatus: statusVehiculeReducer(state.vehiculeAllStatus, action),
    fournisseurs: fournisseursReducer(state.fournisseurs, action),
    usersList: usersListReducer(state.usersList, action),
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

List<Vehicule> vehiculesReducer(List<Vehicule> vehicules, dynamic action) {
  if (action is GetVehiculesAction) {
    return action.vehicules;
  }
  return vehicules;
}

List<Vehicule> vehiculesAllReducer(
    List<Vehicule> vehiculesAll, dynamic action) {
  if (action is GetVehiculesAllAction) {
    return action.vehiculesall;
  }
  return vehiculesAll;
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

List<User> usersListReducer(List<User> usersList, dynamic action) {
  if (action is GetUsersListAction) {
    return action.usersList;
  }
  return usersList;
}
