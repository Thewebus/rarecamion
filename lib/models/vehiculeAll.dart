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
        id: json["id"] == null ? null : json["id"],
        attributes: json["attributes"] == null
            ? null
            : VehiculeAllAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "attributes": attributes == null ? null : attributes.toJson(),
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
    this.user,
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
  UserByAdm user;

  factory VehiculeAllAttributes.fromJson(Map<String, dynamic> json) =>
      VehiculeAllAttributes(
        matricule: json["matricule"] == null ? null : json["matricule"],
        dechargement:
            json["dechargement"] == null ? null : json["dechargement"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        typeProduit: json["typeProduit"] == null ? null : json["typeProduit"],
        etatProduit: json["etatProduit"] == null ? null : json["etatProduit"],
        usineVehicule:
            json["usineVehicule"] == null ? null : json["usineVehicule"],
        statusEdition:
            json["statusEdition"] == null ? null : json["statusEdition"],
        fournisseur: json["fournisseur"] == null ? null : json["fournisseur"],
        user: json["user"] == null ? null : UserByAdm.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "matricule": matricule == null ? null : matricule,
        "dechargement": dechargement == null ? null : dechargement,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "publishedAt":
            publishedAt == null ? null : publishedAt.toIso8601String(),
        "typeProduit": typeProduit == null ? null : typeProduit,
        "etatProduit": etatProduit == null ? null : etatProduit,
        "usineVehicule": usineVehicule == null ? null : usineVehicule,
        "statusEdition": statusEdition == null ? null : statusEdition,
        "fournisseur": fournisseur == null ? null : fournisseur,
        "user": user == null ? null : user.toJson(),
      };
}

class UserByAdm {
  UserByAdm({
    this.data,
  });

  Data data;

  factory UserByAdm.fromJson(Map<String, dynamic> json) => UserByAdm(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.attributes,
  });

  int id;
  DataAttributes attributes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        attributes: json["attributes"] == null
            ? null
            : DataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "attributes": attributes == null ? null : attributes.toJson(),
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

  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;
  String status;

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        provider: json["provider"] == null ? null : json["provider"],
        confirmed: json["confirmed"] == null ? null : json["confirmed"],
        blocked: json["blocked"] == null ? null : json["blocked"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "provider": provider == null ? null : provider,
        "confirmed": confirmed == null ? null : confirmed,
        "blocked": blocked == null ? null : blocked,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "status": status == null ? null : status,
      };
}
