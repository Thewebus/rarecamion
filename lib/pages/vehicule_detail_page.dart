import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/vehicule.dart';
import '../models/status_vehicule.dart';
import 'package:date_format/date_format.dart';

class VehiculeDetailsPage extends StatefulWidget {
  final Vehicule vehicule;

  const VehiculeDetailsPage({Key key, this.vehicule}) : super(key: key);

  @override
  VehiculeDetailsPageState createState() => VehiculeDetailsPageState();
}

class VehiculeDetailsPageState extends State<VehiculeDetailsPage> {
  final List<StatusVehicule> _allStatus = [];

  Future<List<StatusVehicule>> _fetchStatus() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String vehiculeRelatedID = widget.vehicule.id.toString();

    String url =
        'http://rarecamion.com:1337/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$vehiculeRelatedID';

    print(url);

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    Map<String, dynamic> statusDatasRAW =
        new Map<String, dynamic>.from(json.decode(response.body));

    final statusDatas = statusDatasRAW['data'];

    final List<StatusVehicule> allStatus = [];

    statusDatas.forEach((statusData) {
      final StatusVehicule status = StatusVehicule.fromJson(statusData);
      allStatus.add(status);
    });

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
  initState() {
    super.initState();

    _fetchStatus().then((value) {
      setState(() {
        this._allStatus.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.vehicule.attributes.matricule)),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: 130,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
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
                    _showVDetails('Déchargement',
                        '${widget.vehicule.attributes.dechargement}'),
                    _showVDetails(
                        'Produit', '${widget.vehicule.attributes.etatProduit}'),
                    _showVDetails(
                        'Usine', '${widget.vehicule.attributes.usineVehicule}'),
                    _showVDetails('Type produit',
                        '${widget.vehicule.attributes.typeProduit}'),
                  ]),
                ),
                SizedBox(height: 10),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return StatusCard(statusVehicule: _allStatus[i]);
                    },
                    itemCount: _allStatus.length,
                  ),
                ),
              ],
            ))));
  }
}

class StatusCard extends StatelessWidget {
  final StatusVehicule statusVehicule;
  const StatusCard({Key key, this.statusVehicule}) : super(key: key);

  String dtformat(DateTime d) {
    return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn, ':', ss]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${this.statusVehicule.attributes.libelleStatus}',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 255, 255, 255))),
              Text('${dtformat(this.statusVehicule.attributes.updatedAt)}',
                  style: TextStyle(
                      fontSize: 9.0,
                      color: Color.fromARGB(255, 255, 255, 255))),
              Text('${this.statusVehicule.attributes.statusEdition}',
                  style: TextStyle(
                      fontSize: 9.0, color: Color.fromARGB(255, 35, 250, 53))),
            ]),
      ),
    );
  }
}
