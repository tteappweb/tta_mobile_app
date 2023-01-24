import 'package:places_app/services/api.dart';

class UbicacionAfiliado {
  String nombre;
  double latitud;
  double longitud;
  String ubicacion;
  UbicacionAfiliado({this.nombre, this.latitud,this.longitud,this.ubicacion});

  static Api api = new Api('afiliados');

  factory UbicacionAfiliado.fromMap(Map<dynamic, dynamic> json, String id) => UbicacionAfiliado(
        nombre: json["nombre"],
        latitud:   (json["latitud"]) ,
        longitud: json["longitud"],
        ubicacion: json["ubicacion"]
      );
  static Future<List<UbicacionAfiliado>> fetchData(String caterogia) async {
    print("api.orderBy");
    final resp = await api.getWhere("categoria",caterogia);
    //final resp = await api.getDataCollection();
    return resp.docs.map((doc) => UbicacionAfiliado.fromMap(doc.data(), doc.id)).toList();
  }
}