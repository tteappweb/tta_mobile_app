import 'package:flutter/material.dart';
import 'package:places_app/const/const.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewComponent extends StatefulWidget {
  String url;

  WebViewComponent(@required this.url);

  @override
  _WebViewComponentState createState() => _WebViewComponentState();
}

class _WebViewComponentState extends State<WebViewComponent> {
  final controllerw = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  @override
  void initState() {
    super.initState();
    controllerw.loadRequest(Uri.parse(widget.url));
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBaseColor,
        title: Text("App Tu Taller Mecánico"),
      ),
      body: WebViewWidget(
        controller: controllerw,
      ),
    );
  }
}
