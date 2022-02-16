import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/engines/app_state.dart';

import '../models/user.dart';

class UserItem extends StatelessWidget {
  final User user;
  const UserItem({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(item);
    //final String itemURL = item['thumbnail']['url'];
    //final String pictureUrl =     'http://rarecamion.com:1337/api/upload/files/$itemURL';
    //print('Affichage matricule... ${item.matricule}');

    return ListTile(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //return VehiculeDetailsPage(user: user);
              return Text('');
            })),
        tileColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(Icons.account_box),
            Text('${user.username}', style: TextStyle(fontSize: 16.0)),
          ],
        ),
        subtitle: Text('${user.email}', style: TextStyle(fontSize: 12.0)),
        trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return state.user != null
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.grey,
                      onPressed: () => Text(''))
                  : Text('');
            }),
        onLongPress: () {
          print('Long Press !');
        });
  }
}
