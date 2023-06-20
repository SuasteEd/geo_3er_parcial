// To parse this JSON data, do
//
//     final branches = branchesFromJson(jsonString);

import 'dart:convert';

List<Branches> branchesFromJson(String str) => List<Branches>.from(json.decode(str).map((x) => Branches.fromJson(x)));

String branchesToJson(List<Branches> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Branches {
    String? id;
    String? name;
    String? managerName;
    String? latitude;
    String? longitude;
    int? v;

    Branches({
        this.id,
        this.name,
        this.managerName,
        this.latitude,
        this.longitude,
        this.v,
    });

    factory Branches.fromJson(Map<String, dynamic> json) => Branches(
        id: json["_id"],
        name: json["name"],
        managerName: json["manager_name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "manager_name": managerName,
        "latitude": latitude,
        "longitude": longitude,
        "__v": v,
    };
}
