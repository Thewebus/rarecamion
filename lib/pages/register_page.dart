import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting, _obscuredText = true;
  String _username, _email, _password;

  // String _userfirstname;

  Widget _showLogo() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logoRCManager.png'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ));
  }

  Widget _showTitle() {
    return Text('Bienvenue', style: Theme.of(context).textTheme.headline1);
  }

  Widget _showUsernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _username = val,
            validator: (val) => val.length < 4 ? 'Nom trop court' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom & Prénom(s)',
                hintText: 'Entrez vos prénoms suivis de votre nom',
                icon: Icon(Icons.face, color: Colors.grey))));
  }

/*
  Widget _showUserFirstInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _userfirstname = val,
            validator: (val) => val.length < 3 ? 'Prénom(s) trop court' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Prénom(s)',
                hintText: 'Entrez prénom(s) ',
                icon: Icon(Icons.face, color: Colors.grey))));
  }
  */

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _email = val,
            validator: (val) => !val.contains('@') ? 'Adresse invalide' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter une adresse email valide',
                icon: Icon(Icons.mail, color: Colors.grey))));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
            onSaved: (val) => _password = val,
            validator: (val) =>
                val.length < 6 ? 'Mot de passe trop court' : null,
            obscureText: _obscuredText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _obscuredText = !_obscuredText);
                    },
                    child: Icon(_obscuredText
                        ? Icons.visibility
                        : Icons.visibility_off)),
                border: OutlineInputBorder(),
                labelText: 'Mot de passe',
                hintText: 'Créer un mot de passe, 6 charactères minimum',
                icon: Icon(Icons.lock, color: Colors.grey))));
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
                  child: Text('Demande création de compte',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white, fontSize: 12)),
                  onPressed: _submit),
          TextButton(
              child: Text(
                'Deja un compte ? Connexion',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'))
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

    //  String _usernameConcat = _userfirstname + ' ' + _username;

    try {
      http.Response response = await http.post(
          Uri.parse('http://rarecamion.com:1337/api/auth/local/register'),
          body: {
            "username": "$_username",
            "email": "$_email",
            "password": "$_password"
          });

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() => _isSubmitting = false);
        storeUserData(responseData);
        _showSuccessSnack();
        _redirectUser();
      } else {
        setState(() => _isSubmitting = false);

        final String errorMsg =
            'Impossible de vous inscrire (Erreur ${response.body}).';
        _showErrorSnack(errorMsg);
      }
    } catch (e) {
      print("Erreur: $e");
      // throw "ERREUR CODE : $e !";
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
        content: Text('Utilisateur $_username enregistré avec succès !',
            style: TextStyle(color: Colors.green)),
        duration: Duration(milliseconds: 4000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
        content: Text(errorMsg, style: TextStyle(color: Colors.red)),
        duration: Duration(milliseconds: 4000));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //throw Exception('Erreur : $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _sendEmail() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('RCManager 1.0'),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.2],
                    colors: const [Colors.lightBlueAccent, Colors.white])),
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Center(
                child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      /*crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,*/
                      children: [
                        _showLogo(),
                        _showTitle(),
                        // _showUserFirstInput(),
                        _showUsernameInput(),
                        //SizedBox(height: 20),
                        _showEmailInput(),
                        // SizedBox(height: 20),
                        _showPasswordInput(),
                        _showFormActions(),
                      ])),
            ))));
  }
}
