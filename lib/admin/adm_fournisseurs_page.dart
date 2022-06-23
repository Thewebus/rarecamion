import 'package:flutter/material.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FournisseursPage extends StatefulWidget {
  FournisseursPage({Key key}) : super(key: key);

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  //
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  //
  String _nomFournisseur;
  bool _isSubmitting, _obscuredText = true;

  //
  Future<bool> _deleteFournisseur(int _fID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    bool _return = false;
    String url = 'http://rarecamion.com:1337/api/fournisseurs/$_fID';

    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      infoFlash = 'Impossible de supprimer le fournisseur !';
      _showErrorSnackText(infoFlash);
    } else {
      infoFlash = 'Suppression effectuée avec succès !';
      _showSuccessSnackText(infoFlash);
      _return = true;
    }

    return _return;
  }

  void _addFournisseurProcess() async {
    setState(() => _isSubmitting = true);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    http.Response response = await http.post(
        Uri.parse('http://rarecamion.com:1337/api/fournisseurs'),
        headers: headers,
        body: jsonEncode({
          "data": {"nomFournisseur": _nomFournisseur}
        }));

    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _showSuccessSnackText(' Fournisseur enregistré avec succès !');
    } else {
      setState(() => _isSubmitting = false);
      _showErrorSnackText('Impossible d\'enregistrer le Fournisseur !');
    }
    _redirectUser();
  }

  void _showSuccessSnackText(String _text) {
    final snackbar = SnackBar(
        content: Text('$_text', style: TextStyle(color: Colors.green)),
        duration: Duration(seconds: 3));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _showErrorSnackText(String _text) {
    final snackbar = SnackBar(
        content: Text('$_text', style: TextStyle(color: Colors.red)),
        duration: Duration(seconds: 5));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _redirectUser() {
    setState(() => null);
    Navigator.pushReplacementNamed(context, '/adminHome');
  }

  Widget _showFournisseurInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _nomFournisseur = val,
            validator: (val) => val.isEmpty ? 'Entrez le fournisseur !' : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nom du Fournisseur',
              hintText: 'Entrer le fournisseur ',
            )));
  }

  Widget _showFormActions() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor))
              : ElevatedButton(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      _addFournisseurProcess();
                    }
                  },
                  child: Text('ENREGISTRER FOURNISSEUR'),
                ),
        ]));
  }

  // Alert custom content
  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "Ajouter",
        content: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _showFournisseurInput(),
                      _showFormActions(),
                    ])),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    // bool _isLoggedIn = true;
    return Scaffold(
      key: _scaffoldKey,
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
                                    SizedBox(height: 20),
                                    Container(
<<<<<<< HEAD
                                      height: 390,
=======
                                      height: 400,
>>>>>>> dd46a8cc5375ff48dd8aa255934f2f76af98ba6e
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: state.fournisseurs.length,
                                        itemBuilder: (context, i) {
                                          return Dismissible(
                                            key: UniqueKey(),

                                            // only allows the user swipe from right to left
                                            direction:
                                                DismissDirection.endToStart,

                                            // Remove this product from the list
                                            // In production enviroment, you may want to send some request to delete it on server side
                                            onDismissed: (_) async {
                                              setState(() {
                                                if (_deleteFournisseur(state
                                                        .fournisseurs[i].id) !=
                                                    false)
                                                  state.fournisseurs
                                                      .removeAt(i);
                                              });
                                              return null;
                                            },
                                            child: ListTile(
                                                onTap: () => () {},
                                                tileColor: Colors.blueAccent,
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.handshake_outlined,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                    Text(
                                                        '${state.fournisseurs[i].attributes.nomFournisseur}',
                                                        style: TextStyle(
                                                            fontSize: 14.0)),
                                                  ],
                                                ),
                                                subtitle: Text(
                                                    'Supprimer: glisser à gauche ...'),
                                                trailing: IconButton(
                                                  onPressed: () => () {},
                                                  iconSize: 25,
                                                  icon: Icon(Icons.arrow_back),
                                                  color: Colors.red,
                                                )),
                                            background: Container(
                                              color: Colors.red,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              alignment: Alignment.centerRight,
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      ),
                                    ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _onAlertWithCustomContentPressed(context),
        tooltip: 'Ajouter Fournisseur ...',
        child: Icon(Icons.add),
      ),
    );
  }
}
