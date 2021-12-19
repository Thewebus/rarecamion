import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/redux/actions.dart';

AppState appReducer(state, action) {
  return AppState(user: userReducer(state.user, action));
}

userReducer(user, action) {
  if (action is GetUserAction) {
    //return user from action
    return action.user;
  }

  return user;
}
