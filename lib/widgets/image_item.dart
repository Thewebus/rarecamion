// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rarecamion/models/status_image.dart' as si;

class ImageItem extends StatefulWidget {
  final si.Datum photos;
  const ImageItem({Key key, this.photos}) : super(key: key);

  @override
  ImageItemState createState() => ImageItemState();
}

class ImageItemState extends State<ImageItem> {
  /* Future<List<String>> _deletePhotoStatusVehicule() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String photoID = widget.statusvehicule.id.toString();

    String url =
        'http://rarecamion.com:1337/api/status-vehicules/$photoID?populate[0]=Image';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    //print(response.body);

    final List<String> imagesURL = [];

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('Failed to load STATUS !');
      }
    } else {
      si.StatusImage jsonStrapi = si.StatusImage.fromRawJson(response.body);

      List<si.Datum> photos = jsonStrapi.data.attributes.image.data;

      if (photos != null) {
        setState(() {
          infoFlash = 'Affichage des photos et videos ...';
        });
        photos.forEach((datum) {
          si.Datum d = datum;
          imagesURL.add(d.attributes.url);
          print(d.attributes.url);
        });
      } else {
        setState(() {
          infoFlash = 'Aucun media pour ce status ...';
        });
      }
    }

    return imagesURL;
  } */
  Widget _showImage(si.Datum photo) {
    return Image.network(
      'http://rarecamion.com:1337' + photo.attributes.url,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print('');
      },
      onDoubleTap: () {
        print('');
      },
      child: Card(
        color: Colors.blue.shade800,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _showImage(widget.photos),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Text('');
                      },
                      child: Row(
                        children: [
                          Text(
                            'SUPPRIMER',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
