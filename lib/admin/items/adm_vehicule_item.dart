import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/admin/items/adm_vehicule_detail_page.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/status_vehicule.dart';
import 'package:rarecamion/models/vehiculeAll.dart';
//import 'package:dio/dio.dart';

class VehiculeItem extends StatefulWidget {
  final VehiculeAll vehicule;

  const VehiculeItem({Key key, this.vehicule}) : super(key: key);
  @override
  VehiculeItemState createState() => VehiculeItemState();
}

class VehiculeItemState extends State<VehiculeItem> {
  //
  @override
  initState() {
    super.initState();

    this._vehiculeItem = widget.vehicule;
    this._vehiculeId = widget.vehicule.id.toInt();
    this._matricule = widget.vehicule.attributes.matricule;
    this._dechargement = widget.vehicule.attributes.dechargement;
    this._fournisseur = widget.vehicule.attributes.fournisseur;

    this._timer = new Timer.periodic(const Duration(seconds: 10), (Timer t) {
      // print(t.tick);

      Future.delayed(Duration(seconds: 5), () {
        _getAllStatusByVehiculeId(_vehiculeId).then((value) {
          if (this.mounted) {
            setState(() {
              if (value != null) {
                statusV = value;
                _libelleStatus = statusV.attributes.libelleStatus;
                // print('Fournisseur: $_fournisseur, Mat.:  $_matricule !');
              }
            });
          }
        });
      });
    });

    _getAllStatusByVehiculeId(_vehiculeId).then((value) {
      setState(() {
        if (value != null) {
          statusV = value;
          _libelleStatus = statusV.attributes.libelleStatus;
        }
      });
    });
  }

  VehiculeAll _vehiculeItem;
  Timer _timer;
  StatusVehicule statusV = null;
  String _libelleStatus = 'N/A';
  int _vehiculeId;
  String _matricule, _dechargement, _fournisseur;

  Future<StatusVehicule> _getAllStatusByVehiculeId(int _id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    StatusVehicule statusV = null;

    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$_id&sort[0]=updatedAt:desc';

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> statusDatasRAW =
            Map<String, dynamic>.from(json.decode(response.body));

        final statusDatas = statusDatasRAW['data'];
        if (statusDatas.toString().length > 5) {
          statusV = StatusVehicule.fromJson(statusDatas[0]);
        }
      }
    } catch (e) {
      debugPrint("$e");
      throw "ERREUR CODE : $e !";
    }

    return statusV;
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VehiculeDetailsPage(vehicule: this._vehiculeItem);
      })),
      title: Row(
        children: [
          Icon(Icons.car_repair),
          Text('$_fournisseur',
              style: TextStyle(fontSize: 18.0, color: Colors.black)),
          // Text(' $_agentName', style: TextStyle(fontSize: 9.0)),
        ],
      ),
      subtitle: Row(
        children: [
          Text('$_matricule'.toUpperCase(),
              style: TextStyle(fontSize: 16.0, color: Colors.blue)),
          Text(' $_dechargement', style: TextStyle(fontSize: 12.0)),
          Text(' $_libelleStatus',
              style: TextStyle(fontSize: 11.0, color: Colors.green)),
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
