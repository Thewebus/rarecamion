import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/vehicule.dart';
import '../models/status_vehicule.dart';
import 'package:rarecamion/widgets/status_item.dart';

class VehiculeDetailsPage extends StatefulWidget {
  final Vehicule vehicule;

  const VehiculeDetailsPage({Key key, this.vehicule}) : super(key: key);

  @override
  VehiculeDetailsPageState createState() => VehiculeDetailsPageState();
}

class VehiculeDetailsPageState extends State<VehiculeDetailsPage> {
  @override
  initState() {
    super.initState();

    _fetchStatus().then((value) {
      setState(() {
        _allStatus.addAll(value);
      });
    });
  }

  String infoFlash = '';

  final List<StatusVehicule> _allStatus = [];

  Future<List<StatusVehicule>> _fetchStatus() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String vehiculeRelatedID = widget.vehicule.id.toString();

    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$vehiculeRelatedID';

    //print(url);

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    Map<String, dynamic> statusDatasRAW =
        new Map<String, dynamic>.from(json.decode(response.body));

    final statusDatas = statusDatasRAW['data'];

    final List<StatusVehicule> allStatus = [];

    print(statusDatas);

    if (response.statusCode != 200) {
      throw Exception('Failed to load VEHICULES !');
    } else {
      if (statusDatas != null) {
        setState(() {
          infoFlash = 'Tous les status ... ';
        });

        statusDatas.forEach((statusData) {
          final StatusVehicule status = StatusVehicule.fromJson(statusData);
          allStatus.add(status);
        });
      } else {
        setState(() {
          infoFlash = ' Aucun status défini pour ce véhicule !';
        });
      }
    }

    return allStatus;
  }

  Widget _showVDetails(String libelle, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text('$libelle',
              style: TextStyle(fontSize: 12, color: Colors.black)),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text('$value',
                style: TextStyle(fontSize: 13, color: Colors.blue))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.vehicule.attributes.dechargement)),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  child: Column(children: [
                    _showVDetails('Fournisseur',
                        '${widget.vehicule.attributes.fournisseur}'),
                    _showVDetails(
                        'Matricule', '${widget.vehicule.attributes.matricule}'),
                    _showVDetails(
                        'Produit', '${widget.vehicule.attributes.etatProduit}'),
                    _showVDetails(
                        'Usine', '${widget.vehicule.attributes.usineVehicule}'),
                    _showVDetails('Type produit',
                        '${widget.vehicule.attributes.typeProduit}'),
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  '$infoFlash',
                  style: TextStyle(
                      color: Color.fromARGB(255, 8, 8, 8),
                      fontSize: 11,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 10),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return StatusItem(statusVehicule: _allStatus[i]);
                    },
                    itemCount: _allStatus.length,
                  ),
                ),
              ],
            ))));
  }
}
