import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/pages/add_status_to_vehicule.dart';
import 'package:rarecamion/pages/recording_detail_page.dart';

class RecordingItem extends StatelessWidget {
  final Vehicule item;
  RecordingItem({this.item});

  @override
  Widget build(BuildContext context) {
    //print(item);
    //final String itemURL = item['thumbnail']['url'];
    //final String pictureUrl =     'http://rarecamion.com:1337/api/upload/files/$itemURL';
    //print('Affichage matricule... ${item.matricule}');

    void _redirectUserToAddStatus() {
      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.pushReplacementNamed(context, '/addstatustovehicule');
      });
    }

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
        title: Row(
          children: [
            Icon(Icons.car_repair),
            Text('Mat. ', style: TextStyle(fontSize: 11.0)),
            Text('${item.attributes.matricule}',
                style: TextStyle(fontSize: 16.0)),
          ],
        ),
        subtitle: Text(
            '${item.attributes.dechargement} - ${item.attributes.fournisseur}',
            style: TextStyle(fontSize: 12.0)),
        trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return state.user != null
                  ? IconButton(
                      icon: Icon(Icons.add_box_outlined),
                      color: Colors.grey[800],
                      onPressed: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddStatusPage(item: item);
                          })))
                  : Text('');
            }),
        onLongPress: () {
          print('Long Press !');
        });
  }
}
