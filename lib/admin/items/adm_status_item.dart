// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:rarecamion/admin/items/adm_status_detail_page.dart';
import 'package:rarecamion/models/status_vehicule.dart';

class StatusItem extends StatefulWidget {
  final StatusVehicule statusVehicule;
  const StatusItem({Key key, this.statusVehicule}) : super(key: key);

  @override
  StatusItemState createState() => StatusItemState();
}

class StatusItemState extends State<StatusItem> {
  bool _isSubmitting = false;
  //String _msg = 'PHOTOS: double-cliquer | VIDEOS: maintenir';
  String _msg = 'Cliquer pour voir les photos';

  String dtformat(DateTime d) {
    return formatDate(d, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }

  Widget _showFormActions() {
    return Column(children: [
      _isSubmitting == true
          ? LinearProgressIndicator()
          : Text(_msg,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return StatusDetailPage(statusvehicule: widget.statusVehicule);
        }));
      },
      child: Card(
        color: Colors.black87,
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
                  Row(),
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
