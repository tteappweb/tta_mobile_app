import 'package:places_app/services/api.dart';

class Tutorial {
  String id;
  String imagen;
  String numeroSlide;
  String titulo;
  String descripcion;
  Tutorial({this.id, this.imagen,this.numeroSlide,this.titulo,this.descripcion});

  static Api api = new Api('slides');

  factory Tutorial.fromMap(Map<dynamic, dynamic> json, String id) => Tutorial(
        id: id,
        imagen: json["imagen"],
        numeroSlide:   (json["numeroSlide"]).toString() ,
        titulo: json["titulo"],
        descripcion: json["descripcion"]
      );
  static Future<List<Tutorial>> fetchData() async {
    print("api.orderBy");
    final resp = await api.orderBy("numeroSlide",);
    //final resp = await api.getDataCollection();
    return resp.docs.map((doc) => Tutorial.fromMap(doc.data(), doc.id)).toList();
  }
}