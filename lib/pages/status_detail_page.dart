import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/status_image.dart';
import '../models/status_vehicule.dart';

class StatusDetailPage extends StatefulWidget {
  final StatusVehicule statusvehicule;

  const StatusDetailPage({Key key, this.statusvehicule}) : super(key: key);

  @override
  StatusDetailPageState createState() => StatusDetailPageState();
}

class StatusDetailPageState extends State<StatusDetailPage> {
  @override
  initState() {
    super.initState();

    _fetchImages().then((value) {
      setState(() {
        _allImages.addAll(value);
      });
    });
  }

  final List<StatusImage> _allImages = [];

  String infoFlash = 'Affichage des photos ...';

  Future<List<StatusImage>> _fetchImages() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String statusRelatedID = widget.statusvehicule.id.toString();

    String url =
        'http://rarecamion.com:1337/api/status-vehicules/${statusRelatedID}?populate[0]=Image';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    Map<String, dynamic> dataRAW =
        new Map<String, dynamic>.from(json.decode(response.body));

    final statusDatas = dataRAW['data'];

    StatusImage imagesStock = StatusImage.fromJson(dataRAW);

    dynamic datums = imagesStock.data.attributes.image.data;

    final List<StatusImage> allStatus = [];

    datums.forEach((datum) {
      final DatumAttributes status = DatumAttributes.fromJson(datum);
      print(status);
      // allStatus.add(status);
    });

    return allStatus;
  }

  Widget _showTopStatusInfos(String libelle, String value) {
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
        appBar: AppBar(
            title: Text(
                widget.statusvehicule.attributes.libelleStatus.toUpperCase())),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    _showTopStatusInfos('Etat de modification',
                        '${widget.statusvehicule.attributes.statusEdition.toUpperCase()}'),
                    _showTopStatusInfos('Observations',
                        '${widget.statusvehicule.attributes.observationStatus}'),
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  '$infoFlash',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 10),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Text('');
                      //return StatusItem(statusVehicule: _allImages[i]);
                    },
                    itemCount: _allImages.length,
                  ),
                ),
              ],
            ))));
  }
}
