import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/admin/items/adm_vehicule_detail_page.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/vehicule.dart';

class VehiculeItem extends StatefulWidget {
  final Vehicule vehicule;

  const VehiculeItem({Key key, this.vehicule}) : super(key: key);
  @override
  VehiculeItemState createState() => VehiculeItemState();
}

class VehiculeItemState extends State<VehiculeItem> {
  @override
  initState() {
    super.initState();

    _fetchStatus().then((value) {
      setState(() {
        statusV = value;
      });
      print(statusV.attributes.libelleStatus);
    });
  }

  StatusVehicule statusV = null;

  Future<StatusVehicule> _fetchStatus() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    StatusVehicule statusV = null;

    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=${widget.vehicule.id}&sort[0]=updatedAt:desc';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    Map<String, dynamic> statusDatasRAW =
        Map<String, dynamic>.from(json.decode(response.body));

    final statusDatas = statusDatasRAW['data'];

    if (response.statusCode != 200) {
      print('ERREUR DE CONNEXION AU SERVEUR !');
    } else {
      if (statusDatas.toString().length > 5) {
        statusV = StatusVehicule.fromJson(statusDatas[0]);
      }
    }

    return statusV;
  }

  @override
  Widget build(BuildContext context) {
    String _matricule = widget.vehicule.attributes.matricule;
    String _dechargement = widget.vehicule.attributes.dechargement;
    String _fournisseur = widget.vehicule.attributes.fournisseur;

    String _lastStatus =
        statusV != null ? statusV.attributes.libelleStatus : 'N/A';

    return ListTile(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VehiculeDetailsPage(vehicule: widget.vehicule);
      })),
      tileColor: Colors.blueAccent,
      title: Row(
        children: [
          Icon(Icons.car_repair),
          Text('$_fournisseur', style: TextStyle(fontSize: 16.0)),
        ],
      ),
      subtitle: Row(
        children: [
          //    Text('Mat. ', style: TextStyle(fontSize: 11.0)),
          Text('$_dechargement - ', style: TextStyle(fontSize: 12.0)),

          Text('$_matricule - '.toUpperCase(),
              style: TextStyle(fontSize: 13.0, color: Colors.blue)),
          _lastStatus.length > 3
              ? Text('$_lastStatus',
                  style: TextStyle(fontSize: 10.0, color: Colors.green))
              : Text('N/A', style: TextStyle(fontSize: 10.0, color: Colors.red))
        ],
      ),
      trailing: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return state.user != null
                ? IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: Colors.grey[800],
                    onPressed: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return VehiculeDetailsPage(vehicule: widget.vehicule);
                        })))
                : Text('');
          }),
    );
  }
}
