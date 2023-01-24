import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/avisosModelo.dart';
import 'package:places_app/models/terminosModelo.dart';
import 'package:places_app/services/api.dart';
import 'package:uuid/uuid.dart';

class AvisosPrivacidadService {
  Api terminosDB = new Api('avisos_privacidad');
  FirebaseDB() {}
  
  Future<List<AvisosModel>> getAvisos() async {
    var result = await terminosDB.getDataCollection();
    List<AvisosModel> data;
    data = result.docs.map((doc) => AvisosModel.fromJson(doc.data())).toList();
    return data;
  }
}
