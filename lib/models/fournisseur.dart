// To parse this JSON data, do
//
//     final fournisseur = fournisseurFromJson(jsonString);

import 'dart:convert';

List<Fournisseur> fournisseurFromJson(String str) => List<Fournisseur>.from(
    json.decode(str).map((x) => Fournisseur.fromJson(x)));

String fournisseurToJson(List<Fournisseur> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Fournisseur {
  Fournisseur({
    this.id,
    this.attributes,
  });

  int id;
  Attributes attributes;

  factory Fournisseur.fromJson(Map<String, dynamic> json) => Fournisseur(
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

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        nomFournisseur: json["nomFournisseur"],
        detailsFournisseur:
            detailsFournisseurValues.map[json["detailsFournisseur"]],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "nomFournisseur": nomFournisseur,
        "detailsFournisseur":
            detailsFournisseurValues.reverse[detailsFournisseur],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
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
