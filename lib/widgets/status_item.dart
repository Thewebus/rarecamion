import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import '../models/status_vehicule.dart';
import 'package:http/http.dart' as http;

class StatusItem extends StatelessWidget {
  final StatusVehicule statusVehicule;
  const StatusItem({Key key, this.statusVehicule}) : super(key: key);

  String dtformat(DateTime d) {
    return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }

  final String _flashInfo = '';

  void _takePhotoStatusVehicule() async {
    final ImagePicker _picker = ImagePicker();

    final XFile photo = await _picker.pickImage(source: ImageSource.gallery);

    /*
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=utf-8',
      'Accept': 'multipart/mixed',
    };
    */

    final request = http.MultipartRequest(
        'POST', Uri.parse('http://rarecamion.com:1337/api/upload/'));

    //request.headers['Authorization'] = "";
    request.headers['Content-Type'] = "multipart/form-data;charset=utf-8";
    request.headers['Accept'] = "multipart/mixed'";

    request.fields['ref'] = "api::status-vehicule.status-vehicule";
    request.fields['field'] = "image";
    request.fields['refId'] = this.statusVehicule.id.toString();

    final picture =
        http.MultipartFile.fromBytes('files', await photo.readAsBytes());

    request.files.add(picture);

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });

    /*
    http.Response response =
        await http.post(Uri.parse('http://rarecamion.com:1337/api/upload/'),
            headers: headers,
            body: jsonEncode({
              "data": {
                "ref": "api::status-vehicule.status-vehicule",
                "files": photo.path,
                "field": "image",
                "refId": this.statusVehicule.id.toString()
              }
            }));

  
    print('FILES : ${photo.path}');
    print('REFID : ${this.statusVehicule.id.toString()}');

    if (photo != null && photo.path != null) {
      print('Prise de photo effectuée: ${photo.path}');
    } else {
      print("Aucune photo prise !");
    }

    */

    final responseData = await response.stream.toBytes();

    final result = String.fromCharCodes(responseData);

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _takePhotoStatusVehicule();

        //_showSnack('Tapé !');
      },
      child: Card(
        color: Color.fromARGB(255, 15, 113, 241),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${this.statusVehicule.attributes.libelleStatus}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255))),
                    Text(
                        '${dtformat(this.statusVehicule.attributes.updatedAt)}',
                        style: TextStyle(
                            fontSize: 9.0,
                            color: Color.fromARGB(255, 194, 250, 89))),
                  ]),
              Row(
                children: [
                  Text('$_flashInfo'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
