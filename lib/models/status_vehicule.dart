// To parse this JSON data, do
//
//     final statusVehicule = statusVehiculeFromJson(jsonString);

import 'dart:convert';

StatusVehicule statusVehiculeFromJson(String str) =>
    StatusVehicule.fromJson(json.decode(str));

String statusVehiculeToJson(StatusVehicule data) => json.encode(data.toJson());

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
  });

  String libelleStatus;
  String observationStatus;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        libelleStatus: json["libelleStatus"],
        observationStatus: json["observationStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "libelleStatus": libelleStatus,
        "observationStatus": observationStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
      };
}
