import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_app/components/blur_container.dart';
import 'package:places_app/components/search_address_map.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/helpers/alerts_helper.dart' as alerts;
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/routes/routes_generate.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:places_app/services/afiliados_service.dart';

class EditarAfiliadoPage extends StatefulWidget {
  final Afiliado afiliado;

  const EditarAfiliadoPage({Key key, this.afiliado}) : super(key: key);
  @override
  _EditarAfiliadoPageState createState() => _EditarAfiliadoPageState();
}

class _EditarAfiliadoPageState extends State<EditarAfiliadoPage> {
  Size _size;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isSaving = false;
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController telefonoCtrl = new TextEditingController();
  TextEditingController ubicacionCtrl = new TextEditingController();
  AfiliadosService afiliadosService = new AfiliadosService();

  //TextEditingController rfcCtrl = new TextEditingController();
  //FirebaseDB db = FirebaseDB();

  double latitud = 0.0;
  double longitud = 0.0;
  @override
  Widget build(BuildContext context) {
    nombreCtrl.text = widget.afiliado.nombre;
    telefonoCtrl.text = widget.afiliado.telefono;
    ubicacionCtrl.text = widget.afiliado.ubicacion;
    latitud = widget.afiliado.latitud;
    longitud = widget.afiliado.longitud;

    print("editData");
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Editar"), centerTitle: true),
      body: _formContainer(),
    );
  }

  Widget _formContainer() {
    return BlurContainer(
      isLoading: isSaving,
      text: "Actualizando",
      children: [
        Container(
          width: _size.width,
          height: _size.height,
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  //color: Colors.white,
                  color: Colors.white70,
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                width: _size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Editar",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Edicion Afiliado",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: telefonoCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Número telefónico',
                        ),
                      ),
                      Container(
                        child: Stack(
                          children: [
                            TextFormField(
                              readOnly: true,
                              controller: ubicacionCtrl,
                              decoration: InputDecoration(
                                labelText: 'Ubicación',
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              //height: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Container()),
                                      IconButton(
                                          icon: Icon(Icons.map),
                                          onPressed: () {
                                            _buildDireccion();
                                          })
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        child: FlatButton(
                          minWidth: _size.width * 0.4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onPressed: handleEditar,
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );

    ;
  }

  void handleEditar() async {
    //TODO: Register
    try {
      setIsSaving(true);

      Afiliado afiliado = new Afiliado(
          id: widget.afiliado.id,
          nombre: nombreCtrl.text,
          categoria: widget.afiliado.categoria,
          telefono: telefonoCtrl.text,
          latitud: latitud,
          longitud: longitud,
          img: widget.afiliado.img,
          fotos: widget.afiliado.fotos,
          user: widget.afiliado.user,
          ubicacion: ubicacionCtrl.text,
          aprobado: widget.afiliado.aprobado,
          rating: widget.afiliado.rating,
          puntos: widget.afiliado.puntos);
      await afiliadosService.updateDocument(afiliado);
      alerts.success(context, "Actualizacion exitosa",
          "Sus datos fueron actualizados con exito.", false,f: () {
        Navigator.pushReplacementNamed(context, homeRoute);
      });

      setIsSaving(false);
    } catch (e) {
      print(e.toString());
      alerts.error(
          context, "Error", "Ocurrió un error al registrar la afiliación");
      setIsSaving(false);
    }
  }

  void setIsSaving(bool val) {
    setState(() {
      isSaving = val;
    });
  }

  _buildDireccion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey:
              "AIzaSyCxyFsUuFODYNFkLSNabseR9_VAWX9u21Y", // Put YOUR OWN KEY here.
          onPlacePicked: (result) {
            print(result.formattedAddress);
            ubicacionCtrl.text = result.formattedAddress;
            latitud = result.geometry.location.lat;
            longitud = result.geometry.location.lng;

            Navigator.of(context).pop();
          },
          initialPosition: LatLng(19.3764253, -99.0573512),
          useCurrentLocation: true,
        ),
      ),
    );
  }
}
