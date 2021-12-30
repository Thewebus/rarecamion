import 'dart:convert';
import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/recording.dart';
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
  http.Response response =
      await http.get(Uri.parse('http://rarecamion.com:1337/api/vehicules'));

  Map<String, dynamic> datas =
      new Map<String, dynamic>.from(json.decode(response.body));

  final data = pick(datas, 'data', 0).required().asMapOrThrow();
  print('data');

  final List<dynamic> responseData = json.decode(data.toString());
  //final List<dynamic> responseData = json.decode(response.body);

  List<Recording> recordings = [];
  responseData.forEach((recordingData) {
    final Recording recording = Recording.fromJson(recordingData);
    print(recording.dechargement);
    recordings.add(recording);
  });
  store.dispatch(GetRecordingsAction(recordings));
};

class GetRecordingsAction {
  final List<Recording> _recordings;
  List<Recording> get recordings => this._recordings;
  GetRecordingsAction(this._recordings);
}
