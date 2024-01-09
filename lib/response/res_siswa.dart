// To parse this JSON data, do
//
//     final siswaModel = siswaModelFromJson(jsonString);

import 'dart:convert';

List<SiswaModel> siswaModelFromJson(String str) => List<SiswaModel>.from(json.decode(str).map((x) => SiswaModel.fromJson(x)));

String siswaModelToJson(List<SiswaModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SiswaModel {
  final String id;
  final String nis;
  final String nama;
  final String alamat;

  SiswaModel({
    required this.id,
    required this.nis,
    required this.nama,
    required this.alamat,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) => SiswaModel(
    id: json["id"],
    nis: json["nis"],
    nama: json["nama"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nis": nis,
    "nama": nama,
    "alamat": alamat,
  };
}
