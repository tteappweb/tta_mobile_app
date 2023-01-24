import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:places_app/const/const.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/usuario_model.dart';
import 'package:places_app/pages/afiliados/afiliados_home.dart';
import 'package:places_app/pages/categories/index.dart';
import 'package:places_app/pages/historial_page.dart';
import 'package:places_app/pages/home_page.dart';
import 'package:places_app/routes/arguments/lista_vehiculos_args.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/routes/routes_generate.dart' as routes;
import 'package:places_app/services/afiliados_service.dart';
import 'package:places_app/shared/user_preferences.dart';

import 'package:flutter/scheduler.dart';

enum TipoUsuario {
  NORMAL,
  AFILIADO,
  INVITADO,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isChecking = false;
  UserPreferences preferences = new UserPreferences();
  TipoUsuario tipoUsuario = TipoUsuario.INVITADO;
  Usuario user = new Usuario();
  bool isOnline = false;
  int _selectedIndex = 0;

  AfiliadosService afiliadosService = new AfiliadosService();

  var connectivityResult;
  @override
  void initState() {
    super.initState();
    //cargarSuscripciones();
    //initData();
    checkTypeUser();
  }

  void initData() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isOnline = true;
    } else {
      isOnline = false;
    }
    setState(() {});
  }

  void checkTypeUser() async {
    setChecking(true);

    String tipoUsrStr = preferences.tipoUsuario;

    //El usuario es invitado
    /*  user = await user.fetchData(preferences.email);
      if (user != null) {
        tipoUsrStr = user.tipoUsuario;
      } */

    if (tipoUsrStr == 'afiliado') {
      _selectedIndex=0;
      tipoUsuario = TipoUsuario.AFILIADO;

      Afiliado a = await afiliadosService.getByUser(preferences.email);
      if (a != null) {
        preferences.nombreAfiliacion = a.nombre;
        preferences.afiliacionAprobada = a.aprobado;

        //`preferences.
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(registroAfilicacionRoute);
        });
      }
    } else if (tipoUsrStr == 'normal') {
      tipoUsuario = TipoUsuario.NORMAL;
    }
    setChecking(false);
  }

  void setChecking(bool val) {
    setState(() {
      isChecking = val;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    BottomNavigationBar bottomNavigationBar;
    List<Widget> pages = [];

    if (tipoUsuario == TipoUsuario.NORMAL) {

      setState(() {
       // _selectedIndex = 1;
      });
      
      pages = [
        HomePage(),
        CategoriesPage(),
        HistorialPage(),
      ];
      bottomNavigationBar = BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop, size: 20.0),
            label: "Servicios",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Historial",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kBaseColor,
        onTap: (val) {
          setState(() {
            _selectedIndex = val;
          });
        },
      );
    } else if (tipoUsuario == TipoUsuario.AFILIADO) {

      setState(() {
        //if(const)
         //_selectedIndex=0;
      });
    
      /*  if (preferences.nombreAfiliacion.toString().isEmpty) {
        Navigator.pushReplacementNamed(context, registroAfilicacion);
        return Container();
      } */

      pages = [
        AfiliadosHome(),
        HistorialPage(),
      ];
      bottomNavigationBar = BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Historial",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kBaseColor,
        onTap: (val) {
          setState(() {
            _selectedIndex = val;
          });
        },
      );
    } else {
      //Usuario invitado
      pages = [
        HomePage(),
        CategoriesPage(),
      ];

      bottomNavigationBar = BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop, size: 20.0),
            label: "Servicios",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kBaseColor,
        onTap: (val) {
          setState(() {
            _selectedIndex = val;
          });
        },
      );
    }

    return Scaffold(
      floatingActionButton:(tipoUsuario == TipoUsuario.AFILIADO)? null: FloatingActionButton(
        backgroundColor: kBaseColor,
        onPressed: () {
          Navigator.pushNamed(context, listaVehiculosRoute,arguments: ListaVehiculosArgs(preferences.email, false));
          //Navigator.pushNamed(context, queTePasoRoute);
        },
        child: Icon(Icons.error_outline,size: 40,),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ...pages,
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
  void cargarSuscripciones() { //Metodo para cargar preguntas en bruto -- no se utiliza en la app
    retonarListaPreguntas().forEach((element)async{
      await FirebaseFirestore.instance.collection('afiliados').add(element);
    });
  }
  
  
}



List<Map<String,dynamic>> retonarListaPreguntas(){
  List<Map<String,dynamic>> lista;
  lista = [
    {
    "id": "", 
    "nombre": "Mi comercio online", 
    "img": "https://res.cloudinary.com/jovannyrch/image/upload/v1630352585/gfqijhjw2msgct3sbuse.jpg", 
    "telefono": 5298000032, 
    "rfc": null, 
    "user": "mmartinez@gmail.com", 
    "total": 0, 
    "puntos": 0, 
    "rating": 0.0, 
    "aprobado": true, 
    "fotos": [
        "https://res.cloudinary.com/jovannyrch/image/upload/v1630352585/dopam3wk3zmvocbc7v2f.jpg", 
        "https://res.cloudinary.com/jovannyrch/image/upload/v1630352585/zmnomzj6u1cfgamd50ut.jpg"
    ],
    "categoria": "Mecánicos",
    "latitud": 23.286457, 
    "longitud": -106.38075, 
    "ubicacion": "Avistamiento, San Erico, 82274 Sin., Mexico"
}

  ];
  return lista;
}
