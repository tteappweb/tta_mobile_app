// To parse this JSON data, do
//
//     final terminosModel = terminosModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AvisosModel avisosModelFromJson(String str) => AvisosModel.fromJson(json.decode(str));

String avisosModelToJson(AvisosModel data) => json.encode(data.toJson());

class AvisosModel {
    AvisosModel({
        @required this.texto,
    });

    String texto;

    factory AvisosModel.fromJson(Map<String, dynamic> json) => AvisosModel(
        texto: json["texto"],
    );

    Map<String, dynamic> toJson() => {
        "texto": texto,
    };
}
