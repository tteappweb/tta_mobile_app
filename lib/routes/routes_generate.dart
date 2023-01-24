import 'package:flutter/material.dart';
import 'package:places_app/pages/tutorial/avisos_privacidad.dart';
import 'package:places_app/routes/arguments/lista_vehiculos_args.dart';
import 'package:places_app/routes/arguments/quetepaso_args.dart';
import 'package:places_app/routes/arguments/register_extra_args.dart';
//Constants
import 'package:places_app/routes/constantes.dart';
//Views
import 'package:places_app/pages/afiliados/registro_afiliacion.dart';
import 'package:places_app/pages/categories/index.dart';
import 'package:places_app/pages/login_page.dart';
import 'package:places_app/pages/quetepaso/quetepaso.dart';
import 'package:places_app/pages/register_extra_page.dart';
import 'package:places_app/pages/reset_password_page.dart';
import 'package:places_app/pages/register_page.dart';
import 'package:places_app/pages/tutorial/terminos_condiciones.dart';
import 'package:places_app/pages/tutorial/tutorial_page.dart';
import 'package:places_app/pages/vehiculos/lista_vehiculos.dart';
//Argumnets
import 'package:places_app/screens/home_screen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_)=> HomeScreen());
      
      case loginRoute:
        return MaterialPageRoute(builder: (_)=> LoginPage());
      
      case registerRoute:
        return MaterialPageRoute(builder: (_)=> RegisterPage());

      case registerExtraRoute:
        if (args is RegisterExtraArgs) {
          return MaterialPageRoute(builder: (_)=> RegisterExtraPage(args.emailArg,args.isNew,placa: args.placa,));
        } else {return _errorRoute();}
      break;
        
      case tutorialRoute:
        return MaterialPageRoute(builder: (_)=> TutorialPage());
      
      case categoriasRoute:
        return MaterialPageRoute(builder: (_)=> CategoriesPage());
      
      case registroAfilicacionRoute:
        return MaterialPageRoute(builder: (_)=> RegistroAfiliacion());
      
      case resetPasswordRoute:
        return MaterialPageRoute(builder: (_)=> ResetPasswordPage());
      
      case queTePasoRoute:
      if (args is QueTePasoArgs) {
        return MaterialPageRoute(builder: (_)=> QueTePasoPage(args.vehiculo)); 
      } else {return _errorRoute();}
      break;
      
      case terminosCondicionesRoute:
        return MaterialPageRoute(builder: (_)=> TerminosCondiciones());

      case avisosCondicionesRoute:
        return MaterialPageRoute(builder: (_)=> AvisosPrivacidad());

      case listaVehiculosRoute:
        if (args is ListaVehiculosArgs) {
          return MaterialPageRoute(builder: (_)=> ListaVehiculos(args.email,args.isEdit));
        } else {return _errorRoute();}
      break;
      
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text('Error de ruta'),
        ),
        body: Center(
          child: Text('Error al cargar la página, revisar route_generate.dart'),
        ),
      );
    });
  }
}
