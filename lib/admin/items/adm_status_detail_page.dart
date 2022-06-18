import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/admin/items/adm_image_item.dart';
import 'package:rarecamion/models/status_image.dart' as si;
import 'package:rarecamion/models/status_vehicule.dart';

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

  String infoFlash = '';

  final List<si.Datum> _allImages = [];

  int _imgcounter = 0;

  Future<List<si.Datum>> _fetchImages() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String statusRelatedID = widget.statusvehicule.id.toString();

    String url =
        'http://rarecamion.com:1337/api/status-vehicules/$statusRelatedID?populate[0]=Image';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    //print(response.body);

    final List<si.Datum> imagesListList = [];

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('Failed to load STATUS !');
      }
    } else {
      si.StatusImage jsonStrapi = si.StatusImage.fromRawJson(response.body);

      List<si.Datum> imagesList = jsonStrapi.data.attributes.image.data;

      if (imagesList != null) {
        _imgcounter = imagesList.length;
        setState(() {
          infoFlash = 'Affichage des medias liés à ce status ...';
        });
        imagesList.forEach((datum) {
          si.Datum d = datum;
          imagesListList.add(d);
          print(d.attributes.url);
        });
      } else {
        setState(() {
          infoFlash = 'Aucun media lié à ce status !';
        });
      }
    }

    return imagesListList;
  }

  Widget _showTopStatusInfos(String libelle, String value) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(libelle,
                style: const TextStyle(fontSize: 12, color: Colors.black)),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: Text(value,
                  style: const TextStyle(fontSize: 13, color: Colors.blue))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                widget.statusvehicule.attributes.libelleStatus.toUpperCase())),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: 400,
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _showTopStatusInfos(
                            'Etat de modification',
                            widget.statusvehicule.attributes.statusEdition
                                .toUpperCase()),
                        _showTopStatusInfos('Observations',
                            widget.statusvehicule.attributes.observationStatus),
                      ]),
                ),
                const SizedBox(height: 10),
                Text(
                  infoFlash,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return ImageItem(image: _allImages[i]);
                    },
                    itemCount: _allImages.length,
                  ),
                ),
              ],
            )));
  }
}
