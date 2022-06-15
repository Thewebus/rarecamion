import 'package:flutter/material.dart';
import 'package:rarecamion/engines/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rarecamion/widgets/fournisseur_item.dart';
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
  //
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

    //final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _showSuccessSnack();
      // _redirectUser();
    } else {
      setState(() => _isSubmitting = false);
      //final String errorMsg = responseData['message'];

      //Map<String, dynamic> errorMsg = responseData['message'];
      _showErrorSnack();
    }
  }

  //
  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text(
            'Le Fournisseur mat: $_nomFournisseur a été enregistré avec succès !',
            style: TextStyle(color: Colors.green)),
        duration: Duration(milliseconds: 2000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack() {
    final snackbar = SnackBar(
        content: Text('Impossible d\'enregistrer le Fournisseur !',
            style: TextStyle(color: Colors.red)),
        duration: Duration(milliseconds: 3000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //throw Exception('Erreur : $errorMsg');
  }

  //

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
                  child: Text('ENREGISTRER'),
                ),
        ]));
  }

  //
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
                                    SizedBox(height: 5),
                                    Container(
                                      height: 365,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: state.fournisseurs.length,
                                          itemBuilder: (context, i) =>
                                              FournisseursItem(
                                                fournisseur:
                                                    state.fournisseurs[i],
                                              ),
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider()),
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
        mini: true,
        backgroundColor: Colors.red,
        onPressed: () => _onAlertWithCustomContentPressed(context),
        tooltip: 'Ajouter nouveau Fournisseur ...',
        child: Icon(Icons.add),
      ),
    );
  }
}
