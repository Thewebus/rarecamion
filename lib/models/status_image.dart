// To parse this JSON data, do
//
//     final statusImage = statusImageFromJson(jsonString);

import 'dart:convert';

class StatusImage {
  StatusImage({
    this.data,
    this.meta,
  });

  Data data;
  Meta meta;

  factory StatusImage.fromRawJson(String str) =>
      StatusImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatusImage.fromJson(Map<String, dynamic> json) => StatusImage(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
        "meta": meta == null ? null : meta.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.attributes,
  });

  int id;
  DataAttributes attributes;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
    this.libelleStatus,
    this.observationStatus,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.statusEdition,
    this.image,
  });

  String libelleStatus;
  String observationStatus;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String statusEdition;
  Image image;

  factory DataAttributes.fromRawJson(String str) =>
      DataAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        libelleStatus:
            json["libelleStatus"] == null ? null : json["libelleStatus"],
        observationStatus: json["observationStatus"] == null
            ? null
            : json["observationStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        statusEdition:
            json["statusEdition"] == null ? null : json["statusEdition"],
        image: json["Image"] == null ? null : Image.fromJson(json["Image"]),
      );

  Map<String, dynamic> toJson() => {
        "libelleStatus": libelleStatus == null ? null : libelleStatus,
        "observationStatus":
            observationStatus == null ? null : observationStatus,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "publishedAt":
            publishedAt == null ? null : publishedAt.toIso8601String(),
        "statusEdition": statusEdition == null ? null : statusEdition,
        "Image": image == null ? null : image.toJson(),
      };
}

class Image {
  Image({
    this.data,
  });

  List<Datum> data;

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.attributes,
  });

  int id;
  DatumAttributes attributes;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        attributes: json["attributes"] == null
            ? null
            : DatumAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "attributes": attributes == null ? null : attributes.toJson(),
      };
}

class DatumAttributes {
  DatumAttributes({
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
  String ext;
  String mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
  dynamic providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory DatumAttributes.fromRawJson(String str) =>
      DatumAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      DatumAttributes(
        name: json["name"] == null ? null : json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"] == null ? null : json["hash"],
        ext: json["ext"] == null ? null : json["ext"],
        mime: json["mime"] == null ? null : json["mime"],
        size: json["size"] == null ? null : json["size"].toDouble(),
        url: json["url"] == null ? null : json["url"],
        previewUrl: json["previewUrl"],
        provider: json["provider"] == null ? null : json["provider"],
        providerMetadata: json["provider_metadata"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "formats": formats == null ? null : formats.toJson(),
        "hash": hash == null ? null : hash,
        "ext": ext == null ? null : ext,
        "mime": mime == null ? null : mime,
        "size": size == null ? null : size,
        "url": url == null ? null : url,
        "previewUrl": previewUrl,
        "provider": provider == null ? null : provider,
        "provider_metadata": providerMetadata,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Formats {
  Formats({
    this.thumbnail,
    this.medium,
    this.small,
  });

  Medium thumbnail;
  Medium medium;
  Medium small;

  factory Formats.fromRawJson(String str) => Formats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: json["thumbnail"] == null
            ? null
            : Medium.fromJson(json["thumbnail"]),
        medium: json["medium"] == null ? null : Medium.fromJson(json["medium"]),
        small: json["small"] == null ? null : Medium.fromJson(json["small"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
        "medium": medium == null ? null : medium.toJson(),
        "small": small == null ? null : small.toJson(),
      };
}

class Medium {
  Medium({
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
  String ext;
  String mime;
  dynamic path;
  int width;
  int height;
  double size;
  String url;

  factory Medium.fromRawJson(String str) => Medium.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Medium.fromJson(Map<String, dynamic> json) => Medium(
        name: json["name"] == null ? null : json["name"],
        hash: json["hash"] == null ? null : json["hash"],
        ext: json["ext"] == null ? null : json["ext"],
        mime: json["mime"] == null ? null : json["mime"],
        path: json["path"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        size: json["size"] == null ? null : json["size"].toDouble(),
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "hash": hash == null ? null : hash,
        "ext": ext == null ? null : ext,
        "mime": mime == null ? null : mime,
        "path": path,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "size": size == null ? null : size,
        "url": url == null ? null : url,
      };
}

class Meta {
  Meta();

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
