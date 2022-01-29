// To parse this JSON data, do
//
//     final fournisseur = fournisseurFromJson(jsonString);

import 'dart:convert';

Fournisseur fournisseurFromJson(String str) =>
    Fournisseur.fromJson(json.decode(str));

String fournisseurToJson(Fournisseur data) => json.encode(data.toJson());

class Fournisseur {
  Fournisseur({
    this.data,
    this.meta,
  });

  List<Datum> data;
  Meta meta;

  factory Fournisseur.fromJson(Map<String, dynamic> json) => Fournisseur(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Datum {
  Datum({
    this.id,
    this.attributes,
  });

  int id;
  Attributes attributes;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

class Meta {
  Meta({
    this.pagination,
  });

  Pagination pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  int page;
  int pageSize;
  int pageCount;
  int total;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}

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
