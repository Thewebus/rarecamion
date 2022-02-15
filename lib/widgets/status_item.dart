import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import '../models/status_vehicule.dart';

class StatusCard extends StatelessWidget {
  final StatusVehicule statusVehicule;
  const StatusCard({Key key, this.statusVehicule}) : super(key: key);

  String dtformat(DateTime d) {
    return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }

  final String _flashInfo = '';

  void _takePhotoStatusVehicule() async {
    final ImagePicker _picker = ImagePicker();

    final XFile photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null && photo.path != null) {
      print('Prise de photo effectuée: ${photo.path}');
    } else {
      print("Aucune photo prise !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
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
