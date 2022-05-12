// To parse this JSON data, do
//
//     final statusImage = statusImageFromJson(jsonString);

import 'dart:convert';

StatusImage statusImageFromJson(String str) =>
    StatusImage.fromJson(json.decode(str));

String statusImageToJson(StatusImage data) => json.encode(data.toJson());

class StatusImage {
  StatusImage({
    this.data,
    this.meta,
  });

  List<StatusImageDatum> data;
  Meta meta;

  factory StatusImage.fromJson(Map<String, dynamic> json) => StatusImage(
        data: List<StatusImageDatum>.from(
            json["data"].map((x) => StatusImageDatum.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class StatusImageDatum {
  StatusImageDatum({
    this.id,
    this.attributes,
  });

  int id;
  PurpleAttributes attributes;

  factory StatusImageDatum.fromJson(Map<String, dynamic> json) =>
      StatusImageDatum(
        id: json["id"],
        attributes: PurpleAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class PurpleAttributes {
  PurpleAttributes({
    this.libelleStatus,
    this.observationStatus,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.statusEdition,
    this.vehiculeRelated,
    this.image,
  });

  String libelleStatus;
  String observationStatus;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  StatusEdition statusEdition;
  VehiculeRelated vehiculeRelated;
  Image image;

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        libelleStatus: json["libelleStatus"],
        observationStatus: json["observationStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        statusEdition: statusEditionValues.map[json["statusEdition"]],
        vehiculeRelated: VehiculeRelated.fromJson(json["vehicule_related"]),
        image: Image.fromJson(json["Image"]),
      );

  Map<String, dynamic> toJson() => {
        "libelleStatus": libelleStatus,
        "observationStatus": observationStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "statusEdition": statusEditionValues.reverse[statusEdition],
        "vehicule_related": vehiculeRelated.toJson(),
        "Image": image.toJson(),
      };
}

class Image {
  Image({
    this.data,
  });

  List<ImageDatum> data;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        data: json["data"] == null
            ? null
            : List<ImageDatum>.from(
                json["data"].map((x) => ImageDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ImageDatum {
  ImageDatum({
    this.id,
    this.attributes,
  });

  int id;
  FluffyAttributes attributes;

  factory ImageDatum.fromJson(Map<String, dynamic> json) => ImageDatum(
        id: json["id"],
        attributes: FluffyAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class FluffyAttributes {
  FluffyAttributes({
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  String name;
  dynamic alternativeText;
  dynamic caption;
  int width;
  int height;
  Formats formats;
  String hash;
  Ext ext;
  Mime mime;
  double size;
  String url;
  dynamic previewUrl;
  Provider provider;
  dynamic providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) =>
      FluffyAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: extValues.map[json["ext"]],
        mime: mimeValues.map[json["mime"]],
        size: json["size"].toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: providerValues.map[json["provider"]],
        providerMetadata: json["provider_metadata"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "formats": formats == null ? null : formats.toJson(),
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": providerValues.reverse[provider],
        "provider_metadata": providerMetadata,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum Ext { JPG, MOV }

final extValues = EnumValues({".jpg": Ext.JPG, ".MOV": Ext.MOV});

class Formats {
  Formats({
    this.thumbnail,
    this.large,
    this.medium,
    this.small,
  });

  Large thumbnail;
  Large large;
  Large medium;
  Large small;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: Large.fromJson(json["thumbnail"]),
        large: Large.fromJson(json["large"]),
        medium: Large.fromJson(json["medium"]),
        small: Large.fromJson(json["small"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail.toJson(),
        "large": large.toJson(),
        "medium": medium.toJson(),
        "small": small.toJson(),
      };
}

class Large {
  Large({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.path,
    this.width,
    this.height,
    this.size,
    this.url,
  });

  String name;
  String hash;
  Ext ext;
  Mime mime;
  dynamic path;
  int width;
  int height;
  double size;
  String url;

  factory Large.fromJson(Map<String, dynamic> json) => Large(
        name: json["name"],
        hash: json["hash"],
        ext: extValues.map[json["ext"]],
        mime: mimeValues.map[json["mime"]],
        path: json["path"],
        width: json["width"],
        height: json["height"],
        size: json["size"].toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "path": path,
        "width": width,
        "height": height,
        "size": size,
        "url": url,
      };
}

enum Mime { IMAGE_JPEG, VIDEO_MP4 }

final mimeValues =
    EnumValues({"image/jpeg": Mime.IMAGE_JPEG, "video/mp4": Mime.VIDEO_MP4});

enum Provider { LOCAL }

final providerValues = EnumValues({"local": Provider.LOCAL});

enum StatusEdition { EDITION }

final statusEditionValues = EnumValues({"edition": StatusEdition.EDITION});

class VehiculeRelated {
  VehiculeRelated({
    this.data,
  });

  Data data;

  factory VehiculeRelated.fromJson(Map<String, dynamic> json) =>
      VehiculeRelated(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
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
  Dechargement dechargement;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String typeProduit;
  EtatProduit etatProduit;
  UsineVehicule usineVehicule;
  StatusEdition statusEdition;
  String fournisseur;

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        matricule: json["matricule"],
        dechargement: dechargementValues.map[json["dechargement"]],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        typeProduit: json["typeProduit"],
        etatProduit: etatProduitValues.map[json["etatProduit"]],
        usineVehicule: usineVehiculeValues.map[json["usineVehicule"]],
        statusEdition: statusEditionValues.map[json["statusEdition"]],
        fournisseur: json["fournisseur"],
      );

  Map<String, dynamic> toJson() => {
        "matricule": matricule,
        "dechargement": dechargementValues.reverse[dechargement],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "typeProduit": typeProduit,
        "etatProduit": etatProduitValues.reverse[etatProduit],
        "usineVehicule": usineVehiculeValues.reverse[usineVehicule],
        "statusEdition": statusEditionValues.reverse[statusEdition],
        "fournisseur": fournisseur,
      };
}

enum Dechargement { KIA, REMORQUE, TRICYCLE }

final dechargementValues = EnumValues({
  "KIA": Dechargement.KIA,
  "REMORQUE": Dechargement.REMORQUE,
  "TRICYCLE": Dechargement.TRICYCLE
});

enum EtatProduit { BON, MAUVAIS, MOYEN }

final etatProduitValues = EnumValues({
  "BON": EtatProduit.BON,
  "MAUVAIS": EtatProduit.MAUVAIS,
  "MOYEN": EtatProduit.MOYEN
});

enum UsineVehicule { IRA, DOKOUE }

final usineVehiculeValues =
    EnumValues({"DOKOUE": UsineVehicule.DOKOUE, "IRA": UsineVehicule.IRA});

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
