import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places_app/components/blur_container.dart';
import 'package:places_app/const/const.dart';
import 'package:places_app/models/vehiculo_model.dart';
import 'package:places_app/pages/register_extra_page.dart';
import 'package:places_app/routes/arguments/quetepaso_args.dart';
import 'package:places_app/routes/arguments/register_extra_args.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/services/vehiculo_service.dart';

class ListaVehiculos extends StatefulWidget {
  final String email;
  final bool isEdit;

  const ListaVehiculos(this.email, this.isEdit);
  @override
  _ListaVehiculosState createState() => _ListaVehiculosState();
}

class _ListaVehiculosState extends State<ListaVehiculos> {
  List<VehiculoModel> listaVehiculos = [];
  List<QueryDocumentSnapshot> listaVehiculosDoc = [];
  VehiculoService vehiculoService = VehiculoService();
  bool isSubmitting = false;
  String idDeleteVehiculo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Vehículos'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, registerExtraRoute,arguments: RegisterExtraArgs(widget.email, true));
          },
          label: Text('Agregar'),
          icon: Icon(FontAwesomeIcons.plus),
          backgroundColor: kBaseColor,
      ) ,
      body: BlurContainer(
        isLoading: isSubmitting,
        children: [
          Container(
            child: FutureBuilder<List<QueryDocumentSnapshot >>(
              future: vehiculoService.getVehiculosPorEmail(widget.email),
              builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot >> snapshot) {
                if (snapshot.hasData) {
                  listaVehiculosDoc = snapshot.data;
                  listaVehiculos = [];
                  snapshot.data.forEach((element) {
                    listaVehiculos.add(VehiculoModel.fromJson(element.data()));
                  });
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(height: 3,);
                    },
                    itemCount: listaVehiculos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: ListTile(
                          onTap: (){
                            if (widget.isEdit) {
                              Navigator.pushNamed(context, registerExtraRoute,arguments: RegisterExtraArgs(widget.email, false,placa:listaVehiculos[index].placa ));
                            } else {
                              Navigator.pushNamed(context, queTePasoRoute,arguments: QueTePasoArgs(listaVehiculos[index]));
                            }
                          },
                          title: Text(listaVehiculos[index].placa),
                          leading: Icon(FontAwesomeIcons.car),
                          trailing: options(listaVehiculos[index],listaVehiculosDoc[index].id),
                          subtitle: Text('Placa'),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget options(VehiculoModel vehiculo,String id){
    return  PopupMenuButton(
      icon: Icon(FontAwesomeIcons.ellipsisV),
      itemBuilder: (BuildContext context) =>
        <PopupMenuEntry>[
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(FontAwesomeIcons.trash)
                ),
                Expanded(child: Text('Eliminar',)),
              ],
            ),
          ),
        ],
      onSelected: (result) {
        if (result == 'delete') {
          mensajeEliminar(vehiculo,id);
        }
      },
    );
  }

  void mensajeEliminar(VehiculoModel vehiculo,String id){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Desea eliminar el vehículo'),
          content: Text(vehiculo.placa,textAlign: TextAlign.center,),
          actions: <Widget>[
            FlatButton(
              onPressed: () async{
                Navigator.of(context).pop();
                setState(() {isSubmitting=true;});
                await vehiculoService.deleteVehiculo(id);
                setState(() {isSubmitting=false;});
               },
              child: Text('Sí',style: TextStyle(fontWeight: FontWeight.bold, color: kBaseColor))
            ),
            FlatButton(
              onPressed: () {Navigator.of(context).pop();},
              child: Text('No',style: TextStyle(fontWeight: FontWeight.bold, color: kBaseColor))
            ),
          ],
        );
      }
    );
  }
}