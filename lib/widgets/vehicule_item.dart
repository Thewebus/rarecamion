import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/pages/add_status_to_vehicule.dart';
import 'package:rarecamion/pages/vehicule_detail_page.dart';

class VehiculeItem extends StatefulWidget {
  final Vehicule vehicule;

  const VehiculeItem({Key key, this.vehicule}) : super(key: key);
  @override
  VehiculeItemState createState() => VehiculeItemState();

  final StatusVehicule statusVehicule = null;
  //VehiculeItem({this.vehicule});

}

class VehiculeItemState extends State<VehiculeItem> {
  @override
  initState() {
    super.initState();

    _fetchStatus().then((value) {
      print(value);
      setState(() {
        _lastStatus = value;
      });
    });
  }

  String _lastStatus = '';

  Future<String> _fetchStatus() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String _return = '';

    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=${widget.vehicule.id}&sort[0]=updatedAt:desc';

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
        _return = status.attributes.libelleStatus;
      }
    }

    //print('VALEUR DU STATUS ---------  $_return');

    return _return;
  }

  void _deleteVehicule(int vehiculeID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    String url = 'http://rarecamion.com:1337/api/vehicules/$vehiculeID';

    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      setState(() {
        infoFlash = 'Impossible de supprimer le vehicule !';
        _showSnack(infoFlash);
      });
    } else {
      setState(() {
        infoFlash = 'Suppression du véhicule effectuée avec succès !';
        _showSnack(infoFlash);
      });
    }
  }

  void _showSnack(String message) {
    final snackbar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/vehicules');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return VehiculeDetailsPage(vehicule: widget.vehicule);
            })),
        tileColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(Icons.car_repair),
            Text('Mat. ', style: TextStyle(fontSize: 11.0)),
            Text('${widget.vehicule.attributes.matricule}',
                style: TextStyle(fontSize: 16.0)),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
                '${widget.vehicule.attributes.dechargement} - ${widget.vehicule.attributes.fournisseur} - ',
                style: TextStyle(fontSize: 12.0)),
            _lastStatus.length > 3
                ? Text(_lastStatus,
                    style: TextStyle(fontSize: 10.0, color: Colors.green))
                : Text('AUCUN STATUS',
                    style: TextStyle(fontSize: 10.0, color: Colors.red))
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
                            return AddStatusPage(vehicule: widget.vehicule);
                          })))
                  : Text('');
            }),
        onLongPress: () async {
          if (await confirm(
            context,
            title: const Text('Confirmez '),
            content: const Text(
                'Voulez-vous vraiment supprimer ce vehicule et tous ses status ?'),
            textOK: const Text('Oui, supprimer !'),
            textCancel: const Text('Non'),
          )) {
            return _deleteVehicule(widget.vehicule.id);
          } else
            return print('pressedCancel');
        });
  }
}
