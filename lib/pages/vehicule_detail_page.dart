import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';

class RecordingDetailPage extends StatelessWidget {
  final Vehicule item;
  RecordingDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
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

    final String pictureUrl =
        'http://rarecamion.com:1337/uploads/thumbnail_607_4251640570155_2d1bab0376.jpg';
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(title: Text(item.attributes.matricule)),
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
                    /*Image.network(pictureUrl, fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
            return progress == null ? child : LinearProgressIndicator();
              }),*/
                    _showVDetails(
                        'Fournisseur', '${item.attributes.fournisseur}'),
                    _showVDetails(
                        'Déchargement', '${item.attributes.dechargement}'),
                    _showVDetails('Produit', '${item.attributes.etatProduit}'),
                    _showVDetails('Usine', '${item.attributes.usineVehicule}'),
                    _showVDetails(
                        'Type produit', '${item.attributes.typeProduit}'),
                    //SizedBox(height: 10),
                    // Text('All status ...'),

                    //List below all status details recordered by this related vehicule ...

                    //SizedBox(height: 500),

                    /*Image.network(pictureUrl,
              width: orientation == Orientation.portrait ? 300 : 100,
              height: orientation == Orientation.portrait ? 250 : 200,
              fit: BoxFit.contain),*/
                  ]),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('EN ATTENTE',
                          style: TextStyle(
                              fontSize: 19,
                              color: Color.fromARGB(255, 255, 255, 255))),
                      Text('07/02/2022',
                          style: TextStyle(
                              fontSize: 11.0,
                              color: Color.fromARGB(255, 255, 255, 255))),
                      Text('EDITION',
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Color.fromARGB(255, 35, 250, 53))),
                    ],
                  ),
                ),
              ],
            ))));
  }
}
