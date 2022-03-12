import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/engines/app_state.dart';
import 'package:rarecamion/models/vehicule.dart';
import 'package:rarecamion/redux/actions.dart';
import 'dart:convert';

class AddStatusPage extends StatefulWidget {
  final Vehicule vehicule;
  AddStatusPage({this.vehicule});

  @override
  AddStatusPageState createState() => AddStatusPageState();
}

class AddStatusPageState extends State<AddStatusPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  bool _isSubmitting, _obscuredText = true;

  String _observationsStatus;

  String _statusVehicule = 'EN RANG';

  Widget _showTitle() {
    return Text('Ajout status à  ${widget.vehicule.attributes.matricule}',
        style: Theme.of(context).textTheme.headline1);
  }

  Widget _showObservationsStatus() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _observationsStatus = val,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Observations ...',
              hintText: 'Entrez vos remarques ici ...',
            )));
  }

  Widget _addStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Sélectionnez le status:',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: DropdownButton<String>(
              value: _statusVehicule,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _statusVehicule = newValue;
                });
              },
              items: <String>[
                'EN RANG',
                'EN PENTE',
                'A LA PESEE',
                'REFOULE',
                'ANNULE'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _showFormActions(int _idVehiculeRelated) {
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
                      _addVehiculeProcess(_idVehiculeRelated);
                    }
                  },
                  child: Text('Entrez le status actuel du Véhicule'),
                ),
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/vehicules'),
              child: Text('Aller à vos enregistrements'))
        ]));
  }

  void _addVehiculeProcess(int _idVehiculeRelated) async {
    setState(() => _isSubmitting = true);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    http.Response response = await http.post(
        Uri.parse('http://rarecamion.com:1337/api/status-vehicules'),
        headers: headers,
        body: jsonEncode({
          "data": {
            "libelleStatus": _statusVehicule,
            "observationStatus": _observationsStatus,
            "vehicule_related": _idVehiculeRelated
          }
        }));

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() => _isSubmitting = false);
      //final String errorMsg = responseData['message'];

      //Map<String, dynamic> errorMsg = responseData['message'];
      final String errorMsg = 'Impossible d\'enregistrer le status !';
      _showErrorSnack(errorMsg);
    }
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text('Status enregistré avec succès !',
            style: TextStyle(color: Colors.green)),
        duration: Duration(milliseconds: 3000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
        content: Text(errorMsg, style: TextStyle(color: Colors.red)),
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
                title: SizedBox(
                    child: state.user != null
                        ? Text(state.user.username)
                        : Text('')),
                leading:
                    // state.user != null ? Icon(Icons.account_box) : Text(''),
                    state.user != null ? Text('') : Text(''),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
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
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _showTitle(),
                        Text(''),
                        _addStatus(),
                        Text(''),
                        _showObservationsStatus(),
                        Text(''),
                        _showFormActions(widget.vehicule.id),
                        Text(''),
                      ])),
            ))));
  }
}
