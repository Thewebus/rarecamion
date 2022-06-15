import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/fournisseur.dart';
import 'package:rarecamion/redux/actions.dart';
import 'dart:convert';

class AddVehiculePage extends StatefulWidget {
  final void Function() onInit;
  AddVehiculePage({this.onInit});

  @override
  AddVehiculePageState createState() => AddVehiculePageState();
}

class AddVehiculePageState extends State<AddVehiculePage> {
  @override
  initState() {
    super.initState();

    _getFournisseurs().then((value) {
      setState(() {
        populatedFournisseurs.addAll(value);
        populatedFournisseurs.forEach((f) {
          fournisseursNamed.add(f.attributes.nomFournisseur);
        });
        _dropFournisseur = fournisseursNamed[0];
      });

      print(populatedFournisseurs.length);
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final List<Fournisseur> populatedFournisseurs = [];

  final List<String> fournisseursNamed = [];

  // ignore: unused_field
  bool _isSubmitting, _obscuredText = true;

  String _matricule;
  String _typeproduit = 'HEVEA';
  String _dropDechargement = 'CAMION';
  String _dropFournisseur = '';
  String _dropEtatProduit = 'BON';
  String _dropUsine = 'IRA';

  Widget _showTitle() {
    return Text('Enregistrer un véhicule',
        style: Theme.of(context).textTheme.headline1);
  }

  Widget _showMatriculeInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _matricule = val,
            validator: (val) =>
                val.isEmpty ? 'Entrez le numéro matricule !' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Matricule',
                hintText: 'Entrer le Matricule ',
                icon: Icon(Icons.article_outlined, color: Colors.grey))));
  }

  Widget _showFournisseursInput() {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Traitant / Fournisseur:',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: DropdownButton<String>(
                    //isExpanded: true,
                    value: _dropFournisseur,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _dropFournisseur = newValue;
                      });
                    },

                    ///TODO: Fetch datas from STRAPI API ...
                    ////*
                    ///https://stackoverflow.com/questions/68651197/flutter-fill-dropdownmenuitem-from-list
                    ///*/
                    items: fournisseursNamed
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  )),
            ],
          );
        });
  }

  Widget _showDechargementInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Déchargement:',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: DropdownButton<String>(
              //isExpanded: true,
              value: _dropDechargement,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _dropDechargement = newValue;
                });
              },
              items: <String>['CAMION', 'BENNE', 'REMORQUE', 'TRICYCLE', 'KIA']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _showEtatProduitInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'État du produit:',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: DropdownButton<String>(
              value: _dropEtatProduit,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _dropEtatProduit = newValue;
                });
              },
              items: <String>['BON', 'MOYEN', 'MAUVAIS']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _showUsineInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Usine:',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: DropdownButton<String>(
              value: _dropUsine,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _dropUsine = newValue;
                });
              },
              items: <String>['IRA', 'DOKOUE']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _showFormActions(int _userID) {
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
                      _addVehiculeProcess(_userID);
                    }
                  },
                  child: Text('ENREGISTRER VEHICULE'),
                ),
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/vehicules'),
              child: Text('Voir tous les enregistrements'))
        ]));
  }

  void _addVehiculeProcess(int _userID) async {
    setState(() => _isSubmitting = true);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    http.Response response =
        await http.post(Uri.parse('http://rarecamion.com:1337/api/vehicules'),
            headers: headers,
            body: jsonEncode({
              "data": {
                "matricule": _matricule,
                "dechargement": _dropDechargement,
                "typeProduit": _typeproduit,
                "etatProduit": _dropEtatProduit,
                "usineVehicule": _dropUsine,
                "fournisseur": _dropFournisseur,
                "user": _userID
              }
            }));

    //final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _showSuccessSnack();
      _redirectUser();
    } else {
      setState(() => _isSubmitting = false);
      //final String errorMsg = responseData['message'];

      //Map<String, dynamic> errorMsg = responseData['message'];
      _showErrorSnack();
    }
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text(
            'Le véhicule mat: $_matricule a été enregistré avec succès !',
            style: TextStyle(color: Colors.green)),
        duration: Duration(milliseconds: 2000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack() {
    final snackbar = SnackBar(
        content: Text('Impossible d\'enregistrer le véhicule !',
            style: TextStyle(color: Colors.red)),
        duration: Duration(milliseconds: 3000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //throw Exception('Erreur : $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/vehicules');
    });
  }

  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return AppBar(
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.close_outlined),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/vehicules');
                    }),
                title: SizedBox(
                    child: state.user != null
                        ? Text(state.user.username)
                        : Text('')),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: StoreConnector<AppState, VoidCallback>(
                          converter: (store) {
                        return () => store.dispatch(logoutUserAction);
                      }, builder: (_, callback) {
                        return state.user != null
                            ? IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: callback)
                            : Text('');
                      }))
                ]);
          }));

  Future<List<Fournisseur>> _getFournisseurs() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    String url =
        'http://rarecamion.com:1337/api/fournisseurs?pagination[limit]=100';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    final List<Fournisseur> fournisseurs = [];

    if (response.statusCode != 200) {
      print('Failed to load Fournisseurs !');
    } else {
      final responseData = json.decode(response.body);

      Map<String, dynamic> fournisseursStrapiJson =
          new Map<String, dynamic>.from(responseData);

      final fournisseursJson = fournisseursStrapiJson['data'];

      fournisseursJson.forEach((fournisseur) {
        final Fournisseur f = Fournisseur.fromJson(fournisseur);
        fournisseurs.add(f);
      });
    }
    return fournisseurs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              return state.user != null
                  ? Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [
                            0.1,
                            0.2
                          ],
                              colors: const [
                            Colors.lightBlueAccent,
                            Colors.white
                          ])),
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Center(
                          child: SingleChildScrollView(
                        child: Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _showTitle(),
                                  _showMatriculeInput(),
                                  _showFournisseursInput(),
                                  _showDechargementInput(),
                                  _showEtatProduitInput(),
                                  _showUsineInput(),
                                  _showFormActions(state.user.id),
                                  SizedBox(height: 150)
                                ])),
                      )))
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                          'Impossible de récuperer les données de l\'utilisateur'),
                    );
            }));
  }
}
