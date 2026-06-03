// To parse this JSON data, do
//
//     final searchLocationModel = searchLocationModelFromJson(jsonString);

import 'dart:convert';

SearchLocationModel searchLocationModelFromJson(String str) =>
    SearchLocationModel.fromJson(json.decode(str));

String searchLocationModelToJson(SearchLocationModel data) =>
    json.encode(data.toJson());

class SearchLocationModel {
  Meta? meta;
  List<SearchAddress>? addresses;

  SearchLocationModel({
    this.meta,
    this.addresses,
  });

  factory SearchLocationModel.fromJson(Map<String, dynamic> json) =>
      SearchLocationModel(
        meta: json['meta'] == null ? null : Meta.fromJson(json['meta']),
        addresses: json['addresses'] == null
            ? []
            : List<SearchAddress>.from(
                json['addresses']!.map((x) => SearchAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'meta': meta?.toJson(),
        'addresses': addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
      };
}

class SearchAddress {
  String? addressLabel;
  String? city;
  String? country;
  String? countryCode;
  String? countryFlag;
  String? county;
  double? distance;
  String? formattedAddress;
  Geometry? geometry;
  double? latitude;
  double? longitude;
  String? postalCode;
  String? state;
  String? stateCode;
  String? layer;
  String? placeLabel;
  String? street;

  SearchAddress({
    this.addressLabel,
    this.city,
    this.country,
    this.countryCode,
    this.countryFlag,
    this.county,
    this.distance,
    this.formattedAddress,
    this.geometry,
    this.latitude,
    this.longitude,
    this.postalCode,
    this.state,
    this.stateCode,
    this.layer,
    this.placeLabel,
    this.street,
  });

  factory SearchAddress.fromJson(Map<String, dynamic> json) => SearchAddress(
        addressLabel: json['addressLabel'],
        city: json['city'],
        country: json['country']!,
        countryCode: json['countryCode']!,
        countryFlag: json['countryFlag']!,
        county: json['county'],
        distance: json['distance']?.toDouble(),
        formattedAddress: json['formattedAddress'],
        geometry: json['geometry'] == null
            ? null
            : Geometry.fromJson(json['geometry']),
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
        postalCode: json['postalCode'],
        state: json['state'],
        stateCode: json['stateCode'],
        layer: json['layer'],
        placeLabel: json['placeLabel'],
        street: json['street'],
      );

  Map<String, dynamic> toJson() => {
        'addressLabel': addressLabel,
        'city': city,
        'country': country,
        'countryCode': countryCode,
        'countryFlag': countryFlag,
        'county': county,
        'distance': distance,
        'formattedAddress': formattedAddress,
        'geometry': geometry?.toJson(),
        'latitude': latitude,
        'longitude': longitude,
        'postalCode': postalCode,
        'state': state,
        'stateCode': stateCode,
        'layer': layer,
        'placeLabel': placeLabel,
        'street': street,
      };
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json['type'],
        coordinates: json['coordinates'] == null
            ? []
            : List<double>.from(json['coordinates']!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Meta {
  int? code;

  Meta({
    this.code,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        code: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'code': code,
      };
}
