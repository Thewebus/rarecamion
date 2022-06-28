import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/admin/items/adm_vehicule_detail_page.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:dio/dio.dart';

class VehiculeItem extends StatefulWidget {
  final Vehicule vehicule;

  const VehiculeItem({Key key, this.vehicule}) : super(key: key);
  @override
  VehiculeItemState createState() => VehiculeItemState();
}

class VehiculeItemState extends State<VehiculeItem> {
  //
  @override
  initState() {
    super.initState();

    _vehiculeId = widget.vehicule.id.toInt();

    _getAllStatusByVehiculeId(_vehiculeId).then((value) {
      setState(() {
        if (value != null) {
          statusV = value;
          _libelleStatus = statusV.attributes.libelleStatus;
        }
      });
    });
  }

//
  StatusVehicule statusV = null;
  String _libelleStatus = 'N/A';
  int _vehiculeId;
  //

  /*
      const _timeRefresh = const Duration(seconds: 3);

    new Timer.periodic(
        _timeRefresh,
        (Timer t) => setState(() {
              
            }));
   // print('Counter = ...$_counter');
*/

  Future<StatusVehicule> _getAllStatusByVehiculeId(int _id) async {
    //

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    StatusVehicule statusV = null;

    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$_id&sort[0]=updatedAt:desc';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> statusDatasRAW =
          Map<String, dynamic>.from(json.decode(response.body));

      final statusDatas = statusDatasRAW['data'];
      if (statusDatas.toString().length > 5) {
        statusV = StatusVehicule.fromJson(statusDatas[0]);
      }
    } else {
      throw "ERREUR DE CONNEXION AU SERVEUR !";
    }

    return statusV;
  }

  @override
  Widget build(BuildContext context) {
    String _matricule = widget.vehicule.attributes.matricule;
    String _dechargement = widget.vehicule.attributes.dechargement;
    String _fournisseur = widget.vehicule.attributes.fournisseur;

    _vehiculeId = widget.vehicule.id.toInt();

    const _timeRefresh = const Duration(seconds: 60);

    new Timer.periodic(_timeRefresh, (Timer t) {
      // print(t.tick);

      _getAllStatusByVehiculeId(_vehiculeId).then((value) {
        if (this.mounted) {
          setState(() {
            if (value != null) {
              statusV = value;
              _libelleStatus = statusV.attributes.libelleStatus;
              print(
                  'Vehicule checké ... Fournisseur: ${widget.vehicule.attributes.dechargement}, Mat.:  ${widget.vehicule.attributes.matricule} !');
            }
          });
        }
      });
    });

    return ListTile(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VehiculeDetailsPage(vehicule: widget.vehicule);
      })),
      title: Row(
        children: [
          Icon(Icons.car_repair),
          Text('$_fournisseur',
              style: TextStyle(fontSize: 18.0, color: Colors.black)),
        ],
      ),
      subtitle: Row(
        children: [
          //    Text('Mat. ', style: TextStyle(fontSize: 11.0)),
          Text('$_dechargement - ', style: TextStyle(fontSize: 12.0)),

          Text('$_matricule - '.toUpperCase(),
              style: TextStyle(fontSize: 13.0, color: Colors.blue)),
          Text('$_libelleStatus',
              style: TextStyle(fontSize: 10.0, color: Colors.green)),
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
