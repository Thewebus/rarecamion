// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class ImageItem extends StatefulWidget {
  final String imageURL;
  const ImageItem({Key key, this.imageURL}) : super(key: key);

  @override
  ImageItemState createState() => ImageItemState();
}

class ImageItemState extends State<ImageItem> {
  String serverURL = 'http://rarecamion.com:1337';
  Widget _showImage(String url) {
    return Image.network(
      url,
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
              _showImage(serverURL + widget.imageURL),
            ],
          ),
        ),
      ),
    );
  }
}
