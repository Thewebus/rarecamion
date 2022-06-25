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
        id: json["id"] == null ? null : json["id"],
        attributes: json["attributes"] == null
            ? null
            : Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "attributes": attributes == null ? null : attributes.toJson(),
      };
}

class Attributes {
  Attributes({
    this.updatedAt,
    this.libelleStatus,
    this.observationStatus,
    this.createdAt,
    this.publishedAt,
    this.statusEdition,
  });

  DateTime updatedAt;
  String libelleStatus;
  String observationStatus;
  DateTime createdAt;
  DateTime publishedAt;
  String statusEdition;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        libelleStatus:
            json["libelleStatus"] == null ? null : json["libelleStatus"],
        observationStatus: json["observationStatus"] == null
            ? null
            : json["observationStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        statusEdition:
            json["statusEdition"] == null ? null : json["statusEdition"],
      );

  Map<String, dynamic> toJson() => {
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "libelleStatus": libelleStatus == null ? null : libelleStatus,
        "observationStatus":
            observationStatus == null ? null : observationStatus,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "publishedAt":
            publishedAt == null ? null : publishedAt.toIso8601String(),
        "statusEdition": statusEdition == null ? null : statusEdition,
      };
}
