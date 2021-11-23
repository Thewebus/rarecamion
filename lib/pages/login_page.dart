import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscuredText = true;
  String _email, _password;
  Widget _showTitle() {
    return Text('Login', style: Theme.of(context).textTheme.headline1);
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
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
        padding: EdgeInsets.only(top: 20.0),
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
        padding: EdgeInsets.only(top: 20.0),
        child: Column(children: [
          RaisedButton(
              child: Text('Connexion',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white)),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: Theme.of(context).primaryColor,
              onPressed: _submit),
          FlatButton(
              child: Text('Pas de compte ? Faire la demande'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/register'))
        ]));
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Email: $_email, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RARE CAMION'),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.2],
                    colors: const [Colors.blue, Colors.white])),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    _showTitle(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    _showFormActions(),
                  ])),
            ))));
  }
}
