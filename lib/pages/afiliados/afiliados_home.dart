import 'package:flutter/material.dart';
import 'package:places_app/components/fotos_slider.dart';
import 'package:places_app/components/title.dart';
import 'package:places_app/const/const.dart';
import 'package:places_app/menu.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/routes/routes_generate.dart';
import 'package:places_app/services/afiliados_service.dart';
import 'package:places_app/services/user_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'editar_afilidado_page.dart';

class AfiliadosHome extends StatefulWidget {
  AfiliadosHome({Key key}) : super(key: key);

  @override
  _AfiliadosHomeState createState() => _AfiliadosHomeState();
}

class _AfiliadosHomeState extends State<AfiliadosHome> {
  Size _size;
  Afiliado afiliado = new Afiliado();
  UserPreferences preferences = new UserPreferences();
  AfiliadosService afiliadoService = new AfiliadosService();
  bool hasAfiliacion = false;
  bool isAprobado = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    hasAfiliacion = preferences.nombreAfiliacion.toString().isNotEmpty;
    if (hasAfiliacion) {
      isAprobado = preferences.afiliacionAprobada;
    }
    //afiliado = await afiliadoService.getByUser(preferences.email);

    //setState(() {});

    print("home_afiliado");
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: afiliadoService.getByUser(preferences.email),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        afiliado = snapshot.data;
        if(snapshot.hasData){
          return Scaffold(
            key: scaffoldKey,
            drawer: MenuBar(),
            body: _stack(),
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _enEsperaDeAprobacion() {
    return Center(child: Text("Su solicitud está en revisión."));
  }

  Widget _stack() {
    return Stack(
      children: <Widget>[
        _body(),
        Positioned(
          left: 10,
          top: 25,
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState.openDrawer(),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    Widget body = Container();
    if (hasAfiliacion && !isAprobado) {
      body = _enEsperaDeAprobacion();
    }
    if (hasAfiliacion && isAprobado) {
      body = _buildDatosAfiliado();
    }

    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(top: 50.0, right: 10.0, left: 20.0),
          child: body),
    );
  }

  Widget _buildDatosAfiliado() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        //height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildImgPotada(),
            TitleComponent("Fotos"),
            FotosSlider(fotos: afiliado.fotos),
            SizedBox(height: 20.0),
            _details(),
          ],
        ),
      ),
    );
  }

  Widget _buildImgPotada() {
    return Container(
      height: _size.height * 0.33,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _size.height * 0.25,
            child: FadeInImage(
              image: NetworkImage(afiliado.img),
              placeholder: AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
              //width: double.infinity,
            ),
          ),
          Text(
            afiliado.categoria,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _details() {
    return Container(
      //width: double.infinity,
      child: Row(
        children: [
          Column(
            children: [
              _rating2(afiliado.rating, afiliado.total),
              _row(
                Icon(Icons.book, color: kBaseColor),
                afiliado.descripcion,
              ),
              _row(
                Icon(Icons.store, color: kBaseColor),
                afiliado.nombre,
              ),
              _rowTelefono(
                Icon(Icons.phone, color: kBaseColor),
                afiliado.telefono,
              ),
              
              _row(
                Icon(Icons.place, color: kBaseColor),
                afiliado.ubicacion,
              ),
              _rowMapa(Icon(Icons.place, color: kBaseColor), afiliado.ubicacion,
                  afiliado.latitud, afiliado.longitud),
              _buildEditar()
            ],
          ),
        ],
      ),
    );
  }

  Widget _rating2(double value, int total) {
    if (value == 0.0) {
      return Container();
    }

    List<Widget> stars = [];
    int total = value.toInt();

    int halfs = 0;
    double rest = value - total;

    if (rest >= 0.24) {
      if (rest >= .69)
        total += 1;
      else
        halfs += 1;
    }
    for (int i = 0; i < total; ++i) {
      stars.add(Icon(
        Icons.star,
        color: Colors.yellow.shade700,
      ));
    }

    if (halfs == 1) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow.shade700));
    }

    return Container(
      width: _size.width * 0.9,
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.only(left: 13.0),
      child: Row(
        children: <Widget>[
          Text(
            "$value",
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 5.0),
          ...stars,
          SizedBox(width: 5.0),
          Text(
            "($total)",
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(Icon icon, String info) {
    if (info == null) return Container();
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(bottom: 10.0),
      width: _size.width * 0.9,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: icon,
          ),
          Flexible(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  info ?? '',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowTelefono(Icon icon, String telefono) {
    if (telefono == null) return Container();
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(bottom: 10.0),
      width: _size.width * 0.9,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: icon,
          ),
          Flexible(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  telefono ?? '',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IconButton(
              icon: Icon(
                Icons.phone_in_talk,
                color: Colors.blue,
              ),
              onPressed: () async {
                final String phone = telefono.split(" ").join("");
                await launch("tel://$phone");
              })
        ],
      ),
    );
  }

  Widget _rowMapa(Icon icon, String lugar, double latitud, double longitud) {
    if (latitud == null) return Container();
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(bottom: 10.0),
      width: _size.width * 0.9,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: icon,
          ),
          Text(
            "Como llegar" ?? '',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IconButton(
              icon: Icon(
                Icons.near_me,
                color: Colors.blue,
              ),
              onPressed: () async {
                final availableMaps = await MapLauncher.installedMaps;
                print(
                    availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                await availableMaps.first.showMarker(
                  coords: Coords(
                    (latitud == 0.0) ? 19.2529912 : latitud,
                    (longitud == 0.0) ? -99.5791536 : longitud,
                  ),
                  title: afiliado.nombre,
                  description: "",
                );
              }),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  Widget _buildEditar() {
    return Container(
      color: Colors.blueAccent,
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(bottom: 10.0),
      width: _size.width * 0.9,
      child: Row(
        children: [
          Text(
            "Editar Datos",
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Container(),
          ),
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () => _buildEditData())
        ],
      ),
    );
  }

  _buildEditData() {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditarAfiliadoPage(afiliado: afiliado)),
    );
  }
}
