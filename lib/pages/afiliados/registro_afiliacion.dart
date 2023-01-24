import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places_app/components/blur_container.dart';

import 'package:places_app/components/fotos_file_slider.dart';
import 'package:places_app/components/search_address_map.dart';
import 'package:places_app/const/const.dart';
import 'package:places_app/data/Data.dart';
import 'package:places_app/helpers/alerts_helper.dart' as alerts;
import 'package:places_app/helpers/fotos_helper.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/categoria_model.dart';
import 'package:places_app/pages/afiliados/seleccion_localizacion.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/routes/routes_generate.dart';

import 'package:places_app/services/db_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegistroAfiliacion extends StatefulWidget {
  RegistroAfiliacion({Key key}) : super(key: key);

  @override
  _RegistroAfiliacionState createState() => _RegistroAfiliacionState();
}

class _RegistroAfiliacionState extends State<RegistroAfiliacion> {
  Size _size;
  final _formKey = GlobalKey<FormState>();
  PickedFile fotoFile = null;
  bool isLoading = false;
  bool isSaving = false;
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController telefonoCtrl = new TextEditingController();
  TextEditingController ubicacionCtrl = new TextEditingController();
  TextEditingController rfcCtrl = new TextEditingController();
  TextEditingController _descripcioncontroller = new TextEditingController();
  FirebaseDB db = FirebaseDB();
  List<PickedFile> fotos = [];
  double latitud = 0.0;
  double longitud = 0.0;
  List<Categoria> categorias = [];
  UserPreferences preferences = new UserPreferences();

  String categoriaValue = '';
  List<S2Choice<String>> options = [
    // ...GlobalData.categorias
    //     .map((e) => S2Choice(value: e.nombre, title: e.nombre))
    //     .toList()
  ];

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  void initData() async {
    this.categorias = await Categoria.fetchData();
    options = this.categorias.map((e) => S2Choice(value: e.nombre, title: e.nombre)).toList();
    print(categorias);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlurContainer(
          isLoading: isSaving,
          text: "Registrando proveedor, espere un momento",
          children: [
            _formContainer(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "register",
          backgroundColor: kBaseColor,
          onPressed: handleRegister,
          label: Text("Terminar registro"),
        ),
      ),
    );
  }

  Widget _formContainer() {
    return Form(
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
          width: _size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      "Paso 2",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Registro de proveedor",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                _containerImg(),
                TextFormField(
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nombre de comercio',
                  ),
                ),
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
                SmartSelect<String>.single(
                  title: 'Categoría',
                  value: categoriaValue,
                  choiceItems: options,
                  placeholder: "Seleccionar",
                  onChange: (state) =>
                      setState(() => categoriaValue = state.value),
                ),
                _fotosContainer(),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  maxLines: 5,
                  controller: _descripcioncontroller,
                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Describe los servicios que ofreces',
                    alignLabelWithHint:true, 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleLogOut() {
    preferences.email = "";
    preferences.tipoUsuario = "";
    preferences.nombreAfiliacion = "";
    Navigator.pushReplacementNamed(context, loginRoute);
  }

  void handleAddFoto() async {
    PickedFile file = await cargarFoto(context, "Agregar foto del lugar");
    if (file != null) {
      fotos.add(file);
      setState(() {});
    }
  }

  Widget _fotosContainer() {
    if (fotos.isEmpty) {
      return GestureDetector(
        onTap: handleAddFoto,
        child: Container(
          height: 30.0,
          width: _size.width * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.plus, color: Colors.grey, size: 13.0),
                SizedBox(width: 10.0),
                Text(
                  "Clic para agregar fotos del lugar",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: handleAddFoto,
            child: Container(
              width: _size.width * 0.3,
              height: 60.0,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.plus, color: Colors.grey, size: 13.0),
                  SizedBox(width: 10.0),
                  Text(
                    "Agregar foto",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
          FotosFileSlider(fotos: fotos),
        ],
      ),
    );
  }

  void setIsSaving(bool val) {
    setState(() {
      isSaving = val;
    });
  }

  void handleRegister() async {
    //TODO: Register
    try {
      setIsSaving(true);
      if (categoriaValue == '') {
        //Show Message
        return;
      }

      String urlImg = await subirImagen(fotoFile);
      List<String> urls = [];
      List<Future<String>> fs = fotos.map((e) => subirImagen(e)).toList();
      urls = await Future.wait(fs);

      Afiliado afiliado = new Afiliado(
        id: "",
        nombre: nombreCtrl.text,
        categoria: categoriaValue,
        telefono: telefonoCtrl.text,
        latitud: latitud,
        longitud: longitud,
        img: urlImg,
        fotos: urls,
        user: preferences.email,
        ubicacion: ubicacionCtrl.text,
        aprobado: false,
        descripcion: _descripcioncontroller.text,
      );
      print(afiliado.toJson());
      print(afiliado);
      db.crearAfiliado(afiliado);
      
      alerts.success(context, "Registro exitoso",
          "Su registro será revisado para su aprobación.",false,f: () {
        Navigator.pushReplacementNamed(context, loginRoute);
      });

      setIsSaving(false);
    } catch (e) {
      print(e.toString());
      alerts.error(
          context, "Error", "Ocurrió un error al registrar la afiliación");
      setIsSaving(false);
    }
  }

  void setLoading(bool val) {
    isLoading = val;
    setState(() {});
  }

  Widget _containerImg() {
    if (isLoading) return CircularProgressIndicator();
    return GestureDetector(
      onTap: () async {
        setLoading(true);
        fotoFile = await cargarDeGaleria(context);
        setLoading(false);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10.0,
        ),
        height: _size.height * 0.15,
        child: fotoFile == null ? _dottedContainer() : _portada(),
      ),
    );
  }

  Widget _portada() {
    return Image.file(File(fotoFile.path));
  }

  Widget _dottedContainer() {
    return DottedBorder(
      color: Colors.grey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              color: Colors.grey,
            ),
            SizedBox(height: 10.0),
            Text(
              "Cargar foto de portada",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
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
