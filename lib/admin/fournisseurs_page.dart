import 'package:flutter/material.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/widgets/fournisseur_item.dart';

class FournisseursPage extends StatefulWidget {
  FournisseursPage({Key key}) : super(key: key);

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  @override
  Widget build(BuildContext context) {
    // bool _isLoggedIn = true;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.1, 0.2],
                  colors: const [Colors.lightBlueAccent, Colors.white])),
          //padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (_, state) {
                return state.user != null
                    ? Row(children: [
                        Expanded(
                          child: SafeArea(
                              top: false,
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text('FOURNISSEURS',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    SizedBox(height: 5),
                                    ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: state.fournisseurs.length,
                                        itemBuilder: (context, i) =>
                                            FournisseursItem(
                                              fournisseur:
                                                  state.fournisseurs[i],
                                            ),
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider()),
                                  ],
                                ),
                              )),
                        )
                      ])
                    : Center(
                        child: Column(
                          children: [
                            Text(
                              'Vous êtes deconnecté(e) avec succès',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/login'),
                                child: Text('Aller à l\'accueil'))
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      );
              })),
    );
  }
}
