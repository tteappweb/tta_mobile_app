import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:places_app/components/chilangos_button.dart';
import 'package:places_app/models/tutoriales_model.dart';
import 'package:places_app/pages/home_page.dart';
import 'package:places_app/shared/user_preferences.dart';

import 'item_tutorial.dart';

class SwiperTutorial extends StatefulWidget {
  final List<Tutorial> listaTutorial;

  const SwiperTutorial({Key key, this.listaTutorial}) : super(key: key);
  @override
  _SwiperTutorialState createState() => _SwiperTutorialState();
}

class _SwiperTutorialState extends State<SwiperTutorial> {
  List<ItemTutorial> imageListUsuario = [];
  static int _swiperIndex = 0;
  final SwiperController _controller = SwiperController();
  int listUsuarioLenght;
  bool activarEmpezar = false;
  int indexGlobal = 0;
  UserPreferences userPrefrences = new UserPreferences();

  @override
  void initState() {
    super.initState();
    imageListUsuario = widget.listaTutorial
        .map((e) => ItemTutorial(
              img: e.imagen,
              title: e.titulo,
              message: e.descripcion,
            ))
        .toList();

    /*imageListUsuario = [
      ItemTutorial(
        
        title: "Registro",
        message:
            "Crea un perfil para a tu mascota, se generara un Carnet y código QR único.",
      ),
      ItemTutorial(
        
        title: "Codogo QR",
        message:
            "Muestra el código QR de tu mascota a tu veterinario para iniciar la consulta.",
      ),
      ItemTutorial(
       
        title: "Agendas",
        message:
            "Agenda las próximas citas de tus mascotas, vacunas y desparasitaciones.",
      ),
      ItemTutorial(
        
        title: "¿Sin Efectivo?",
        message:
            "Puedes pagar con tu tarjeta de crédito, debito o PayPal a tu veterinario.",
      ),
    ];*/

    listUsuarioLenght = imageListUsuario.length;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Container(
        // width: width,
        height: height,
        color: Colors.transparent, //307.25,
        child: Stack(
          children: [
            Swiper(
              index: _swiperIndex,
              // layout: SwiperLayout.TINDER ,
              itemWidth: width,
              itemHeight: height,
              itemBuilder: (BuildContext context, int index) {
                return imageListUsuario[index];
              },
              viewportFraction: 0.8,
              scale: 0.9,
              itemCount: imageListUsuario.length,
              pagination: new SwiperPagination(),
              controller: _controller,
              onIndexChanged: (data) {
                if (!activarEmpezar) {
                  _buildNextButton(data);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.58),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                        width: 170,
                        height: 50,
                        child: activarEmpezar
                            ? ChilangosButton(
                                label: "Comenzar",
                                //textColor: Colors.black,
                                onPressed: () {
                                  userPrefrences.setIsFirstLoad = false;
                                  Navigator.of(context).popAndPushNamed(HomePage.routeName);
                                })
                            : ChilangosButton(
                                label: "Siguiente",
                                //textColor: Colors.black,
                                onPressed: () => _buildControler())),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildNextButton(int index) {
    if (listUsuarioLenght - 1 == index) {
      setState(() {
        activarEmpezar = true;
        _swiperIndex = listUsuarioLenght - 1;
      });
    }
  }

  _buildControler() {
    print("onprres");
    _controller.next();
  }
}
