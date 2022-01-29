import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/fournisseur.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/user.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* USER Actions */
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;
  User get user => this._user;
  GetUserAction(this._user);
}

/* LOGOUT USER Actions */
ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};

class LogoutUserAction {
  final User _user;
  User get user => this._user;
  LogoutUserAction(this._user);
}

/// VEHICULE
/* Getting VEHICULES Actions */
ThunkAction<AppState> getRecordingsAction = (Store<AppState> store) async {
//Getting the USER here ...
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  String userEmail = user.email;

//Getting the VEHICULES here ...
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  String url =
      'http://rarecamion.com:1337/api/vehicules?populate=*&filters[user][email][\$eq]=$userEmail';

  print(url);

  http.Response response = await http.get(Uri.parse(url), headers: headers);
  Map<String, dynamic> fournisseursDataRAW =
      new Map<String, dynamic>.from(json.decode(response.body));
  final fournisseursDatas = fournisseursDataRAW['data'];

  final List<Vehicules> vehicules = [];

  fournisseursDatas.forEach((fournisseurData) {
    final Vehicules vehicule = Vehicules.fromJson(fournisseurData);
    vehicules.add(vehicule);
  });
  store.dispatch(GetRecordingsAction(vehicules));
};

class GetRecordingsAction {
  final List<Vehicules> _vehicules;
  List<Vehicules> get recordings => this._vehicules;
  GetRecordingsAction(this._vehicules);
}

/// STATUS VEHICULE
/* Getting STATUS VEHICULE Actions */
ThunkAction<AppState> getstatusAction = (Store<AppState> store) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  String vehiculeRelatedID = '';

  String url =
      'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$vehiculeRelatedID';

  http.Response response = await http.get(Uri.parse(url), headers: headers);

  Map<String, dynamic> fournisseursDataRAW =
      new Map<String, dynamic>.from(json.decode(response.body));
  final fournisseursDatas = fournisseursDataRAW['data'];
  final List<StatusVehicule> statusall = [];
  fournisseursDatas.forEach((fournisseurData) {
    final StatusVehicule status = StatusVehicule.fromJson(fournisseurData);
    statusall.add(status);
  });
  store.dispatch(GetStatusAction(statusall));
};

class GetStatusAction {
  final List<StatusVehicule> _statusvehicule;
  List<StatusVehicule> get statusvehicule => this._statusvehicule;
  GetStatusAction(this._statusvehicule);
}

/// FOURNISSEURS
// Get Fournisseurs Actions ...
ThunkAction<AppState> getFournisseursAction = (Store<AppState> store) async {
//Getting the Fournisseurs here ...
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  String url = 'http://rarecamion.com:1337/api/fournisseurs';
  http.Response response = await http.get(Uri.parse(url), headers: headers);
  Map<String, dynamic> fournisseursDataRAW =
      new Map<String, dynamic>.from(json.decode(response.body));
  final fournisseursDatas = fournisseursDataRAW['data'];

  final List<Fournisseur> fournisseurs = [];

  fournisseursDatas.forEach((fournisseurData) {
    final Fournisseur fournisseur = Fournisseur.fromJson(fournisseurData);
    fournisseurs.add(fournisseur);
  });
  store.dispatch(GetFournisseursAction(fournisseurs));
};

class GetFournisseursAction {
  final List<Fournisseur> _fournisseurs;
  List<Fournisseur> get fournisseurs => this._fournisseurs;
  GetFournisseursAction(this._fournisseurs);
}
