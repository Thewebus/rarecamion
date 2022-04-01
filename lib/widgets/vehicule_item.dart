import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/pages/add_status_to_vehicule.dart';
import 'package:rarecamion/pages/vehicule_detail_page.dart';

class VehiculeItem extends StatelessWidget {
  final Vehicule vehicule;
  final StatusVehicule statusVehicule = null;
  VehiculeItem({this.vehicule});    
  
  String _lastStatus = '';

 _fetchStatus().then((value) {

      this. = '';
 = value;
      
    });


  Future<String> _fetchStatus() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };



    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=${vehicule.id}&sort[0]=updatedAt:desc';

    //print(url);

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    Map<String, dynamic> statusDatasRAW =
        Map<String, dynamic>.from(json.decode(response.body));

    final statusDatas = statusDatasRAW['data'];

    if (response.statusCode != 200) {
      print('ERREUR DE CONNEXION AU SERVEUR !');
    } else {
      if (statusDatas.toString().length > 5) {
        final StatusVehicule status = StatusVehicule.fromJson(statusDatas[0]);
        lastStatus = status.attributes.libelleStatus;
      }
    }

    return lastStatus;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return VehiculeDetailsPage(vehicule: vehicule);
            })),
        tileColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(Icons.car_repair),
            Text('Mat. ', style: TextStyle(fontSize: 11.0)),
            Text('${vehicule.attributes.matricule}',
                style: TextStyle(fontSize: 16.0)),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
                '${vehicule.attributes.dechargement} - ${vehicule.attributes.fournisseur}',
                style: TextStyle(fontSize: 12.0)),
            Text(' ... ', style: TextStyle(fontSize: 11.0)),
          ],
        ),
        trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return state.user != null
                  ? IconButton(
                      icon: Icon(Icons.add_box_outlined),
                      color: Colors.grey[800],
                      onPressed: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddStatusPage(vehicule: vehicule);
                          })))
                  : Text('');
            }),
        onLongPress: () {
          print('Long Press !');
        });
  }
}
