// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:places_app/services/api.dart';

List<Usuario> usuarioFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
  Usuario({
    this.id = "",
    this.tipoUsuario = "normal",
    this.correo = "",
    this.apellidoMaterno = "",
    this.apellidoPaterno = "",
    this.nombre = "",
    this.placa = "",
    this.seguro = "",
    this.licencia = "",
    this.telefonoSeguro = "",
    this.fechaVencimientoLicencia="",
    this.fechaVencimientoPoliza="",
    this.vencimientoVerificacio="",
    this.fechaPagoTenencia= "",
    this.tokenPush = "",

  });

  static Api api = new Api('usuarios');

  String id;
  String tipoUsuario;
  String correo;
  String apellidoPaterno;
  String apellidoMaterno;
  String nombre;
  String placa;
  String seguro;
  String telefonoSeguro;
  String licencia;
  String fechaVencimientoLicencia;
  String fechaVencimientoPoliza;
  String vencimientoVerificacio;
  String fechaPagoTenencia;
  String tokenPush;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      id: json["id"],
      tipoUsuario: json["tipoUsuario"],
      correo: json["correo"],
      apellidoMaterno: json["apellidoMaterno"],
      apellidoPaterno: json["apellidoPaterno"],
      licencia: json["licencia"],
      nombre: json["nombre"],
      placa: json["placa"],
      seguro: json["seguro"],
      telefonoSeguro: json["telefonoSeguro"],
      fechaVencimientoLicencia: json["fechaVencimientoLicencia"],
      fechaVencimientoPoliza: json["fechaVencimientoPoliza"],
      vencimientoVerificacio: json["vencimientoVerificacio"],
      fechaPagoTenencia: json["fechaPagoTenencia"],
      tokenPush: json["tokenPush"]);

  factory Usuario.fromMap(Map<String, dynamic> json, String id) => Usuario(
      id: id,
      tipoUsuario: json["tipoUsuario"],
      correo: json["correo"],
      apellidoMaterno: json["apellidoMaterno"],
      apellidoPaterno: json["apellidoPaterno"],
      licencia: json["licencia"],
      nombre: json["nombre"],
      placa: json["placa"],
      seguro: json["seguro"],
      telefonoSeguro: json["telefonoSeguro"],
      fechaVencimientoLicencia: json["fechaVencimientoLicencia"],
      fechaVencimientoPoliza: json["fechaVencimientoPoliza"],
      vencimientoVerificacio: json["vencimientoVerificacio"],
      fechaPagoTenencia: json["fechaPagoTenencia"],
      tokenPush: json["tokenPush"]);

  Map<String, dynamic> toJson() => {
        "tipoUsuario": tipoUsuario,
        "correo": correo,
        "apellidoMaterno": apellidoMaterno,
        "apellidoPaterno": apellidoPaterno,
        "licencia": licencia,
        "nombre": nombre,
        "placa": placa,
        "seguro": seguro,
        "telefonoSeguro":telefonoSeguro,
        "fechaVencimientoLicencia": fechaVencimientoLicencia,
        "fechaVencimientoPoliza": fechaVencimientoPoliza,
        "vencimientoVerificacio": vencimientoVerificacio,
        "fechaPagoTenencia": fechaPagoTenencia,
        "tokenPush": tokenPush
      };

  Future save(String id) async {
    await api.addDocumentWithId(id, this.toJson());
  }

  Future<Usuario> fetchData(String id) async {
    final resp = await api.getDocumentById(id);

    print(resp);
    return Usuario.fromJson(resp.data());
  }

  static Future<List<Usuario>> listUsers() async {
    final resp = await api.getDataCollection();
    return resp.docs
        .map((doc) => Usuario.fromMap(doc.data(), doc.id))
        .toList();
  }
}
