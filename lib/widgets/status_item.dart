// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
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
  //String _msg = 'PHOTOS: double-cliquer | VIDEOS: maintenir';
  String _msg = 'PHOTOS: double-cliquer';

  String dtformat(DateTime d) {
    return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }

  Widget _showFormActions() {
    return Column(children: [
      _isSubmitting == true
          ? CircularProgressIndicator(
              strokeWidth: 2,
            )
          : Text(_msg,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
    ]);
  }

  void _takePhotoStatusVehicule() async {
    setState(() => _isSubmitting = true);
    setState(() => _msg = 'Chargement en cours ...');

    final ImagePicker _picker = ImagePicker();

    final XFile photo = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 1000, imageQuality: 4);

    /*
final XFile photo = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 600, imageQuality: 5);
        */

    final img.Image capturedImage =
        img.decodeImage(await File(photo.path).readAsBytes());

    final img.Image orientedImage = img.bakeOrientation(capturedImage);

    final File photoOK =
        await File(photo.path).writeAsBytes(img.encodeJpg(orientedImage));

    final request = http.MultipartRequest(
        'POST', Uri.parse('http://rarecamion.com:1337/api/upload/'));

    request.headers['Content-Type'] = "multipart/form-data;charset=utf-8";
    request.headers['Accept'] = "multipart/mixed'";

    request.fields['ref'] = "api::status-vehicule.status-vehicule";
    request.fields['field'] = "image";
    request.fields['refId'] = widget.statusVehicule.id.toString();

    final im = await http.MultipartFile.fromPath('files', photoOK.path,
        contentType: MediaType('image', 'jpeg'));

    request.files.add(im);

    request.send().then((response) {
      setState(() => _msg = 'Patientez svp ...');
      setState(() => _isSubmitting = false);
      if (response.statusCode == 200) {
        setState(() => _msg = 'Succès !');
        print("Uploaded!");
      } else {
        setState(() => _msg = 'Erreur ... réessayer svp !');
        print("Not Uploaded!");
      }
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
        'POST', Uri.parse('http://rarecamion.com:1337/api/upload/'));

    request.headers['Content-Type'] = "multipart/form-data;charset=utf-8";
    request.headers['Accept'] = "multipart/mixed'";

    request.fields['ref'] = "api::status-vehicule.status-vehicule";
    request.fields['field'] = "image";
    request.fields['refId'] = widget.statusVehicule.id.toString();

    final im = await http.MultipartFile.fromPath('files', video.path,
        contentType: MediaType('video', 'mp4'));

    request.files.add(im);

    request.send().then((response) {
      setState(() => _msg = 'Patientez svp ...');
      setState(() => _isSubmitting = false);
      if (response.statusCode == 200) {
        setState(() => _msg = 'Succès !');
        print("Uploaded!");
      } else {
        setState(() => _msg = 'Erreur ... réessayer svp !');
        print("Not Uploaded!");
      }
    });
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.statusVehicule.attributes.libelleStatus,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text(dtformat(widget.statusVehicule.attributes.updatedAt),
                        style: TextStyle(
                            fontSize: 12.0, color: Color(0xFF78FF09))),
                  ]),
              Row(
                children: [
                  _showFormActions(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
