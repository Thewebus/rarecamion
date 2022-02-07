// To parse this JSON data, do
//
//     final vehicules = vehiculesFromJson(jsonString);

import 'dart:convert';

List<Vehicules> vehiculesFromJson(String str) =>
    List<Vehicules>.from(json.decode(str).map((x) => Vehicules.fromJson(x)));

String vehiculesToJson(List<Vehicules> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vehicules {
  Vehicules({
    this.id,
    this.attributes,
  });

  int id;
  Attributes attributes;

  factory Vehicules.fromJson(Map<String, dynamic> json) => Vehicules(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class Attributes {
  Attributes({
    this.matricule,
    this.dechargement,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.typeProduit,
    this.etatProduit,
    this.usineVehicule,
    this.statusEdition,
    this.fournisseur,
  });

  String matricule;
  String dechargement;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String typeProduit;
  String etatProduit;
  String usineVehicule;
  String statusEdition;
  String fournisseur;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        matricule: json["matricule"],
        dechargement: json["dechargement"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        typeProduit: json["typeProduit"],
        etatProduit: json["etatProduit"],
        usineVehicule: json["usineVehicule"],
        statusEdition: json["statusEdition"],
        fournisseur: json["fournisseur"],
      );

  Map<String, dynamic> toJson() => {
        "matricule": matricule,
        "dechargement": dechargement,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "typeProduit": typeProduit,
        "etatProduit": etatProduit,
        "usineVehicule": usineVehicule,
        "statusEdition": statusEdition,
        "fournisseur": fournisseur,
      };
}
