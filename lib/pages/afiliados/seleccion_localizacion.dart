import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/google_map_location_picker.dart';

import 'package:places_app/components/search_address_map.dart';

class SeleccionLocalizacion extends StatefulWidget {
  @override
  _SeleccionLocalizacionState createState() => _SeleccionLocalizacionState();
}

class _SeleccionLocalizacionState extends State<SeleccionLocalizacion> {
  @override
  Widget build(BuildContext context) {
    LocationResult selectedPlace;
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picer Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text("Load Google Map"),
                onPressed: () async {
                  LocationResult result = await showLocationPicker(context, "AIzaSyC0FbqGD59m5uHTgESmlPZY1g6U8VxrZDo",
                      myLocationButtonEnabled: true,
                      searchBarBoxDecoration: BoxDecoration(backgroundBlendMode: BlendMode.color, color: Colors.white));
                  selectedPlace = result;
                 
                },
              ),
            ],
          ),
        ));
  }
}
