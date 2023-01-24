// To parse this JSON data, do
//
//     final afiliado = afiliadoFromJson(jsonString);

import 'dart:convert';

import 'package:places_app/services/api.dart';

List<Afiliado> afiliadoFromJson(String str) =>
    List<Afiliado>.from(json.decode(str).map((x) => Afiliado.fromJson(x)));

String afiliadoToJson(List<Afiliado> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Afiliado {
  Afiliado({
    this.id,
    this.nombre,
    this.img,
    this.telefono,
    this.rfc,
    this.user,
    this.total = 0,
    this.puntos = 0,
    this.rating = 0.0,
    this.aprobado = false,
    this.fotos,
    this.categoria,
    this.latitud,
    this.longitud,
    this.ubicacion,
    this.descripcion
  });

  String id;
  String nombre;
  String img;
  String telefono;
  String rfc;
  String user;
  int total;
  int puntos;
  double rating;
  bool aprobado;
  List<String> fotos;
  String categoria;
  double latitud;
  double longitud;
  String ubicacion;
  String descripcion;

  static Api api = new Api('afiliados');

  factory Afiliado.fromJson(Map<String, dynamic> json) => Afiliado(
        id: json["id"],
        nombre: json["nombre"],
        img: json["img"],
        telefono: json["telefono"].toString(),
        rfc: json["rfc"],
        user: json["user"],
        total: int.parse(json["total"].toString()),
        puntos: int.parse(json["puntos"].toString()),
        rating: double.parse(json["rating"].toString()),
        aprobado: json["aprobado"],
        fotos: List<String>.from(json["fotos"].map((x) => x)),
        categoria: json["categoria"],
        latitud: double.parse(json["latitud"].toString()) ,
        longitud: double.parse(json["longitud"].toString()),
        ubicacion: json["ubicacion"],
        descripcion: json["descripcion"]
      );

  factory Afiliado.fromMap(Map<String, dynamic> json, String id) => Afiliado(
        id: id,
        nombre: json["nombre"],
        img: json["img"],
        telefono: json["telefono"].toString(),
        rfc: json["rfc"],
        user: json["user"],
        total: int.parse(json["total"].toString()),
        puntos: int.parse(json["puntos"].toString()),
        rating: double.parse(json["rating"].toString()),
        aprobado: json["aprobado"],
        fotos: List<String>.from(json["fotos"].map((x) => x)),
        categoria: json["categoria"],
        latitud: json["latitud"] != null ? double.parse(json["latitud"].toString()) : 0.0 ,
        longitud: json["longitud"] != null ? double.parse(json["longitud"].toString()) :0.0,
        ubicacion: json["ubicacion"],
        descripcion: json["descripcion"]
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "img": img,
        "telefono": telefono,
        "rfc": rfc,
        "user": user,
        "total": total,
        "puntos": puntos,
        "rating": rating,
        "aprobado": aprobado,
        "fotos": List<dynamic>.from(fotos.map((x) => x)),
        "categoria": categoria,
        "latitud": latitud,
        "longitud": longitud,
        "ubicacion": ubicacion,
        "descripcion": descripcion,
      };

  static Future<Afiliado> getById(String id) async {
    final resp = await api.getDocumentById(id);
    return Afiliado.fromMap(resp.data(), resp.id);
  }

  Future<void> addRating(int rating) async {
    final newTotal = (this.total ?? 0) + 1;
    final newPuntos = (this.puntos ?? 0) + rating;
    final prom = newTotal > 0
        ? double.parse((newPuntos / newTotal).toStringAsFixed(2))
        : 0.0;
    final Map<String, dynamic> data = {
      'total': newTotal,
      'puntos': newPuntos,
      'rating': prom
    };
    this.total = newTotal;
    this.puntos = newPuntos;
    this.rating = prom;
    await api.updateDocument(data, id);
  }

  static Future<List<Afiliado>> orderByRating() async {
    final resp = await api.orderBy("rating");
    return resp.docs
        .map((doc) => Afiliado.fromMap(doc.data(), doc.id))
        .toList();
  }
}
