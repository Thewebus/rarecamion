import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/recording.dart';

class RecordingItem extends StatelessWidget {
  final Recording item;
  RecordingItem({this.item});

  @override
  Widget build(BuildContext context) {
    //final String itemURL = item['thumbnail']['url'];
    //final String pictureUrl =     'http://rarecamion.com:1337/api/upload/files/$itemURL';
    print('Affichage matricule... ${item.matricule}');
    return GridTile(
      child: Container(),
      /*Image.network(
      pictureUrl,
      fit: BoxFit.cover,
    )*/
      footer: GridTileBar(
          title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('item.matricule', style: TextStyle(fontSize: 14.0))),
          subtitle: Text('item.dechargement', style: TextStyle(fontSize: 16.0)),

          // subtitle: Text("\$${item.price}", style: TextStyle(fontSize: 16.0)),
          backgroundColor: Color(0xBB000000),
          trailing: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                return state.user != null
                    ? IconButton(
                        icon: Icon(Icons.agriculture),
                        color: Colors.white,
                        onPressed: () => print('pressed'))
                    : Text('');
              })),
    );
  }
}
