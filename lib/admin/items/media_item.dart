// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rarecamion/widgets/videoplayer_item.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:rarecamion/models/status_image.dart' as si;
import 'package:http/http.dart' as http;

class MediaItem extends StatefulWidget {
  final si.Datum mediaItem;
  const MediaItem({Key key, this.mediaItem}) : super(key: key);

  @override
  MediaItemState createState() => MediaItemState();
}

class MediaItemState extends State<MediaItem> {
  //
  //

  void _deleteMediaItem(int imageRCID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    String url = 'http://rarecamion.com:1337/api/upload/files/$imageRCID';

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

  @override
  Widget build(BuildContext context) {
    String _mediaItemType = widget.mediaItem.attributes.ext;
    print(_mediaItemType);

    return _mediaItemType != '.MOV'
        ? Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _showImage(widget.mediaItem),
                ],
              ),
            ),
          )
        : Card(
            color: Colors.black,
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
                              return VideoPlayerScreen(media: widget.mediaItem);
                            })),
                            child: Text(
                              'CLIQUER POUR VOIR LA VIDEO',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
