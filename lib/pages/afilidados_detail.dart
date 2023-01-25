import 'package:flutter/material.dart';
import 'package:places_app/components/fotos_slider.dart';
import 'package:places_app/components/title.dart';
import 'package:places_app/const/const.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/rate_model.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';
import 'package:places_app/helpers/alerts_helper.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class AfiliadosDetailsPage extends StatefulWidget {
  Afiliado afiliado;

  AfiliadosDetailsPage({this.afiliado});

  @override
  _AfiliadosDetailsPageState createState() => _AfiliadosDetailsPageState();
}

class _AfiliadosDetailsPageState extends State<AfiliadosDetailsPage> {
  Size _size;
  BuildContext _context;
  bool isCalificando = false;
  UserPreferences preferences = new UserPreferences();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AppState appState = new AppState();
  List<Widget> stars = [];
  int cantidadEstrellas = 5;
  int puntaje = 5;
  setCalificando(bool val) {
    setState(() {
      isCalificando = val;
    });
  }

  @override
  void initState() {
    stars = [
      Icon(
        Icons.star,
        color: Colors.yellow.shade700,
        size: 35.0,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow.shade700,
        size: 35.0,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow.shade700,
        size: 35.0,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow.shade700,
        size: 35.0,
      ),
      Icon(
        Icons.star,
        color: Colors.yellow.shade700,
        size: 35.0,
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    _size = MediaQuery.of(context).size;
    _context = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.afiliado.nombre,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _fotoMain(),
                TitleComponent("Fotos"),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.afiliado.img,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),

                // FotosSlider(fotos: widget.afiliado.fotos),
                SizedBox(height: 20.0),
                _details(),
              ],
            ),
          ),
          _calificar(),
        ],
      ),
    ));
  }

  showAlert(BuildContext context, String title) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: _rating(4),
          actions: <Widget>[
            MaterialButton(
              child: Text('Guardar calificación'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: _rating(5),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  void handleCalificar(int calificacion) async {
    Rating rating = new Rating(
      rate: calificacion,
      afiliadoId: widget.afiliado.id,
      usuarioId: preferences.email,
      nombreAfiliacion: widget.afiliado.nombre,
      imgNegocio: widget.afiliado.img,
      nombreUsuario: "",
      ubicacion: widget.afiliado.ubicacion ?? '',
    );
    if (await rating.validateRating()) {
      return success(context, "Error", "Este negocio ya está calificado", true);
    }

    rating.save();
    appState.updateRatings();
    appState.updateAfiliados();
    Afiliado a = await Afiliado.getById(widget.afiliado.id);
    await a.addRating(calificacion);
    success(context, "Calificación guardada", "su calificacion ha sido guardada correctamente", true);
    setCalificando(false);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(value)));
    
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

  Widget _rating(double value) {
    //stars =
    int total = value.toInt();
    //int cantidadEstrellas = 2;
    int halfs = 0;
    double rest = value - total;

    if (rest >= 0.24) {
      if (rest >= .69)
        total += 1;
      else
        halfs += 1;
    }

    print(stars);
    return Container(
      height: _size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return estrella(stars[index], index);
        },
      ),
    );
  }

  Widget estrella(Icon icon, int i) {
    return GestureDetector(
      onTap: () {
        for (var j = 0; j <= i; j++) {
          print('j:' + j.toString());
          stars[j] = (Icon(
            Icons.star,
            color: Colors.yellow.shade700,
            size: 35.0,
          ));
        }
        for (var k = i + 1; k < cantidadEstrellas; k++) {
          print('k:' + k.toString());
          stars[k] = (Icon(
            Icons.star_border,
            color: Colors.yellow.shade700,
            size: 35.0,
          ));
        }
        puntaje = i + 1;
        setState(() {});
      },
      child: icon,
    );
  }

  Widget _calificar() {
    if (isCalificando) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _rating(5),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    handleCalificar(puntaje);
                  })
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setCalificando(true),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow[800]),
              SizedBox(width: 10.0),
              Text(
                "Calificar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _details() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _rating2(widget.afiliado.rating, widget.afiliado.total),
              _row(
                Icon(Icons.store, color: kBaseColor),
                widget.afiliado.nombre,
              ),
              _rowTelefono(
                Icon(Icons.phone, color: kBaseColor),
                widget.afiliado.telefono,
              ),
              _row(
                Icon(Icons.place, color: kBaseColor),
                widget.afiliado.ubicacion,
              ),
              _rowMapa(Icon(Icons.place, color: kBaseColor), widget.afiliado.ubicacion, widget.afiliado.latitud, widget.afiliado.longitud)
            ],
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
          new Text(
            telefono ?? '',
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
            "Cómo llegar" ?? '',
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
                print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                await availableMaps.first.showMarker(
                  coords: Coords(
                    (latitud == 0.0) ? 19.2529912 : latitud,
                    (longitud == 0.0) ? -99.5791536 : longitud,
                  ),
                  title: "Grúas",
                  description: "Asia's tallest building",
                );
              })
        ],
      ),
    );
  }

  Widget _fotoMain() {
    return Container(
      // height: _size.height * 0.33,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.afiliado.img,
              fit: BoxFit.cover,
              height: 180,
            ),
          ),
          Text(
            widget.afiliado.categoria,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
