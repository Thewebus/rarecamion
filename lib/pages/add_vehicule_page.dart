import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:rarecamion/models/app_state.dart';
import 'package:rarecamion/redux/actions.dart';
import 'dart:convert';

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
  double textSize = 13;
  String firstButtonText = 'Photo Vehicule';
  String secondButtonText = 'Record video';

  String albumName = 'Media';

  String _matricule, _typeproduit;
  String _dropDechargement = 'CAMION';
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

  Widget _showDechargementInput() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: DropdownButton<String>(
          isExpanded: true,
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
        ));
  }

  Widget _showEtatProduitInput() {
    return Padding(
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
        ));
  }

  Widget _showUsineInput() {
    return Padding(
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
        ));
  }

  Widget _showPhotoButtonInput() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: _takePhoto,
      child: Text(firstButtonText,
          style: TextStyle(fontSize: textSize, color: Colors.white)),
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
              : ElevatedButton(
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
      _addVehiculeProcess();
    }
  }

  void _addVehiculeProcess() async {
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
                "usineVehicule": _dropUsine
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
      final String errorMsg = 'Impossible d\'enregistrer le véhicule !';
      _showErrorSnack(errorMsg);
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

  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return AppBar(
                centerTitle: true,
                /*
                leading:
                    state.user != null ? Icon(Icons.account_box) : Text(''),
                */
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

  void _takePhoto() async {
    ImagePicker()
        .getImage(source: ImageSource.camera)
        .then((PickedFile recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          firstButtonText = 'Enregistrement photo en cours ...';
        });
        GallerySaver.saveImage(recordedImage.path, albumName: albumName)
            .then((bool success) {
          setState(() {
            firstButtonText = 'Photo enregistrée !';
          });
        });
      }
    });
  }

  void _recordVideo() async {
    ImagePicker()
        .getVideo(source: ImageSource.camera)
        .then((PickedFile recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          secondButtonText = 'saving in progress...';
        });
        GallerySaver.saveVideo(recordedVideo.path, albumName: albumName)
            .then((bool success) {
          setState(() {
            secondButtonText = 'video saved!';
          });
        });
      }
    });
  }

  // ignore: unused_element
  void _saveNetworkVideo() async {
    String path =
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
    GallerySaver.saveVideo(path, albumName: albumName).then((bool success) {
      setState(() {
        print('Video is saved');
      });
    });
  }

  // ignore: unused_element
  void _saveNetworkImage() async {
    String path =
        'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path, albumName: albumName).then((bool success) {
      setState(() {
        print('Image is saved');
      });
    });
  }

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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                        Text(''),
                        _showMatriculeInput(),
                        _showTypeProduitInput(),
                        _showDechargementInput(),
                        Text(''),
                        _showEtatProduitInput(),
                        _showUsineInput(),
                        Text(''),
                        _showPhotoButtonInput(),
                        Text(''),
                        _showFormActions(),
                        Text(''),
                      ])),
            ))));
  }
}
