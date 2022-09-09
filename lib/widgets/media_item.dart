// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:rarecamion/models/status_image.dart' as si;
import 'package:http/http.dart' as http;

class MediaItem extends StatefulWidget {
  final si.Datum media;
  const MediaItem({Key key, this.media}) : super(key: key);

  @override
  MediaItemState createState() => MediaItemState();
}

class MediaItemState extends State<MediaItem> {
  void _deletePhotoStatusVehicule(int mediaID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    String url = 'http://rarecamion.com:1337/api/upload/files/$mediaID';

    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      infoFlash = 'Impossible de supprimer !';
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

  Widget _showMedia(si.Datum media) {
    return Image.network(
      'http://rarecamion.com:1337' + media.attributes.url,
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

  Widget _showImage(si.Datum photo) {
    return Image.network(
      'http://rarecamion.com:1337' + photo.attributes.url,
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

  Widget _showVideo(si.Datum video) {
    return Image.network(
      'http://rarecamion.com:1337' + video.attributes.url,
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
    return Card(
      color: Colors.blue.shade800,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _showImage(widget.media),
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
                        content: const Text('Voulez-vous supprimer la photo ?'),
                        textOK: const Text('Oui, supprimer !'),
                        textCancel: const Text('Non'),
                      )) {
                        return _deletePhotoStatusVehicule(widget.media.id);
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
