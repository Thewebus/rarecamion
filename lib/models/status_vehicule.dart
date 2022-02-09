// To parse this JSON data, do
//
//     final statusVehicule = statusVehiculeFromJson(jsonString);

import 'dart:convert';

List<StatusVehicule> statusVehiculeFromJson(String str) =>
    List<StatusVehicule>.from(
        json.decode(str).map((x) => StatusVehicule.fromJson(x)));

String statusVehiculeToJson(List<StatusVehicule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusVehicule {
  StatusVehicule({
    this.id,
    this.attributes,
  });

  int id;
  Attributes attributes;

  factory StatusVehicule.fromJson(Map<String, dynamic> json) => StatusVehicule(
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
    this.libelleStatus,
    this.observationStatus,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.statusEdition,
  });

  String libelleStatus;
  String observationStatus;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String statusEdition;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        libelleStatus: json["libelleStatus"],
        observationStatus: json["observationStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        statusEdition: json["statusEdition"],
      );

  Map<String, dynamic> toJson() => {
        "libelleStatus": libelleStatus,
        "observationStatus": observationStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "statusEdition": statusEdition,
      };
}
