import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:places_app/models/terminosModelo.dart';
import 'package:places_app/services/terminosCondionesService.dart';

class   TerminosCondiciones extends StatefulWidget {

  @override
  _TerminosCondicionesState createState() => _TerminosCondicionesState();
}

class _TerminosCondicionesState extends State<TerminosCondiciones> {
  TerminosCondicionesService terminos = new TerminosCondicionesService();
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  loadDocument(String direccion) async {
    //document = await PDFDocument.fromAsset('assets/terminos-condiciones-app.pdf');
    //document = await PDFDocument.fromURL('https://firebasestorage.googleapis.com/v0/b/tta-app-2c708.appspot.com/o/Terminos%20y%20Condiciones%2Fterminos-condiciones-app.pdf?alt=media&token=1027a3a8-93da-42db-bb6a-4b6f280e2548');
    document = await PDFDocument.fromURL(direccion);
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
      ),
      // body:  _isLoading
      //         ? Center(child: CircularProgressIndicator())
      //         : PDFViewer(
      //             document: document,
      //             scrollDirection: Axis.vertical,
      //             showPicker: false,
      //             zoomSteps:2,)
      body: FutureBuilder<List<TerminosModel>>(
        future: terminos.getTerminos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(_isLoading){
              loadDocument(snapshot.data[0].texto);
            }
            return _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                scrollDirection: Axis.vertical,
                
                showPicker: false,
                zoomSteps:2,);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  
}