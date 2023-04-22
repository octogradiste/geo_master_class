import 'package:flutter/material.dart';

class GeoMasterClass extends StatelessWidget {
  const GeoMasterClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/world5400x2700.jpg',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
