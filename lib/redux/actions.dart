import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/app_state.dart';
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

/* Recordings Actions */
ThunkAction<AppState> getRecordingsAction = (Store<AppState> store) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  http.Response response = await http.get(
      Uri.parse('http://rarecamion.com:1337/api/vehicules'),
      headers: headers);

  Map<String, dynamic> dataHash =
      new Map<String, dynamic>.from(json.decode(response.body));
  //print(dataHash['data']);
  final List<dynamic> responseData = dataHash['data'];
  store.dispatch(GetRecordingsAction(responseData));
};

class GetRecordingsAction {
  final List<dynamic> _recordings;

  List<dynamic> get recordings => this._recordings;

  GetRecordingsAction(this._recordings);
}
