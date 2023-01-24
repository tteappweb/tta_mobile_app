// To parse this JSON data, do
//
//     final terminosModel = terminosModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TerminosModel terminosModelFromJson(String str) => TerminosModel.fromJson(json.decode(str));

String terminosModelToJson(TerminosModel data) => json.encode(data.toJson());

class TerminosModel {
    TerminosModel({
        @required this.texto,
    });

    String texto;

    factory TerminosModel.fromJson(Map<String, dynamic> json) => TerminosModel(
        texto: json["texto"],
    );

    Map<String, dynamic> toJson() => {
        "texto": texto,
    };
}
