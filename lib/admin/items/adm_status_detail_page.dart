import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/admin/items/media_item.dart';
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

    _checkImagesAndVideos().then((value) {
      setState(() {
        _allmedias.addAll(value);
      });
      print(_allmedias);
    });
  }

  String infoFlash = '';

  final List<si.Datum> _allmedias = [];

  //int _imgcounter = 0;

  Future<List<si.Datum>> _checkImagesAndVideos() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    bool _containsPics = false;
    bool _containsMovs = false;

    String statusRelatedID = widget.statusvehicule.id.toString();

    String url =
        'http://api.rarecamion.com/api/status-vehicules/$statusRelatedID?populate[0]=Image,Video';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    //print(response.body);

    final List<si.Datum> mediaList = [];

    if (response.statusCode != 200) {
      setState(() {
        infoFlash = "Impossible de charger les status ... ré-essayez svp !";
      });
      if (kDebugMode) {
        print('Failed to load STATUS !');
      }
    } else {
      si.StatusImage jsonStrapi = si.StatusImage.fromRawJson(response.body);

      List<si.Datum> imagesList = jsonStrapi.data.attributes.image.data;

      List<si.Datum> videosList = jsonStrapi.data.attributes.video.data;

      //print(imagesList);

      if (imagesList != null) {
        imagesList.forEach((datum) {
          si.Datum d = datum;
          mediaList.add(d);
          //print(d.attributes.url);
        });
        _containsPics = true;
      }

      if (videosList != null) {
        videosList.forEach((datum) {
          si.Datum d = datum;
          mediaList.add(d);
          //print(d.attributes.url);
        });
        _containsMovs = true;
      }

      if (_containsPics && _containsMovs) {
        setState(() {
          infoFlash = 'Affichage des images et videos !';
        });
      } else if (_containsPics == true && _containsMovs == false) {
        setState(() {
          infoFlash = 'Affichage des photos (aucune vidéo trouvée) !';
        });
      } else if (_containsPics == false && _containsMovs == true) {
        setState(() {
          infoFlash = 'Affichage des vidéos (aucune photo trouvée) !';
        });
      } else if (_containsPics == false && _containsMovs == false) {
        setState(() {
          infoFlash = 'Aucun media trouvé pour ce status !';
        });
      }
    }

    return mediaList;
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
                      return MediaItem(mediaItem: _allmedias[i]);
                    },
                    itemCount: _allmedias.length,
                  ),
                ),
              ],
            )));
  }
}
