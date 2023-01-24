import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places_app/const/const.dart';
import 'package:places_app/models/vehiculo_model.dart';
import 'package:places_app/pages/quetepaso/slide_show.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/routes/routes_generate.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum TipoQueTePaso {
  MeParoUnaPatrulla,
  TuveUnAccidente,
  MiCarroNoEsta,
  MePusieronLaArana
}

class QueTePasoPage extends StatefulWidget {
  final VehiculoModel vehiculo;

  const QueTePasoPage(this.vehiculo);
  @override
  _QueTePasoPageState createState() => _QueTePasoPageState();
}

class _QueTePasoPageState extends State<QueTePasoPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  UserPreferences preferences = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _title(),
            _containerItems(context),
            _cancelButton(context),
          ],
        ),
      )),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.cancel,
            color: kBaseColor,
            //size: 40.0,
          ),
          iconSize: 60,
          onPressed: () {
             Navigator.pushNamedAndRemoveUntil(context, homeRoute, (Route<dynamic> route) => false);
          },
        )
      ],
    );
  }

  Widget _title() {
    return Container(
      child: Text(
        "¿Qué te pasó?",
        style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _containerItems(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _itemMenu(
                  "Extorsión policial",
                  Icons.policy,
                  context,
                  TipoQueTePaso.MeParoUnaPatrulla,
                ),
                _itemMenu(
                  "Mi carro no está",
                  FontAwesomeIcons.search,
                  context,
                  TipoQueTePaso.MiCarroNoEsta,
                ),
              ],
            ),
            SizedBox(height: 80.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _itemMenu(
                  "Tuve un accidente",
                  FontAwesomeIcons.carCrash,
                  context,
                  TipoQueTePaso.TuveUnAccidente,
                ),
                _itemMenu(
                  "Me pusieron la araña",
                  Icons.car_repair,
                  context,
                  TipoQueTePaso.MePusieronLaArana,
                ),
              ],
            )
          ],
        ));
  }

  void showBottomModal(BuildContext context, TipoQueTePaso tipoQueTePaso) {
    scaffoldKey.currentState
        .showBottomSheet((context) => buildTipoQueTePaso(tipoQueTePaso));
  }

  Widget _itemMenu(String text, IconData icon, BuildContext context,
      TipoQueTePaso tipoQueTePaso) {
    return GestureDetector(
      onTap: () => showBottomModal(context, tipoQueTePaso),
      child: Container(
        child: Column(
          children: [
            Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                //color: Colors.blue.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: kBaseColor,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTipoQueTePaso(TipoQueTePaso tipoQueTePaso) {
    switch (tipoQueTePaso) {
      case TipoQueTePaso.MeParoUnaPatrulla:
        return _buildMeParoUnaPatrulla();
        break;
      case TipoQueTePaso.TuveUnAccidente:
        return _buildTuveUnAccidente();
        break;
      case TipoQueTePaso.MiCarroNoEsta:
        return _buildMiCarroNoEsta();
        break;
      case TipoQueTePaso.MePusieronLaArana:
        return _buildMePusieronLaArana();

        break;
      default:
    }
  }

  Widget _buildMeParoUnaPatrulla() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  FaIcon(
                    Icons.policy,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "¿Te están extorsionando?",
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 2,
                color: Colors.white,
                thickness: 3,
              ),
              SizedBox(
                height: 5,
              ),
              // Row(
              //   children: [
              //     Text(
              //       "Locatel",
              //       style: TextStyle(
              //           color: kBaseTextTitle,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Expanded(
              //       child: Container(),
              //     )
              //   ],
              // ),
              Row(
                children: [
                  Text(
                    "Llama al: ",
                    style: TextStyle(
                        color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "5552089898",
                    style: TextStyle(color: Colors.white,fontSize: 20,),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final String phone = "5552089898".split(" ").join("");
                        await launch("tel://$phone");
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTuveUnAccidente() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  FaIcon(
                    FontAwesomeIcons.carCrash,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "Tuve un accidente ",
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 2,
                color: Colors.white,
                thickness: 3,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Número de póliza ",
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.vehiculo.seguro,
                    //preferences.numeroPoliza,
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  // Expanded(
                  //   child: Container(),
                  // )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                
                children: [
                  Text(
                    "Teléfono de emergencia de seguro: ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20,),
                        overflow: TextOverflow.ellipsis,
                  ),
                  
                ],
              ),
              ),
              Row(
                children: [
                  Text(
                    widget.vehiculo.telefonoSeguro,
                    //preferences.telefonoPoliza,
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white
                      ),
                      onPressed: () async {
                        final String phone =
                            widget.vehiculo.telefonoSeguro.split(" ").join("");
                        await launch("tel://$phone");
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiCarroNoEsta() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  FaIcon(
                    FontAwesomeIcons.search,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "Mi carro no está",
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
                color: Colors.white,
                thickness: 3,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Verifica si se llevaron al corralón tu auto llamando al siguiente número:",
                    style: TextStyle(
                      color: kBaseTextTitle,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  )),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Locatel: ",
                    style: TextStyle(
                        color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "5556581111",
                    style: TextStyle(color: Colors.white,fontSize: 20,),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final String phone = "5556581111".split(" ").join("");
                        await launch("tel://$phone");
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMePusieronLaArana() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  FaIcon(
                    Icons.car_repair,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "Me pusieron la araña",
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
                color: Colors.white,
                thickness: 3,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Busca tu boleta de la infracción en tu parabrisas. En ella vendrá el monto de la multa y el teléfono para que retiren tu inmovilizador. Puedes pagar en tiendas 7Eleven.",
                    style: TextStyle(
                        color: kBaseTextTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
