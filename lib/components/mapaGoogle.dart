import 'dart:collection';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/ubicacion_afiliado_model.dart';
import 'package:places_app/pages/afilidados_detail.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:places_app/services/afiliados_service.dart';

class MapaGoogleComponent extends StatefulWidget {
  final String categoria;

  const MapaGoogleComponent({Key key, @required this.categoria})
      : super(key: key);
  @override
  _MapaGoogleComponentState createState() => _MapaGoogleComponentState();
}

class _MapaGoogleComponentState extends State<MapaGoogleComponent> {
  GoogleMapController _controller;

  Location location = new Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool _serviceEnabled;
  AfiliadosService afiliadosService = new AfiliadosService();
  bool isLoading = false;
  bool isLoadMarket = false;
  Set<Circle> circles = HashSet<Circle>();
  Set<Marker> _markets = HashSet<Marker>();
  Map<MarkerId, Marker> newMakers = <MarkerId, Marker>{};
  bool isInfoWindow = false;
  Afiliado a = Afiliado();
  List<UbicacionAfiliado> ubicacionAfiliados = [];

  @override
  void initState() {
    initUbicacion();
    init();
    super.initState();
  }

  List<Afiliado> afis = [];
  List<Afiliado> filterAfis = [];
  CustomInfoWindowController custom = CustomInfoWindowController();
  void compareInMeters() {
    // double meters = mp.SphericalUtil.computeDistanceBetween(
    //     mp.LatLng(_locationData.latitude, _locationData.longitude),
    //     mp.LatLng(-12.082385785979465, -77.06697146710043));
    for (var i = 0; i < _markets.length; i++) {}
    _markets.forEach((element) {
      double beetwenMeters = mp.SphericalUtil.computeDistanceBetween(
          mp.LatLng(_locationData.latitude, _locationData.longitude),
          mp.LatLng(element.position.latitude, element.position.longitude));
      if (beetwenMeters.round() <= 3421000) {
        newMakers[element.markerId] = element;

        // newMakers.add(element.copyWith(visibleParam: false));
      }
    });
    setState(() {});
    print(_markets);
    print("=========================");
    print(newMakers);
    // print(meters.round());
  }

  void currentLocation() async {
    LocationData currentUser = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      compareInMeters();
    });
    BitmapDescriptor iconu = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(5, 5), devicePixelRatio: 2.0),
        "assets/currentpin.png");
    Circle circle = Circle(
        circleId: CircleId("10000"),
        fillColor: Colors.blue.withOpacity(0.2),
        radius: 3421000,
        center: LatLng(currentUser.latitude, currentUser.longitude),
        strokeWidth: 5,
        strokeColor: Colors.blue.shade800.withOpacity(0.5));
    Marker userMaker = Marker(
        markerId: MarkerId("${10000}"),
        position: LatLng(currentUser.latitude, currentUser.longitude),
        icon: iconu);

    print(currentUser);
    circles.add(circle);
    newMakers[userMaker.markerId] = userMaker;
    setState(() {});
  }

  void initUbicacion() async {
    location.changeSettings(accuracy: LocationAccuracy.high);
    afis = await afiliadosService.loadByCategoria(widget.categoria);
    
    afis.forEach((element) {
      if (element.categoria == widget.categoria.trim()) {
        filterAfis.add(element);
      }
    });
    String categoriaTemporal = widget.categoria.trim();
    this.ubicacionAfiliados =
        await UbicacionAfiliado.fetchData(categoriaTemporal);
    print("ubicacionAfiliados");
    print(filterAfis);
    print(ubicacionAfiliados);
    /*this.ubicacionAfiliados.asMap().entries.map((e) {
      _buildMarker(e.value);
      });*/
    this.filterAfis.forEach((element) {
      _buildMarker(element);
    });
    setState(() {
      isLoadMarket = false;
    });
    currentLocation();
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final lat = _locationData.latitude ?? 0.0;
    final long = _locationData.longitude ?? 0.0;
    return Container(
        child: Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(lat, long), zoom: 13.0),
          mapType: MapType.normal,
          onMapCreated: (controller) {
            custom.googleMapController = controller;
            _controller = controller;
          },
          circles: circles,
          onTap: (cordinate) {
            _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AfiliadosDetailsPage(afiliado: a)));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: 50,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10)),
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
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
    ));
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
