import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class Coordinates {
  final double latitude;
  final double longitude;
  const Coordinates(this.latitude, this.longitude);

  int getX(double width) {
    return (width * (longitude + 180) / 360).round();
  }

  int getY(double height) {
    return (height * (1 - (latitude + 90) / 180)).round();
  }
}

class Cities {
  static var isInitialized = false;
  static const converter = CsvToListConverter(fieldDelimiter: ';', eol: '\n');
  static late final Map<String, List<Coordinates>> cities;

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
              Coordinates(
                double.parse(coordinate.split(':')[0]),
                double.parse(coordinate.split(':')[1]),
              ),
          ],
      };

      isInitialized = true;
    }
  }
}
