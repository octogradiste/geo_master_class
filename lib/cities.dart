import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class Coordinate {
  final double latitude;
  final double longitude;
  const Coordinate(this.latitude, this.longitude);

  double getX(int width) {
    return width * (longitude + 180) / 360;
  }

  double getY(int height) {
    return height * (1 - (latitude + 90) / 180);
  }
}

class Cities {
  static var isInitialized = false;
  static const converter = CsvToListConverter(fieldDelimiter: ';', eol: '\n');
  static late final Map<String, List<Coordinate>> cities;

  static Future<void> initialize() async {
    if (!isInitialized) {
      final file = await rootBundle.loadString("assets/data/cities.csv");
      final data = converter
          .convert(file)
          .skip(1)
          .map((list) => list.map((e) => e.toString()).toList());

      cities = {
        for (var row in data)
          row[0]: [
            for (final coordinate in row[1].split(','))
              Coordinate(
                double.parse(coordinate.split(':')[0]),
                double.parse(coordinate.split(':')[1]),
              ),
          ],
      };

      isInitialized = true;
    }
  }
}
