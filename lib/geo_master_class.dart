import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'cities.dart';

const EARTH_CIRCUMFERENCE = 40075; // in km
const RADIUS = 200; // in km

class GeoMasterClass extends StatefulWidget {
  const GeoMasterClass({Key? key}) : super(key: key);

  @override
  State<GeoMasterClass> createState() => _GeoMasterClassState();
}

class _GeoMasterClassState extends State<GeoMasterClass> {
  final Set<String> cities = {};
  final Set<Coordinate> coordinates = {};
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Cities.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onChanged: (value) {
                final city = value.toLowerCase();
                if (!cities.contains(city) && Cities.cities.containsKey(city)) {
                  controller.clear();
                  setState(() {
                    coordinates.addAll(Cities.cities[city]!);
                    cities.add(city);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<ui.Image>(
                future: loadImage(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final image = snapshot.requireData;
                    return InteractiveViewer(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: image.width.toDouble(),
                          height: image.height.toDouble(),
                          child: CustomPaint(
                            painter: CityPainter(
                              image: image,
                              coordinates: coordinates,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ui.Image> loadImage() async {
    final data = await rootBundle.load('assets/images/world5400x2700.jpg');
    return decodeImageFromList(data.buffer.asUint8List());
  }
}

class CityPainter extends CustomPainter {
  final ui.Image image;
  final Set<Coordinate> coordinates;

  const CityPainter({
    required this.image,
    required this.coordinates,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());

    final paint = Paint();
    paint.color = Colors.red.withAlpha(150);
    for (var coordinate in coordinates) {
      final x = coordinate.getX(image.width);
      final y = coordinate.getY(image.height);
      final offset = Offset(x, y);
      final radius = RADIUS * image.width / EARTH_CIRCUMFERENCE;
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
