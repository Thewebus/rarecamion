import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rarecamion/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting, _obscuredText = true;
  String _email, _password;

  Widget _showLogo() {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logoRCManager_withtypo_white.png'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ));
  }

  Widget _showTitle() {
    return Text('Connexion', style: Theme.of(context).textTheme.headline1);
  }

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
                hintText: 'Entrez votre mot de passe',
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
                  child: Text('Connexion',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white)),
                  onPressed: _submit),
          SizedBox(
            height: 5,
          ),
          Text(
            'Pas de compte ? Contactez la Direction !',
            style: TextStyle(fontSize: 12),
          )
        ]));
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginUser();
    }
  }

  void _redirectUser() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/vehicules');
    });
  }

  void _redirectAdmin() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/adminHome');
    });
  }

  void _loginUser() async {
    bool _errorValue = false;

    setState(() => _isSubmitting = true);
    http.Response response = await http.post(
        Uri.parse('http://rarecamion.com:1337/api/auth/local'),
        body: {"identifier": _email, "password": _password});

    if (response.statusCode == 200) {
      final rBody = json.decode(response.body);

      Map<String, dynamic> userStrapiJson =
          new Map<String, dynamic>.from(rBody);

      final userJson = userStrapiJson['user'];

      final User usr = User.fromJson(userJson);

      if (usr.confirmed != true) _errorValue = true;
      if (usr.blocked == true) _errorValue = true;

      if (_errorValue == true) {
        setState(() => _isSubmitting = false);
        final String errorMsg =
            'Contactez la Direction, pour vos autorisations !';
        _showErrorSnack(errorMsg);
      } else {
        _storeUserData(rBody);
        setState(() => _isSubmitting = false);
        _showSuccessSnack();

        if (usr.status == 'administration') {
          _redirectAdmin();
        } else {
          _redirectUser();
        }
      }
    } else {
      setState(() => _isSubmitting = false);
      final String errorMsg =
          'Identifiants incorrects : ${response.statusCode}';
      _showErrorSnack(errorMsg);
    }
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text(
          'Utilisateur connecté avec succès !',
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2));
    //_scaffoldKey.currentState.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
        content: Text(
          errorMsg,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Center(
                child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _showLogo(),
                        _showTitle(),
                        _showEmailInput(),
                        _showPasswordInput(),
                        _showFormActions(),
                      ])),
            ))));
  }
}
