import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places_app/components/blur_container.dart';
import 'package:places_app/models/usuario_model.dart';
import 'package:places_app/pages/register_extra_page.dart';
import 'package:places_app/providers/push_notification_provider.dart';
import 'package:places_app/routes/arguments/register_extra_args.dart';
import 'package:places_app/routes/constantes.dart';

import 'package:places_app/routes/routes_generate.dart';

import 'package:places_app/services/google_signin_service.dart';
import 'package:places_app/services/user_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';

import '../const/const.dart';

class LoginPage extends StatefulWidget {
  String email;
  String password;
  LoginPage({this.email = "", this.password = ""});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggedIn = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  UserPreferences preferences = new UserPreferences();
  bool isSubmitting = false;
  AppState _appState;
  PushNotificationsPovider _pushNotificationProvider =
      PushNotificationsPovider();

  @override
  void initState() {
    if (widget.email.isNotEmpty && widget.password.isNotEmpty) {
      doLogin();
    }
    super.initState();
  }

  void doLogin() async {
    UserCredential user = await signIn(widget.email, widget.password, context);
    if (user != null) {
      preferences.email = _emailController.text;

      //Check user type
      Navigator.of(context).popAndPushNamed(homeRoute);
    }
  }

  Future<void> handleGoHome(
      {UserCredential userCredential = null, User user = null}) async {
    UserService userService = new UserService();
    if (userCredential != null && user == null) {
      //Caso para correo y contrasenia
      preferences.email = _emailController.text;
      preferences.tipoUsuario =
          await userService.checkTipousuario(_emailController.text);
      setSubmitting(false);
      _appState.isInvitado = false;
      Navigator.of(context).popAndPushNamed(homeRoute);
    } else if (userCredential == null && user != null) {
      //Caso para google
      Usuario userExtraData = await userService.getUsuario(user.email);
      //Si ya tiene informacion extra guardada en la nube
      if (userExtraData != null) {
        UserPreferences preferences = new UserPreferences();
        preferences.email = userExtraData.correo;
        preferences.numeroPoliza = userExtraData.seguro;
        preferences.telefonoPoliza = userExtraData.telefonoSeguro;
        preferences.tipoUsuario = userExtraData.tipoUsuario;
        setSubmitting(false);
        _appState.isInvitado = false;
        Navigator.of(context).popAndPushNamed(homeRoute);
      } else {
        //si no Debera llenarla
        final tokenPush = await _pushNotificationProvider.getToken();
        userExtraData = new Usuario(
            tipoUsuario: "normal",
            apellidoMaterno: "",
            apellidoPaterno: "",
            correo: user.email,
            licencia: "",
            nombre: user.displayName,
            placa: "",
            telefonoSeguro: "",
            seguro: "",
            tokenPush: tokenPush);
        await userExtraData.save(user.email);
        setSubmitting(false);
        Navigator.pushNamed(context, registerExtraRoute,
            arguments: RegisterExtraArgs(user.email, true));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => RegisterExtraPage(user.email,true)));
      }
    }
  }

  void setSubmitting(bool val) {
    setState(() {
      isSubmitting = val;
    });
  }

  void handleLoginEmailPassword() async {
    bool isExistUser = false;
    setSubmitting(true);
    if (!_formKey.currentState.validate()) {
      setSubmitting(false);
      return;
    }
    _formKey.currentState.save();
    
    
      UserCredential user = await signIn(
          _emailController.text, _passwordController.text, context);
      if (user != null) {
        await handleGoHome(userCredential: user);
      }
   
  }

  void handleLoginWithGoogle() async {
    User user = await GoogleSignInService.signInWithGoogle();
    await handleGoHome(user: user);
  }

  void _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CircularProgressIndicator(),
        );
      },
    );
  }

  // void handleLoginWithFacebook() async {
  //   UserCredential user = await FacebookSignInService.signInWithFacebook();
  //   await handleGoHome(userCredential: user);
  // }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    _appState = Provider.of<AppState>(context);
    final logo = Image.asset(
      "assets/images/logo.png",
      height: mq.size.height / 4,
    );

    final emailField = TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Ingrese su correo electrónico",
            labelText: "Correo Electrónico",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Ingrese su correo electrónico';
          }

          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Ingrese un correo electrónico valido';
          }

          return null;
        },
        onSaved: (String value) {
          _emailController.text = value;
        });

    final passwordField = Column(children: <Widget>[
      TextFormField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              hintText: "Ingrese su contraseña",
              labelText: "Contraseña",
              hintStyle: TextStyle(color: kBaseColor)),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Ingrese su contraseña';
            }

            return null;
          },
          onSaved: (String value) {
            _passwordController.text = value;
          }),
      Padding(padding: EdgeInsets.all(2.0)),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          MaterialButton(
            child: Text("Olvidé mi contraseña",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: kBaseColor)),
            onPressed: () {
              Navigator.of(context).popAndPushNamed('resetPassword');
            },
          )
        ],
      )
    ]);

    final fields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[emailField, passwordField],
    );

    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(25.0),
        color: kBaseColor,
        child: MaterialButton(
          minWidth: mq.size.width / 1.2,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Text("Iniciar Sesión",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          onPressed: handleLoginEmailPassword,
        ));

    final googleLoginButton = FloatingActionButton(
      heroTag: "fb",
      backgroundColor: kBaseColor,
      child: Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: handleLoginWithGoogle,
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        loginButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "¿Aún no tienes cuenta?",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed('register');
              },
              child: Text(
                "Registrarse",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: kBaseColor, decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Text(
                "Continuar como invitado",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: kBaseColor, decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            googleLoginButton,
            SizedBox(
              width: 10,
            ),
            Text(
              'Continuar con Google',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.black),
            )
          ],
        )
      ],
    );

    return Scaffold(
      body: BlurContainer(
        isLoading: isSubmitting,
        text: "Iniciando sesión",
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 36.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    logo,
                    fields,
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<UserCredential> signIn(
      String email, String password, BuildContext context) async {
    UserCredential result;
    String errorMessage;
    
    try {
      bool isExistUser = false;
      List<Usuario> usuarios = await Usuario.listUsers();
    usuarios.forEach((element) {
      if (element.correo == _emailController.text) {
        isExistUser= true;
        return;
      }
    });
    if(isExistUser == true){
       result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((onError) {
        print('ERRORRRRRRRR');
        print(onError);
        showAlert(context, 'Algo salio mal...', onError.toString());
        return null;
      });
    }else{
      showAlert(context, 'Algo salio mal...', "onError.toString()");
    }
     
    } catch (error) {
      errorMessage = error;
      print(errorMessage);
      return null;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return result;
  }

  Future<UserCredential> loginEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential user = (await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password));
      print(user);
      return user;
    } on PlatformException catch (err) {
      print('error platform $err');
    } on FirebaseAuthException catch (e) {
      showAlert(context, 'Algo salio mal...',
          'Verifique que su correo y/o contraseña sean correctos');
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      print('error $e');
      //_emailController.clear();
      _passwordController.clear();
      return null;
    }
  }

  void showAlert(BuildContext context, String title, String error) {
    var messageError;

    switch (error) {
      case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
        messageError =
            'Su correo electrónico no está vinculado a ninguna cuenta registrada.';
        break;
      default:
        messageError = 'Verifique su correo y contraseña';
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text(messageError)]),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('login', (route) => false),
                  child: Text('OK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kBaseColor)))
            ],
          );
        });
  }
}
