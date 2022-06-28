// To parse this JSON data, do
//
//     final vehiculeAll = vehiculeAllFromJson(jsonString);

import 'dart:convert';

List<VehiculeAll> vehiculeAllFromJson(String str) => List<VehiculeAll>.from(
    json.decode(str).map((x) => VehiculeAll.fromJson(x)));

String vehiculeAllToJson(List<VehiculeAll> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehiculeAll {
  VehiculeAll({
    this.id,
    this.attributes,
  });

  int id;
  VehiculeAllAttributes attributes;

  factory VehiculeAll.fromJson(Map<String, dynamic> json) => VehiculeAll(
        id: json["id"],
        attributes: VehiculeAllAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class VehiculeAllAttributes {
  VehiculeAllAttributes({
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
    this.photoVehicule,
    this.photoProduit,
    this.user,
    this.statusVehicules,
  });

  String matricule;
  String dechargement;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  TypeProduit typeProduit;
  EtatProduit etatProduit;
  UsineVehicule usineVehicule;
  StatusEdition statusEdition;
  String fournisseur;
  PhotoProduit photoVehicule;
  PhotoProduit photoProduit;
  PhotoProduit user;
  PhotoProduit statusVehicules;

  factory VehiculeAllAttributes.fromJson(Map<String, dynamic> json) =>
      VehiculeAllAttributes(
        matricule: json["matricule"],
        dechargement: json["dechargement"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        typeProduit: typeProduitValues.map[json["typeProduit"]],
        etatProduit: etatProduitValues.map[json["etatProduit"]],
        usineVehicule: usineVehiculeValues.map[json["usineVehicule"]],
        statusEdition: statusEditionValues.map[json["statusEdition"]],
        fournisseur: json["fournisseur"],
        photoVehicule: PhotoProduit.fromJson(json["photoVehicule"]),
        photoProduit: PhotoProduit.fromJson(json["photoProduit"]),
        user: PhotoProduit.fromJson(json["user"]),
        statusVehicules: PhotoProduit.fromJson(json["status_vehicules"]),
      );

  Map<String, dynamic> toJson() => {
        "matricule": matricule,
        "dechargement": dechargement,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "typeProduit": typeProduitValues.reverse[typeProduit],
        "etatProduit": etatProduitValues.reverse[etatProduit],
        "usineVehicule": usineVehiculeValues.reverse[usineVehicule],
        "statusEdition": statusEditionValues.reverse[statusEdition],
        "fournisseur": fournisseur,
        "photoVehicule": photoVehicule.toJson(),
        "photoProduit": photoProduit.toJson(),
        "user": user.toJson(),
        "status_vehicules": statusVehicules.toJson(),
      };
}

enum EtatProduit { MOYEN, BON, MAUVAIS }

final etatProduitValues = EnumValues({
  "BON": EtatProduit.BON,
  "MAUVAIS": EtatProduit.MAUVAIS,
  "MOYEN": EtatProduit.MOYEN
});

class PhotoProduit {
  PhotoProduit({
    this.data,
  });

  dynamic data;

  factory PhotoProduit.fromJson(Map<String, dynamic> json) => PhotoProduit(
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

class Datum {
  Datum({
    this.id,
    this.attributes,
  });

  int id;
  DatumAttributes attributes;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: DatumAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class DatumAttributes {
  DatumAttributes({
    this.libelleStatus,
    this.observationStatus,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.statusEdition,
  });

  LibelleStatus libelleStatus;
  String observationStatus;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  StatusEdition statusEdition;

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      DatumAttributes(
        libelleStatus: libelleStatusValues.map[json["libelleStatus"]],
        observationStatus: json["observationStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        statusEdition: statusEditionValues.map[json["statusEdition"]],
      );

  Map<String, dynamic> toJson() => {
        "libelleStatus": libelleStatusValues.reverse[libelleStatus],
        "observationStatus": observationStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "statusEdition": statusEditionValues.reverse[statusEdition],
      };
}

enum LibelleStatus { EN_RANG, EN_PENTE }

final libelleStatusValues = EnumValues(
    {"EN PENTE": LibelleStatus.EN_PENTE, "EN RANG": LibelleStatus.EN_RANG});

enum StatusEdition { EDITION }

final statusEditionValues = EnumValues({"edition": StatusEdition.EDITION});

class DataClass {
  DataClass({
    this.id,
    this.attributes,
  });

  int id;
  DataAttributes attributes;

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
        id: json["id"],
        attributes: DataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class DataAttributes {
  DataAttributes({
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.blocked,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  Username username;
  Email email;
  Provider provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;
  Status status;

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        username: usernameValues.map[json["username"]],
        email: emailValues.map[json["email"]],
        provider: providerValues.map[json["provider"]],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        status: statusValues.map[json["status"]],
      );

  Map<String, dynamic> toJson() => {
        "username": usernameValues.reverse[username],
        "email": emailValues.reverse[email],
        "provider": providerValues.reverse[provider],
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "status": statusValues.reverse[status],
      };
}

enum Email { TTEST_GMAIL_COM, HUSSEINTEST_RARECAMION_COM, HERMANN_GMAIL_COM }

final emailValues = EnumValues({
  "hermann@gmail.com": Email.HERMANN_GMAIL_COM,
  "husseintest@rarecamion.com": Email.HUSSEINTEST_RARECAMION_COM,
  "ttest@gmail.com": Email.TTEST_GMAIL_COM
});

enum Provider { LOCAL }

final providerValues = EnumValues({"local": Provider.LOCAL});

enum Status { NORMAL }

final statusValues = EnumValues({"normal": Status.NORMAL});

enum Username { THIERRY_TEST, HUSSEIN_GHAZZAWI, HERMANN_TEST }

final usernameValues = EnumValues({
  "Hermann TEST": Username.HERMANN_TEST,
  "Hussein Ghazzawi": Username.HUSSEIN_GHAZZAWI,
  "Thierry TEST": Username.THIERRY_TEST
});

enum TypeProduit { HEVEA, MANGUES }

final typeProduitValues =
    EnumValues({"HEVEA": TypeProduit.HEVEA, "Mangues": TypeProduit.MANGUES});

enum UsineVehicule { DOKOUE, IRA }

final usineVehiculeValues =
    EnumValues({"DOKOUE": UsineVehicule.DOKOUE, "IRA": UsineVehicule.IRA});

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
