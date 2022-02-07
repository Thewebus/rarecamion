import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';

class RecordingDetailPage extends StatelessWidget {
  final Vehicules item;
  RecordingDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    Widget _showTitle() {
      return Text('Liste des status ...',
          style: Theme.of(context).textTheme.bodyText1);
    }

    Widget _showVDetails(String libelle, String value) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Text(
              '$libelle',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 0),
              child:
                  Text('$value', style: Theme.of(context).textTheme.bodyText1)),
        ],
      );
    }

    final String pictureUrl =
        'http://rarecamion.com:1337/uploads/thumbnail_607_4251640570155_2d1bab0376.jpg';
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(title: Text(item.attributes.matricule)),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.2],
                    colors: const [Colors.lightBlueAccent, Colors.white])),
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(children: [
              /*Image.network(pictureUrl, fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                return progress == null ? child : LinearProgressIndicator();
              }),*/
              //Text('DATA: ${item.attributes}'),

              _showVDetails('Fournisseur', '${item.attributes.fournisseur}'),
              _showVDetails('Déchargement', '${item.attributes.dechargement}'),
              _showVDetails('Produit', '${item.attributes.etatProduit}'),
              _showVDetails('Usine', '${item.attributes.usineVehicule}'),
              _showVDetails('Type produit', '${item.attributes.typeProduit}'),
              //SizedBox(height: 10),
              // Text('All status ...'),
              SizedBox(height: 10),
              Placeholder(
                fallbackHeight: 1,
              ),
              //List below all status details recordered by this related vehicule ...

              Container(
                child: StoreConnector<AppState, AppState>(
                    converter: (store) => store.state,
                    builder: (_, state) {
                      return state.user != null
                          ? Text('${state.statusvehicule}')
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'Erreur chargement ..., veuillez réessayer svp !',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(height: 10),
                                  /*
                            ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/records'),
                                child: Text('Aller à l\'accueil')),
*/
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                            );
                    }),
              ),

              SizedBox(height: 500),

              /*Image.network(pictureUrl,
                  width: orientation == Orientation.portrait ? 300 : 100,
                  height: orientation == Orientation.portrait ? 250 : 200,
                  fit: BoxFit.contain),*/
            ])))));
  }
}
