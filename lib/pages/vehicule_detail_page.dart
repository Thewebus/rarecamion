import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/pages/add_status_to_vehicule.dart';
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

  // bool isSwitched = false;

  final List<StatusVehicule> _allStatus = [];

  String infoGuideDisplayed = '';

  String infoFlash = 'Chargement des status (patientez svp) ...';

  Future<List<StatusVehicule>> _fetchStatus() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String vehiculeRelatedID = widget.vehicule.id.toString();

    String url =
        'http://api.rarecamion.com/api/status-vehicules?populate=*&filters[vehicule_related][id][\$eq]=$vehiculeRelatedID&sort[0]=updatedAt:desc';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    Map<String, dynamic> statusDatasRAW =
        Map<String, dynamic>.from(json.decode(response.body));

    final statusDatas = statusDatasRAW['data'];

    final List<StatusVehicule> allStatus = [];

    if (response.statusCode != 200) {
      print('ERREUR DE CONNEXION AU SERVEUR !');
      setState(() {
        infoFlash = 'ERREUR DE CONNEXION AU SERVEUR';
      });
    } else {
      if (statusDatas.toString().length > 5) {
        setState(() {
          infoFlash = 'LISTE DES STATUS';
          infoGuideDisplayed =
              'OUVRIR: 1 clic - Capture PHOTO: 2 clics - Capture VIDEO: Maintenir 2s ';
        });

        statusDatas.forEach((statusData) {
          final StatusVehicule status = StatusVehicule.fromJson(statusData);
          allStatus.add(status);
        });
      } else {
        setState(() {
          infoFlash = 'AUCUN STATUS';
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
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  child: Column(children: [
                    _showVDetails(
                        'Fournisseur', widget.vehicule.attributes.fournisseur),
                    _showVDetails(
                        'Matricule', widget.vehicule.attributes.matricule),
                    _showVDetails(
                        'Produit', widget.vehicule.attributes.etatProduit),
                    _showVDetails(
                        'Usine', widget.vehicule.attributes.usineVehicule),
                    _showVDetails(
                        'Type produit', widget.vehicule.attributes.typeProduit),
                  ]),
                ),
                const SizedBox(height: 10),
                Text(
                  infoFlash,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  infoGuideDisplayed,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return StatusItem(statusVehicule: _allStatus[i]);
                  },
                  itemCount: _allStatus.length,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddStatusPage(vehicule: widget.vehicule);
                  })),
                  icon: Icon(Icons.add_box_outlined, size: 25),
                  label: Text("AJOUTER STATUS"),
                )
              ],
            ))));
  }
}
