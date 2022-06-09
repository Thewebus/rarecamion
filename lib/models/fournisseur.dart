// To parse this JSON data, do
//
//     final fournisseur = fournisseurFromJson(jsonString);

import 'dart:convert';

class Fournisseur {
  Fournisseur({
    this.id,
    this.attributes,
  });

  int id;
  Attributes attributes;

  factory Fournisseur.fromRawJson(String str) =>
      Fournisseur.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fournisseur.fromJson(Map<String, dynamic> json) => Fournisseur(
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
    this.nomFournisseur,
    this.detailsFournisseur,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  String nomFournisseur;
  DetailsFournisseur detailsFournisseur;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  factory Attributes.fromRawJson(String str) =>
      Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        nomFournisseur:
            json["nomFournisseur"] == null ? null : json["nomFournisseur"],
        detailsFournisseur: json["detailsFournisseur"] == null
            ? null
            : detailsFournisseurValues.map[json["detailsFournisseur"]],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "nomFournisseur": nomFournisseur == null ? null : nomFournisseur,
        "detailsFournisseur": detailsFournisseur == null
            ? null
            : detailsFournisseurValues.reverse[detailsFournisseur],
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "publishedAt":
            publishedAt == null ? null : publishedAt.toIso8601String(),
      };
}

enum DetailsFournisseur { RAS }

final detailsFournisseurValues = EnumValues({"RAS": DetailsFournisseur.RAS});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
