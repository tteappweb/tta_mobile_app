import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places_app/pages/register_extra_page.dart';
import 'package:places_app/pages/vehiculos/lista_vehiculos.dart';
import 'package:places_app/routes/arguments/lista_vehiculos_args.dart';
import 'package:places_app/routes/arguments/register_extra_args.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/routes/routes_generate.dart';
import 'package:places_app/services/user_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';

import 'models/usuario_model.dart';

class MenuBar extends StatefulWidget {
  MenuBar();

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  UserPreferences preferences = new UserPreferences();
  UserService userService = UserService();
  AppState appState;
  Usuario usuario;

  @override
  Widget build(BuildContext context) {
    this.appState = Provider.of<AppState>(context);
    Map<String, dynamic> drawer = {
      "logo": "assets/images/logo.png",
      "background": null,
    };

    return Container(
      color: Colors.grey.shade100,
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height,
      child: Column(
        key: drawer['key'] != null ? Key(drawer['key']) : null,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (drawer['logo'] != null)
                      Center(
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 5),
                          child: imageContainer(drawer['logo']),
                        ),
                      ),
                    const Divider(),
                    SizedBox(height: 10),
                    Container(
                      child: Center(child: Text(preferences.email)),
                    ),
                    Container(
                      child: Center(child: Text(preferences.tipoUsuario)),
                    ),
                    SizedBox(height: 10),
                    _buidIsUsuarioNormal()
                        ? ListTile(
                            leading:
                                const Icon(FontAwesomeIcons.carAlt, size: 20),
                            title: Text("Vehículos"),
                            onTap: () {
                              Navigator.pushNamed(context, listaVehiculosRoute,
                                  arguments: ListaVehiculosArgs(
                                      preferences.email, true));
                            })
                        : Container(
                            child: null,
                          ),
                    ListTile(
                      leading: const Icon(Icons.pages, size: 20),
                      title: Text("Términos y condiciones"),
                      onTap: () => {
                        Navigator.pushNamed(context, terminosCondicionesRoute)
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip, size: 20),
                      title: Text("Avisos de privacidad"),
                      onTap: () => {
                        Navigator.pushNamed(context, avisosCondicionesRoute)
                      },
                    ),
                    SizedBox(height: 10),
                    _authWidget(),
                    SizedBox(height: 54),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _authWidget() {
    print(" es invitado: ${appState.isInvitado}");
    if (appState.isInvitado) {
      return ListTile(
        leading: const Icon(Icons.exit_to_app, size: 20),
        title: Text("Iniciar sesión"),
        onTap: handleLogin,
      );
    } else {
      return Column(
        children: [
          
          ListTile(
            leading: const Icon(Icons.exit_to_app, size: 20),
            title: Text("Eliminar cuenta"),
            onTap: () {
              FirebaseAuth au = FirebaseAuth.instance;
              var user = au.currentUser;
              user.delete().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false);
              }).catchError((onError) => print(onError));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, size: 20),
            title: Text("Cerrar sesión"),
            onTap: handleLogOut,
          ),
        ],
      );
    }
  }

  void handleLogin() {
    Navigator.pushNamed(context, loginRoute);
  }

  void handleLogOut() {
    preferences.clearPreference();
    appState.isInvitado = true;
    Navigator.pushReplacementNamed(context, loginRoute);
  }

  Widget imageContainer(String link) {
    if (link.contains('http://') || link.contains('https://')) {
      return Image.network(
        link,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      link,
      fit: BoxFit.cover,
    );
  }

  Future<bool> _buildCompletarRegistro() async {
    usuario = new Usuario();
    usuario = await userService.getUsuario(preferences.email);
    if (usuario == null) {
      return true;
    } //Si se borra el registro desde Firebase
    if (usuario.licencia.length == 0 || usuario.fechaPagoTenencia.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  _buidIsUsuarioNormal() {
    String tipoUsuario = preferences.tipoUsuario;

    if (preferences.isLogged) {
      if (tipoUsuario.compareTo("normal") == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
