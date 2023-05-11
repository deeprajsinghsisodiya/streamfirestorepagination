// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<Datum> data;
  Support support;

  User({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
    required this.support,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    page: json["page"],
    perPage: json["per_page"],
    total: json["total"],
    totalPages: json["total_pages"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    support: Support.fromJson(json["support"]),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "total": total,
    "total_pages": totalPages,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "support": support.toJson(),
  };
}

class Datum {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  Datum({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
  };
}

class Support {
  String url;
  String text;

  Support({
    required this.url,
    required this.text,
  });

  factory Support.fromJson(Map<String, dynamic> json) => Support(
    url: json["url"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "text": text,
  };
}







// import 'package:flutter/material.dart';
// import 'dart:convert';
//
// List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
//
// String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class User {
//   int id;
//   String name;
//   String username;
//   String email;
//   Address address;
//   String phone;
//   String website;
//   Company company;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.username,
//     required this.email,
//     required this.address,
//     required this.phone,
//     required this.website,
//     required this.company,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     name: json["name"],
//     username: json["username"],
//     email: json["email"],
//     address: Address.fromJson(json["address"]),
//     phone: json["phone"],
//     website: json["website"],
//     company: Company.fromJson(json["company"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "username": username,
//     "email": email,
//     "address": address.toJson(),
//     "phone": phone,
//     "website": website,
//     "company": company.toJson(),
//   };
// }
//
// class Address {
//   String street;
//   String suite;
//   String city;
//   String zipcode;
//   Geo geo;
//
//   Address({
//     required this.street,
//     required this.suite,
//     required this.city,
//     required this.zipcode,
//     required this.geo,
//   });
//
//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//     street: json["street"],
//     suite: json["suite"],
//     city: json["city"],
//     zipcode: json["zipcode"],
//     geo: Geo.fromJson(json["geo"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "street": street,
//     "suite": suite,
//     "city": city,
//     "zipcode": zipcode,
//     "geo": geo.toJson(),
//   };
// }
//
// class Geo {
//   String lat;
//   String lng;
//
//   Geo({
//     required this.lat,
//     required this.lng,
//   });
//
//   factory Geo.fromJson(Map<String, dynamic> json) => Geo(
//     lat: json["lat"],
//     lng: json["lng"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "lat": lat,
//     "lng": lng,
//   };
// }
//
// class Company {
//   String name;
//   String catchPhrase;
//   String bs;
//
//   Company({
//     required this.name,
//     required this.catchPhrase,
//     required this.bs,
//   });
//
//   factory Company.fromJson(Map<String, dynamic> json) => Company(
//     name: json["name"],
//     catchPhrase: json["catchPhrase"],
//     bs: json["bs"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "catchPhrase": catchPhrase,
//     "bs": bs,
//   };
// }
