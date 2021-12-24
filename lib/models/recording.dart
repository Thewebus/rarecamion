import 'package:meta/meta.dart';

class Recording {
  int id;
  String matricule;
  String dechargement;
  String createdAt;
  String typeProduit;
  String etatProduit;
  String usineVehicule;

  Recording(
      {@required this.id,
      @required this.matricule,
      @required this.dechargement,
      @required this.createdAt,
      @required this.typeProduit,
      @required this.etatProduit,
      @required this.usineVehicule});

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
        id: json['id'],
        matricule: json['matricule'],
        dechargement: json['dechargement'],
        createdAt: json['createdAt'],
        typeProduit: json['typeProduit'],
        etatProduit: json['etatProduit'],
        usineVehicule: json['usineVehicule']);
  }
}
