import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddVehiculePage extends StatefulWidget {
  final void Function() onInit;
  AddVehiculePage({this.onInit});

  @override
  AddVehiculePageState createState() => AddVehiculePageState();
}

class AddVehiculePageState extends State<AddVehiculePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting, _obscuredText = true;
  String _username, _email, _password;
  String dropdownValue = 'One';

  String _matricule, _typeproduit, _dechargement;

  Widget _showLogo() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logorarecamion.png'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ));
  }

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

  Widget _showTypeProduitInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _typeproduit = val,
            validator: (val) =>
                val.isEmpty ? 'Entrez un type de produit !' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type de produit',
                hintText: 'Entrez le type de produit',
                icon: Icon(Icons.add_business_outlined, color: Colors.grey))));
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    )

              
    );
  }

  Widget _showFormActions() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor))
              : RaisedButton(
                  onPressed: _submit,
                  child: Text('Procéder à l\'enregistrement du Véhicule'),
                ),
          FlatButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/records'),
              child: Text('Voir tous les enregistrements'))
        ]));
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() => _isSubmitting = true);
    http.Response response = await http.post(
        Uri.parse('http://rarecamion.com:1337/api/auth/local/register'),
        body: {"username": _username, "email": _email, "password": _password});

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() => _isSubmitting = false);
      //final String errorMsg = responseData['message'];

      //Map<String, dynamic> errorMsg = responseData['message'];
      final String errorMsg = 'Impossible d\'enregistrer le véhicule !';
      _showErrorSnack(errorMsg);
    }
  }

  void storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
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
      Navigator.pushReplacementNamed(context, '/records');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('RARE CAMION'),
        ),
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
              child: Form(
                  key: _formKey,
                  child: Column(
                      /*crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,*/
                      children: [
                        _showTitle(),
                        _showMatriculeInput(),
                        _showTypeProduitInput(),
                        _showPasswordInput(),
                        _showFormActions(),
                      ])),
            ))));
  }
}
