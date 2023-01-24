import 'package:flutter/material.dart';
import 'package:places_app/const/const.dart';



class ChilangosButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color textColor;
  final bool enabled;
  final EdgeInsets padding;


  const ChilangosButton({Key key, this.label, this.onPressed, this.textColor, this.enabled=true, this.padding}) : super(key: key);

  @override
  _ChilangosButtonState createState() => _ChilangosButtonState();
}

class _ChilangosButtonState extends State<ChilangosButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      padding: widget.padding,
      elevation: elevation,
      child: Text(
        widget.label,
        style: TextStyle(
          fontFamily: 'RiftSoft',
          fontSize: 18, 
          color: widget.textColor??Colors.white,
        ),
      ),
      color: kBaseColor,
      onPressed: widget.enabled? widget.onPressed:null,
    );;
  }
}

  /*final String label;
  final VoidCallback onPressed;
  final MaterialColor color;
  final Color textColor;
  final EdgeInsets padding;
  final bool enabled;

  const ChilangosButton({this.label, this.onPressed, this.color, this.textColor, this.padding, Key key, this.enabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      padding: padding,
      elevation: UiTheme.elevation,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'RiftSoft',
          fontSize: 18, 
          color: textColor??Colors.white,
        ),
      ),
      color: userType ==UserTypeEnum.Veterinario? UiTheme.secondColor:UiTheme.primaryColor,
      onPressed: enabled? onPressed:null,
    );
  }*/