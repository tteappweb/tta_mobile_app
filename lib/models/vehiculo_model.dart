import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:places_app/services/api.dart';

VehiculoModel vehiculoModelFromJson(String str) =>
    VehiculoModel.fromJson(json.decode(str));

String vehiculoModelToJson(VehiculoModel data) => json.encode(data.toJson());

class VehiculoModel {
  static Api api = new Api('vehiculo');
  VehiculoModel(
      {@required this.correo,
      @required this.fechaPagoTenencia,
      @required this.fechaVencimientoLicencia,
      @required this.fechaVencimientoPoliza,
      @required this.licencia,
      @required this.placa,
      @required this.seguro,
      @required this.telefonoSeguro,
      @required this.vencimientoVerificacio,
      @required this.vencimientoTarjetaCirculacion,
      @required this.ultimaFechaDeServicio});

  String correo;
  String fechaPagoTenencia;
  String fechaVencimientoLicencia;
  String fechaVencimientoPoliza;
  String licencia;
  String placa;
  String seguro;
  String telefonoSeguro;
  String vencimientoVerificacio;
  String vencimientoTarjetaCirculacion;
  String ultimaFechaDeServicio;

  factory VehiculoModel.fromJson(Map<String, dynamic> json) => VehiculoModel(
        correo: json["correo"],
        fechaPagoTenencia: json["fechaPagoTenencia"],
        fechaVencimientoLicencia: json["fechaVencimientoLicencia"],
        fechaVencimientoPoliza: json["fechaVencimientoPoliza"],
        licencia: json["licencia"],
        placa: json["placa"],
        seguro: json["seguro"],
        telefonoSeguro: json["telefonoSeguro"],
        
        vencimientoTarjetaCirculacion: json["vencimientoTarjetaCirculacion"],
        ultimaFechaDeServicio: json["ultimaFechaDeServicio"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "fechaPagoTenencia": fechaPagoTenencia,
        "fechaVencimientoLicencia": fechaVencimientoLicencia,
        "fechaVencimientoPoliza": fechaVencimientoPoliza,
        "licencia": licencia,
        "placa": placa,
        "seguro": seguro,
        "telefonoSeguro": telefonoSeguro,
        "vencimientoVerificacio": vencimientoVerificacio,
        "vencimientoTarjetaCirculacion" : vencimientoTarjetaCirculacion,
        "ultimaFechaDeServicio": ultimaFechaDeServicio
      };
  factory VehiculoModel.fromMap(Map<String, dynamic> json) =>
      VehiculoModel(
          correo: json["correo"],
          fechaPagoTenencia: json["fechaPagoTenencia"],
          fechaVencimientoLicencia: json["fechaVencimientoLicencia"],
          fechaVencimientoPoliza: json["fechaVencimientoPoliza"],
          licencia: json["licencia"],
          placa: json["placa"],
          seguro: json["seguro"],
          telefonoSeguro: json["telefonoSeguro"],
          vencimientoTarjetaCirculacion: json["vencimientoTarjetaCirculacion"],
          vencimientoVerificacio: json["vencimientoVerificacio"],
          ultimaFechaDeServicio: json["ultimaFechaDeServicio"],
         );

  static Future<List<VehiculoModel>> fetchData() async {
    final resp = await api.getDataCollection();
    return resp.docs.map((doc) => VehiculoModel.fromMap(doc.data())).toList();
  }
}
