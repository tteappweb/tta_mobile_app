import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:places_app/const/const.dart';

class ItemTutorial extends StatefulWidget {
  final String title;
  final String message;
  final String img;

  final Function onPressed;

  const ItemTutorial(
      {Key key, this.title = "", this.message, this.onPressed, this.img})
      : super(key: key);

  @override
  _ItemTutorialState createState() => _ItemTutorialState();
}

class _ItemTutorialState extends State<ItemTutorial> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.8;
    double width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 15),
        child: Column(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                // image: DecorationImage(image:NetworkImage(widget.img),fit: BoxFit.cover),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    //Expanded(child: Container()),
                    const SizedBox(height: 10.0),
                    _buildLogo(),
                    const SizedBox(height: 10.0),
                    // Text(
                    //   this.widget.title.toUpperCase(),
                    //   style: TextStyle(
                    //       fontSize: 25,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Center(
                                child: Container()
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),

                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 1, right: 15),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
                width: 450,
                height: 450,
                child: FadeInImage(
                  image: NetworkImage(widget.img),
                  placeholder: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                  //width: double.infinity,
                )),
          ],
        ),
      ),
    );
  }
}
