import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rarecamion/engines/app_state.dart';
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

/// VEHICULES BY AGENTS
/* Getting VEHICULES Actions by User */
ThunkAction<AppState> getVehiculesAction = (Store<AppState> store) async {
//Getting the USER here ...
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  final String userEmail = user.email;

//Getting the VEHICULES here ...
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  String url =
      'http://rarecamion.com:1337/api/vehicules?populate=*&filters[user][email][\$eq]=$userEmail&sort[0]=updatedAt:desc';

  http.Response response = await http.get(Uri.parse(url), headers: headers);

  final responseData = json.decode(response.body);

  if (response.statusCode != 200) {
    print(responseData);
  } else {
    Map<String, dynamic> vehiculesStrapiJson =
        new Map<String, dynamic>.from(responseData);

    final vehiculesJson = vehiculesStrapiJson['data'];

    final List<Vehicule> vehicules = [];
    vehiculesJson.forEach((vehiculeJson) {
      final Vehicule vehicule = Vehicule.fromJson(vehiculeJson);
      vehicules.add(vehicule);
    });
    store.dispatch(GetVehiculesAction(vehicules));
  }
};

class GetVehiculesAction {
  final List<Vehicule> _vehicules;
  List<Vehicule> get vehicules => this._vehicules;
  GetVehiculesAction(this._vehicules);
}

/// ALL VEHICULE STATUS
/* Getting ALL VEHICULE STATUS Actions */
ThunkAction<AppState> getstatusAction = (Store<AppState> store) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  String vehiculeRelatedID = '';

  String url =
      'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$vehiculeRelatedID';

  http.Response response = await http.get(Uri.parse(url), headers: headers);

  Map<String, dynamic> statusDatasRAW =
      new Map<String, dynamic>.from(json.decode(response.body));

  final statusDatas = statusDatasRAW['data'];

  final List<StatusVehicule> listOfStatusObjects = [];

  statusDatas.forEach((statusData) {
    final StatusVehicule status = StatusVehicule.fromJson(statusData);
    listOfStatusObjects.add(status);
  });
  store.dispatch(GetStatusAction(listOfStatusObjects));
};

class GetStatusAction {
  final List<StatusVehicule> _statusvehicule;
  List<StatusVehicule> get statusvehicule => this._statusvehicule;
  GetStatusAction(this._statusvehicule);
}

/// FOURNISSEURS
/* Getting Fournisseurs Actions ... */
ThunkAction<AppState> getFournisseursAction = (Store<AppState> store) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  String url =
      'http://rarecamion.com:1337/api/fournisseurs?pagination[limit]=100';

  http.Response response = await http.get(Uri.parse(url), headers: headers);

  final responseData = json.decode(response.body);

  if (response.statusCode != 200) {
    print(responseData);
  } else {
    Map<String, dynamic> fournisseursStrapiJson =
        new Map<String, dynamic>.from(responseData);

    final fournisseursJson = fournisseursStrapiJson['data'];

    final List<Fournisseur> fournisseurs = [];

    fournisseursJson.forEach((fournisseurJson) {
      final Fournisseur fournisseur = Fournisseur.fromJson(fournisseurJson);
      fournisseurs.add(fournisseur);
    });

    store.dispatch(GetFournisseursAction(fournisseurs));
  }
};

class GetFournisseursAction {
  final List<Fournisseur> _fournisseurs;
  List<Fournisseur> get fournisseurs => this._fournisseurs;
  GetFournisseursAction(this._fournisseurs);
}

/// LISTE DES UTILISATEURS
/* Getting UsersList Actions ... */
ThunkAction<AppState> getUsersListAction = (Store<AppState> store) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  String url =
      'http://rarecamion.com:1337/api/users?filters[status][\$eq]=normal';

  http.Response response = await http.get(Uri.parse(url), headers: headers);

  final responseData = json.decode(response.body);

  final List<User> usersList = [];

  if (response.statusCode != 200) {
    print(responseData);
  } else {
    responseData.forEach((dataJson) {
      final User user = User.fromJson(dataJson);
      usersList.add(user);
      //print('User listed: ${user.username}');
    });

    //print('Users listed: $usersList');

    store.dispatch(GetUsersListAction(usersList));
  }
};

class GetUsersListAction {
  final List<User> _usersList;
  List<User> get usersList => this._usersList;
  GetUsersListAction(this._usersList);
}

/// VEHICULES ALL (BY ADMINS)
/* Getting VEHICULES Actions by Admins */
ThunkAction<AppState> getVehiculesAllAction = (Store<AppState> store) async {
//Getting the VEHICULES here ...
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  String url =
      'http://rarecamion.com:1337/api/vehicules?populate=*&sort[0]=updatedAt:desc';

  http.Response response = await http.get(Uri.parse(url), headers: headers);

  final responseData = json.decode(response.body);

  if (response.statusCode != 200) {
    print(responseData);
  } else {
    Map<String, dynamic> vehiculesStrapiJson =
        new Map<String, dynamic>.from(responseData);

    final vehiculesJson = vehiculesStrapiJson['data'];

    final List<Vehicule> vehicules = [];
    vehiculesJson.forEach((vehiculeJson) {
      final Vehicule vehicule = Vehicule.fromJson(vehiculeJson);
      vehicules.add(vehicule);
    });
    store.dispatch(GetVehiculesAllAction(vehicules));
  }
};

class GetVehiculesAllAction {
  final List<Vehicule> _vehiculesAll;
  List<Vehicule> get vehiculesall => this._vehiculesAll;
  GetVehiculesAllAction(this._vehiculesAll);
}
