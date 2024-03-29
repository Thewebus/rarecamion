// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import '../models/status_vehicule.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;

import '../pages/status_detail_page.dart';

class StatusItem extends StatefulWidget {
  final StatusVehicule statusVehicule;
  const StatusItem({Key key, this.statusVehicule}) : super(key: key);

  @override
  StatusItemState createState() => StatusItemState();
}

class StatusItemState extends State<StatusItem> {
  bool _isSubmitting = false;
  String _msg = '';

  String dtformat(DateTime d) {
    return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }

  Widget _showFormActions() {
    return Column(children: [
      _isSubmitting == true
          ? CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(_msg,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
    ]);
  }

  void _takePhotoStatusVehicule() async {
    setState(() => _isSubmitting = true);
    setState(() => _msg = 'Envoi de la photo en cours ...');

    final ImagePicker _picker = ImagePicker();

    final XFile photo = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 1500, imageQuality: 4);

    final img.Image capturedImage =
        img.decodeImage(await File(photo.path).readAsBytes());

    final img.Image orientedImage = img.bakeOrientation(capturedImage);

    final File photoOK =
        await File(photo.path).writeAsBytes(img.encodeJpg(orientedImage));

    final request = http.MultipartRequest(
        'POST', Uri.parse('http://api.rarecamion.com/api/upload/'));

    request.headers['Content-Type'] = "multipart/form-data;charset=utf-8";
    request.headers['Accept'] = "multipart/mixed'";

    request.fields['ref'] = "api::status-vehicule.status-vehicule";
    request.fields['field'] = "image";
    request.fields['refId'] = widget.statusVehicule.id.toString();

    final im = await http.MultipartFile.fromPath('files', photoOK.path,
        contentType: MediaType('image', 'jpeg'));

    request.files.add(im);

    request.send().then((response) {
      setState(() => _msg = 'Attente du serveur ...');
      setState(() => _isSubmitting = false);
      if (response.statusCode == 200) {
        setState(() => _msg = 'Envoi PHOTO réussi! Cliquez pour voir.');
      } else {
        setState(() => _msg = 'ERREUR! Vérifiez votre connectivité!');
      }
      print(_msg);
    });
  }

  void _takeVideoStatusVehicule() async {
    setState(() => _isSubmitting = true);
    setState(() => _msg = 'Chargement en cours ...');

    final ImagePicker _picker = ImagePicker();

    final XFile video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: Duration(minutes: 2),
        preferredCameraDevice: CameraDevice.rear);

    final request = http.MultipartRequest(
        'POST', Uri.parse('http://api.rarecamion.com/api/upload/'));

    request.headers['Content-Type'] = "multipart/form-data;charset=utf-8";
    request.headers['Accept'] = "multipart/mixed'";

    request.fields['ref'] = "api::status-vehicule.status-vehicule";
    request.fields['field'] = "video";
    request.fields['refId'] = widget.statusVehicule.id.toString();

    final vid = await http.MultipartFile.fromPath('files', video.path,
        contentType: MediaType('video', 'mp4'));

    request.files.add(vid);

    request.send().then((response) {
      setState(() => _msg = 'Patientez svp ...');
      setState(() => _isSubmitting = false);
      if (response.statusCode == 200) {
        setState(() => _msg = 'Envoi VIDEO réussi! Cliquez pour voir.');
      } else {
        setState(() => _msg = 'ERREUR! Vérifiez votre connectivité!');
      }
      print(_msg);
    });
  }

  void _showSnack(String message) {
    final snackbar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    Navigator.of(context).pop(true);
  }

  void _deleteStatusVehicule(int statusID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    String infoFlash = '';
    String url = 'http://api.rarecamion.com/api/status-vehicules/$statusID';

    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      infoFlash = 'Impossible de supprimer !';
    } else {
      infoFlash = 'Suppression effectuée avec succès !';
    }
    _showSnack(infoFlash);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _takeVideoStatusVehicule,
      onDoubleTap: () {
        _takePhotoStatusVehicule();
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return StatusDetailPage(statusvehicule: widget.statusVehicule);
        }));
      },
      child: Card(
        color: Colors.blue.shade800,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.statusVehicule.attributes.libelleStatus,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    IconButton(
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: const Text('Confirmez '),
                          content: const Text(
                              'Voulez-vous vraiment supprimer ce status ?'),
                          textOK: const Text('Oui, supprimer !'),
                          textCancel: const Text('Non'),
                        )) {
                          return _deleteStatusVehicule(
                              widget.statusVehicule.id);
                        } else
                          return print('pressedCancel');
                      },
                      iconSize: 30,
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dtformat(widget.statusVehicule.attributes.updatedAt),
                      style:
                          TextStyle(fontSize: 10.0, color: Color(0xFF78FF09))),
                  _showFormActions(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
