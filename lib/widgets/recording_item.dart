import 'package:flutter/material.dart';

class RecordingItem extends StatelessWidget {
  final dynamic item;
  RecordingItem({this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl =
        'http://rarecamion.com:1337/api/upload/files/${item['thumbnail']['url']}';
    print(pictureUrl);
    return GridTile(
        child: Image.network(
      pictureUrl,
      fit: BoxFit.cover,
    ));
  }
}
