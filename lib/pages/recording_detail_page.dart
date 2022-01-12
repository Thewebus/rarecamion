import 'package:flutter/material.dart';
import 'package:rarecamion/models/vehicule.dart';

class RecordingDetailPage extends StatelessWidget {
  final Vehicules item;
  RecordingDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    Widget _showTitle() {
      return Text('PHOTO', style: Theme.of(context).textTheme.headline1);
    }

    final String pictureUrl =
        'http://rarecamion.com:1337/uploads/thumbnail_607_4251640570155_2d1bab0376.jpg';
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(title: Text(item.attributes.dechargement)),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.2],
                    colors: const [Colors.lightBlueAccent, Colors.white])),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(children: [
              _showTitle(),
              Image.network(pictureUrl,
                  width: orientation == Orientation.portrait ? 300 : 100,
                  height: orientation == Orientation.portrait ? 250 : 200,
                  fit: BoxFit.contain),
              Text(item.attributes.matricule,
                  style: Theme.of(context).textTheme.headline1),
              Text('${item.attributes.publishedAt}')
            ])))));
  }
}
