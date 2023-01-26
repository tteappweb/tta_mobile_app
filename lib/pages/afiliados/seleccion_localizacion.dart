import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/entities.dart';
import 'package:place_picker/place_picker.dart';

import 'package:places_app/components/search_address_map.dart';


class SeleccionLocalizacion extends StatefulWidget {

  @override
  _SeleccionLocalizacionState createState() => _SeleccionLocalizacionState();
}

class _SeleccionLocalizacionState extends State<SeleccionLocalizacion> {
  @override
  Widget build(BuildContext context) {
    
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
                onPressed: () async{
                 LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCxyFsUuFODYNFkLSNabseR9_VAWX9u21Y",
              displayLocation: LatLng(19.3764253, -99.0573512),
            )));
                },
              ),
              
            ],
          ),
        )
      ); 
  }
}