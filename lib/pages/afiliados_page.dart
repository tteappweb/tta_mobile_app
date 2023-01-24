import 'dart:async';
import 'dart:collection';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/categoria_model.dart';
import 'package:places_app/models/ubicacion_afiliado_model.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/services/afiliados_service.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';

import 'afilidados_detail.dart';

CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
Completer<GoogleMapController> _controller = Completer();

class AfiliadosPage extends StatefulWidget {
  Categoria categoria;

  AfiliadosPage({this.categoria});
  @override
  _AfiliadosPageState createState() => _AfiliadosPageState();
}

class _AfiliadosPageState extends State<AfiliadosPage> {
  GoogleMapController _mapcontroller;
  AppState appState = new AppState();
  Location location = new Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool _serviceEnabled;
  bool isLoading = false;
  bool isLoadMarket = false;
  Set<Circle> circles = HashSet<Circle>();
  Set<Marker> _markets = HashSet<Marker>();
  Map<MarkerId, Marker> newMakers = <MarkerId, Marker>{};
  bool isInfoWindow = false;
  Afiliado a = Afiliado();
  List<UbicacionAfiliado> ubicacionAfiliados = [];
  List<Afiliado> afis = [];
  List<Afiliado> filterAfis = [];
  List<Afiliado> geocercaAfis = [];
  CustomInfoWindowController custom = CustomInfoWindowController();
  AfiliadosService afiliadosService = new AfiliadosService();
  @override
  void initState() {
    initUbicacion();
    init();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void compareInMeters() {
    // double meters = mp.SphericalUtil.computeDistanceBetween(
    //     mp.LatLng(_locationData.latitude, _locationData.longitude),
    //     mp.LatLng(-12.082385785979465, -77.06697146710043));
    for (var i = 0; i < _markets.length; i++) {}
    // _markets.forEach((element) {
    //   double beetwenMeters = mp.SphericalUtil.computeDistanceBetween(
    //       mp.LatLng(_locationData.latitude, _locationData.longitude),
    //       mp.LatLng(element.position.latitude, element.position.longitude));
    //   if (beetwenMeters.round() <= 4200000) {
    //     newMakers[element.markerId] = element;
    //     setState(() {});

    //     // newMakers.add(element.copyWith(visibleParam: false));
    //   }
    // });

    afis.forEach((element) {
      double beetwenMeters = mp.SphericalUtil.computeDistanceBetween(
          mp.LatLng(_locationData.latitude, _locationData.longitude), mp.LatLng(element.latitud, element.longitud));

      if (beetwenMeters.round() <= 4444000) {
        print("elements latitude");
        print(element.latitud);
        Marker mark = Marker(
          markerId: MarkerId(element.latitud.toString()+element.longitud.toString()+element.nombre),
          position: LatLng(element.latitud, element.longitud),
          onTap: () {
            a = element;
            isInfoWindow = true;
            setState(() {});
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        print("elements");
        print(element);
        print(mark.markerId);
        newMakers[mark.markerId] = mark;

        geocercaAfis.add(element);
        setState(() {});

        // newMakers.add(element.copyWith(visibleParam: false));
      }
    });
    print("mis markers==============");
    print(newMakers.length);
    setState(() {});
    print(_markets);
    print("=========================");
    print(newMakers);
    // print(meters.round());
  }

  void currentLocation() async {
    LocationData currentUser = await location.getLocation();

    compareInMeters();

    BitmapDescriptor iconu =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(5, 5), devicePixelRatio: 2.0), "assets/currentpin.png");
    Circle circle = Circle(
        circleId: CircleId("10000"),
        fillColor: Colors.blue.withOpacity(0.2),
        radius: 4444000,
        center: LatLng(currentUser.latitude, currentUser.longitude),
        strokeWidth: 2,
        strokeColor: Colors.blue.shade800.withOpacity(0.5));
    Marker userMaker = Marker(markerId: MarkerId("${10000}"), position: LatLng(currentUser.latitude, currentUser.longitude), icon: iconu);

    print(currentUser);
    circles.add(circle);
    newMakers[userMaker.markerId] = userMaker;
    setState(() {});
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      isLoading = false;
    });
  }

  void initUbicacion() async {
    location.changeSettings(accuracy: LocationAccuracy.high);
    afis = await afiliadosService.loadByCategoria(widget.categoria.nombre);

    currentLocation();
    afis.forEach((element) {
      _buildMarker(element);
    });
    // afis.forEach((element) {
    //   if (element.categoria == widget.categoria.nombre.trim()) {
    //     filterAfis.add(element);
    //   }
    // });
    // String categoriaTemporal = widget.categoria.nombre.trim();
    // this.ubicacionAfiliados =
    //     await UbicacionAfiliado.fetchData(categoriaTemporal);
    print("ubicacionAfiliados");
    print(filterAfis);
    print(ubicacionAfiliados);
    /*this.ubicacionAfiliados.asMap().entries.map((e) {
      _buildMarker(e.value);
      });*/

    setState(() {
      isLoadMarket = false;
    });
  }

  Size _size;

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria.nombre,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: SafeArea(
        child: Container(
          height: _size.height * .9,
          padding: EdgeInsets.only(bottom: 10.0),
          child: Stack(
            children: <Widget>[
              _mapContainer(),
              // ElevatedButton(
              //     onPressed: () {
              //       currentLocation();
              //     },
              //     child: Text("calcuadad")),

              Positioned(
                child: _afiliandosCarousel(),
                bottom: 5.0,
                left: _size.width * .05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerAfiliado(BuildContext context, Afiliado a) {
    String url;
    if (a.img != null) {
      url = a.img.contains("http") ? a.img : "https:" + a.img;
    } else {
      url = "assets/imgnotfound.png";
    }

    return GestureDetector(
      onTap: () {
        if (appState.isInvitado) {
          Navigator.pushNamed(context, loginRoute);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AfiliadosDetailsPage(afiliado: a)),
          );
        }
      },
      child: Container(
        height: 200,
        width: _size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
                height: 150.0,
                width: _size.width * 0.8,
                child: a.img == null ? Image.asset("assets/imgnotfound.png", fit: BoxFit.cover) : Image.network(url, fit: BoxFit.cover)),
            Container(
              padding: EdgeInsets.only(
                top: 5.0,
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      a.nombre,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Row(children: [
                    Icon(Icons.star, color: Colors.yellow[800]),
                    Text(
                      "${a.rating}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.grey.shade600,
                      ),
                    )
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _afiliandosCarousel() {
    return Container(
      decoration: BoxDecoration(),
      width: _size.width * .9,
      height: 200,
      child: ListView.builder(
          itemCount: geocercaAfis.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return _containerAfiliado(context, geocercaAfis[index]);
          }),
    );
  }

  Widget _mapContainer() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final lat = _locationData.latitude ?? 0.0;
    final long = _locationData.longitude ?? 0.0;

    return Container(
        height: _size.height * 0.6,
        child: Container(
            child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: 13.0),
              mapType: MapType.normal,
              onMapCreated: (controller) {
                custom.googleMapController = controller;
                _mapcontroller = controller;
              },
              circles: circles,
              onTap: (cordinate) {
                _mapcontroller.animateCamera(CameraUpdate.newLatLng(cordinate));
              },
              markers: Set.from(newMakers.values),
            ),
            if (isInfoWindow)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AfiliadosDetailsPage(afiliado: a)));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: 50,
                      height: 100,
                      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      "${a.nombre}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    Text("${a.ubicacion}")
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Image.network(
                                    "${a.img}",
                                    width: MediaQuery.of(context).size.width / 12,
                                    height: MediaQuery.of(context).size.height / 12,
                                  ))
                            ],
                          )
                        ],
                      )),
                ),
              )
            else
              SizedBox(),
            // ElevatedButton(
            //     onPressed: () {
            //       compareInMeters();
            //     },
            //     child: Text("meetter"))
          ],
        )));
  }

  _buildMarker(Afiliado ubicacion) {
    print(ubicacion);
    setState(() {
      _markets.add(Marker(
        markerId: MarkerId(ubicacion.nombre),
        position: LatLng(ubicacion.latitud, ubicacion.longitud),
        onTap: () {
          a = ubicacion;
          isInfoWindow = true;
          setState(() {});
        },
        // infoWindow: InfoWindow(
        //     title: "${ubicacion.nombre} \n ${ubicacion.ubicacion}",
        //     onTap: () {
        //       print(ubicacion.nombre);
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) =>
        //                   AfiliadosDetailsPage(afiliado: ubicacion)));
        //     }),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
  }
}

/* GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
          ), */
