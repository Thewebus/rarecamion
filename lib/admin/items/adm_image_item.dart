// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rarecamion/models/status_image.dart' as si;

class ImageItem extends StatefulWidget {
  final si.Datum image;
  const ImageItem({Key key, this.image}) : super(key: key);

  @override
  ImageItemState createState() => ImageItemState();
}

class ImageItemState extends State<ImageItem> {
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
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _showImage(widget.image),
          ],
        ),
      ),
    );
  }
}
