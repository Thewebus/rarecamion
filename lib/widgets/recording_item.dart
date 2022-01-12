import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/pages/recording_detail_page.dart';

class RecordingItem extends StatelessWidget {
  final Vehicules item;
  RecordingItem({this.item});

  @override
  Widget build(BuildContext context) {
    //final String itemURL = item['thumbnail']['url'];
    //final String pictureUrl =     'http://rarecamion.com:1337/api/upload/files/$itemURL';
    //print('Affichage matricule... ${item.matricule}');
    return ListTile(
        /*Image.network(
      pictureUrl,
      fit: BoxFit.cover,
    )*/
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RecordingDetailPage(item: item);
            })),
        tileColor: Colors.blueAccent,
        title: Text('MAT: ${item.attributes.matricule}',
            style: TextStyle(fontSize: 14.0)),
        subtitle: Text('Déchargement: ${item.attributes.dechargement}',
            style: TextStyle(fontSize: 16.0)),
        trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return state.user != null
                  ? IconButton(
                      icon: Icon(Icons.arrow_forward_ios_sharp),
                      color: Colors.blueAccent,
                      onPressed: () => print('pressed'))
                  : Text('');
            }),
        onLongPress: () {
          print('Long Press !');
        });
  }
}
