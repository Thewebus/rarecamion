import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/models/user.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* User Actions */
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

/* Recordings Actions */
ThunkAction<AppState> getRecordingsAction = (Store<AppState> store) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  http.Response response = await http.get(
      Uri.parse('http://rarecamion.com:1337/api/vehicules'),
      headers: headers);
  Map<String, dynamic> vehiculesRawData =
      new Map<String, dynamic>.from(json.decode(response.body));
  final vehiculesData = vehiculesRawData['data'];

//Debut du process de refactoring ...
  final List<Vehicules> vehicules = [];

  vehiculesData.forEach((productData) {
    final Vehicules vehicule = Vehicules.fromJson(productData);
    vehicules.add(vehicule);
  });
  store.dispatch(GetRecordingsAction(vehicules));
};

class GetRecordingsAction {
  final List<Vehicules> _vehicules;
  List<Vehicules> get recordings => this._vehicules;
  GetRecordingsAction(this._vehicules);
}
