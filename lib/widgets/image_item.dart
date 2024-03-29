// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rarecamion/widgets/videoplayer_item.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:rarecamion/models/status_image.dart' as si;
import 'package:http/http.dart' as http;

class ImageItem extends StatefulWidget {
  final si.Datum image;
  const ImageItem({Key key, this.image}) : super(key: key);

  @override
  ImageItemState createState() => ImageItemState();
}

class ImageItemState extends State<ImageItem> {
  //
  //

  void _deletePhotoStatusVehicule(int imageRCID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    String url = 'http://api.rarecamion.com/api/upload/files/$imageRCID';

    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      infoFlash = 'Impossible de supprimer la photo !';
    } else {
      infoFlash = 'Suppression effectuée avec succès !';
    }
    _showSnack(infoFlash);
    setState(() {});
  }

  void _showSnack(String message) {
    final snackbar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    Navigator.of(context).pop();
  }

  Widget _showImage(si.Datum photo) {
    return Image.network(
      'http://api.rarecamion.com' + photo.attributes.url,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: LinearProgressIndicator(
            minHeight: 10,
            backgroundColor: Colors.white,
            color: Colors.blue,
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
    return widget.image.attributes.ext.toString() != '.MOV'
        ? Card(
            color: Colors.blue.shade800,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _showImage(widget.image),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (await confirm(
                              context,
                              title: const Text('Confirmez '),
                              content: const Text('Voulez-vous supprimer ?'),
                              textOK: const Text('Oui, supprimer !'),
                              textCancel: const Text('Non'),
                            )) {
                              return _deletePhotoStatusVehicule(
                                  widget.image.id);
                            } else
                              return (print('pressedCancel'));
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
          )
        : Card(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return VideoPlayerScreen(media: widget.image);
                            })),
                            child: Text(
                              'CLIQUER POUR VOIR LA VIDEO',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (await confirm(
                              context,
                              title: const Text('Confirmez '),
                              content: const Text('Voulez-vous supprimer ?'),
                              textOK: const Text('Oui, supprimer !'),
                              textCancel: const Text('Non'),
                            )) {
                              return _deletePhotoStatusVehicule(
                                  widget.image.id);
                            } else
                              return (print('pressedCancel'));
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
          );
  }
}
