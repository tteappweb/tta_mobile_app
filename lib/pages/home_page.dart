//import 'dart:html';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:places_app/components/afiliados_slider.dart';
import 'package:places_app/components/noticias_slider.dart';
import 'package:places_app/components/search_address_map.dart';
import 'package:places_app/components/web_view.dart';

import 'package:places_app/menu.dart';
import 'package:places_app/models/anuncio.model.dart';
import 'package:places_app/models/vehiculo_model.dart';
import 'package:places_app/providers/push_notification_provider.dart';
import 'package:places_app/services/afiliados_service.dart';
import 'package:places_app/services/vehiculo_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Anuncio> anuncios = [];
  bool isLoading = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Size _size;
  AfiliadosService a = new AfiliadosService();
  VehiculoService vehiculoService = new VehiculoService();
  UserPreferences preferences = new UserPreferences();
  PushNotificationsPovider noti = new PushNotificationsPovider();
  AppState appState = new AppState();

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  getUsuarioVehiculos() async {
    List<VehiculoModel> vehiculos = await vehiculoService.loadVehiculo(preferences.email);
    print(vehiculos);
    int now = DateTime.now().year;
    print(now);
    vehiculos.forEach((element) {
      print("mi fecha es =============");
      print(DateTime.parse(element.fechaVencimientoLicencia));
      print(element.fechaVencimientoPoliza);
      if (DateTime.parse(element.fechaVencimientoLicencia).isBefore(DateTime.now())) {
        noti.showNotification(Random().nextInt(10000), "Vencimiento de licencia", "Vehiculo con placa: ${element.placa} \n porfavor renovarlo");
      }
      if (DateTime.parse(element.fechaVencimientoPoliza).isBefore(DateTime.now())) {
        noti.showNotification(Random().nextInt(10000), "Vencimiento de poliza", "Vehiculo con placa: ${element.placa} \n porfavor renovarlo");
      }
      if (DateTime.parse(element.vencimientoTarjetaCirculacion).isBefore(DateTime.now())) {
        noti.showNotification(Random().nextInt(10000), "Vencimiento de circulación", "Vehiculo con placa: ${element.placa} \n porfavor renovarlo");
      }
      if (DateTime.parse(element.vencimientoVerificacio).isBefore(DateTime.now())) {
        noti.showNotification(Random().nextInt(10000), "Vencimiento de verificación", "Vehiculo con placa: ${element.placa} \n porfavor renovarlo");
      }
      if (DateTime.parse(element.fechaPagoTenencia).isBefore(DateTime.now())) {
        noti.showNotification(Random().nextInt(10000), "Vencimiento de pago tenencia", "Vehiculo con placa: ${element.placa} \n porfavor renovarlo");
      }
    });
  }

  void initData() async {
    this.anuncios = await Anuncio.fetchData();

    print(anuncios);
    getUsuarioVehiculos();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    _size = MediaQuery.of(context).size;
    final arg = ModalRoute.of(context).settings.arguments;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    print('Mensaje recibido desde notificacion $arg');

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: MenuBar(),
      body: _stack(),
    );
  }

  Widget _stack() {
    return Stack(
      children: <Widget>[
        _body(),
        Positioned(
          left: 10,
          top: 25,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(200.0),
            ),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState.openDrawer(),
              /* onPressed: () => showMaterialModalBottomSheet(
  context: context,
  builder: (context) => SearchAddressMap(),
)*/
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       a.editByCategoria();
            //     },
            //     child: Text("editar")),
            SizedBox(height: 25.0),
            _publicidad(),
            SizedBox(height: 25.0),
            _title("Servicios"),
            AfiliadosCarousel(),
            SizedBox(height: 5.0),
            _title("Contenido"),
            NoticiasSlider(),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.3,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
    );
  }

  Widget _publicidad() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      height: _size.height < 100 ? _size.height * 0.25 : 250.0,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Center(
                child: new Image.network(
                  anuncios[index].imagen,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white60,
                                shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
                              ),
                                
                                child: Row(
                                  children: [
                                    Text('Ver')
                                    // })
                                  ],
                                ),
                                onPressed: () {
                                  if (anuncios[index].link.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => WebViewComponent(anuncios[index].link)),
                                    );
                                  }
                                }

                                //                         child: IconButton(
                                // icon: Icon(Icons.add,size: 20,color: Colors.redAccent,),
                                // onPressed: () {
                                //   if (anuncios[index].link.isNotEmpty) {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               WebViewComponent(
                                //                   anuncios[index].link)),
                                //     );
                                //   }
                                // }),
                                )),
                      )
                    ],
                  ),
                ],
              )
            ],
          );
        },
        autoplay: true,
        itemCount: anuncios.length,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
