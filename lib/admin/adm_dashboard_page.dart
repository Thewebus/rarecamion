import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/admin/items/adm_vehicule_item.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:search_page/search_page.dart';

class RecordingsPage extends StatefulWidget {
  RecordingsPage({Key key}) : super(key: key);

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  //
  static List<Vehicule> vehiculesAll = [];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.1, 0.2],
                  colors: const [Colors.lightBlueAccent, Colors.white])),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                vehiculesAll.addAll(state.vehiculesAll);
                // print(vehiculesAll);

                return state.vehiculesAll == null
                    ? Center(
                        child: Text('Vérifiez votre connexion !'),
                      )
                    : Row(children: [
                        Expanded(
                          child: SafeArea(
                              top: false,
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text('TABLEAU DE BORD',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    SizedBox(height: 20),
                                    Container(
<<<<<<< HEAD
                                      height: 390,
=======
                                      height: 400,
>>>>>>> dd46a8cc5375ff48dd8aa255934f2f76af98ba6e
                                      child: ListView.separated(
                                        itemCount: state.vehiculesAll.length,
                                        itemBuilder: (context, i) =>
                                            VehiculeItem(
                                          vehicule: state.vehiculesAll[i],
                                        ),
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ]);
              })),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tapez votre recherche ...',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Vehicule>(
            onQueryUpdate: (s) => print(s),
            items: vehiculesAll,
            searchLabel: 'Recherche ...',
            suggestion: Center(
              child: Text('Rechercher par fournisseur, lieu ou date.'),
            ),
            failure: Center(
              child: Text('Rien trouvé :( !'),
            ),
            filter: (vehicule) => [
              vehicule.attributes.matricule,
              vehicule.attributes.fournisseur,
              vehicule.attributes.updatedAt.toString(),
            ],
            builder: (vehicule) => ListTile(
              title: Text(vehicule.attributes.matricule),
              subtitle: Text(vehicule.attributes.fournisseur),
              trailing: Text(''),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }
}
