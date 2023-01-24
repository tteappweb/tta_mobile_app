import 'package:flutter/material.dart';
import 'package:places_app/models/tutoriales_model.dart';
import 'package:places_app/pages/tutorial/widgets/swiper_tutorial.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  List<Tutorial> tutorial = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  void initData() async {
    this.tutorial = await Tutorial.fetchData();
    this.tutorial.sort((a, b) => a.numeroSlide.compareTo(b.numeroSlide));
    print("tutorial");
    print(tutorial);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        Center(child: CircularProgressIndicator())
      ]);
    }

    return Scaffold(
      body: SwiperTutorial(listaTutorial: tutorial),
    );
  }
}
