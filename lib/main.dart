import 'package:flutter/material.dart';
import 'package:geo_master_class/geo_master_class.dart';

void main() {
  runApp(const GeoMasterClassApp());
}

class GeoMasterClassApp extends StatelessWidget {
  const GeoMasterClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoMasterClass',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GeoMasterClass(),
    );
  }
}
