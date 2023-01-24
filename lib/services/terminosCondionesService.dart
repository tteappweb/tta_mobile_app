import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/terminosModelo.dart';
import 'package:places_app/services/api.dart';
import 'package:uuid/uuid.dart';

class TerminosCondicionesService {
  Api terminosDB = new Api('terminos_condiciones');
  FirebaseDB() {}
  
  Future<List<TerminosModel>> getTerminos() async {
    var result = await terminosDB.getDataCollection();
    List<TerminosModel> data;
    data = result.docs.map((doc) => TerminosModel.fromJson(doc.data())).toList();
    return data;
  }
}
