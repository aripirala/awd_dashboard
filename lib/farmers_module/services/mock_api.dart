import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
import 'package:flutter/services.dart';
// import 'package:latlong2/latlong.dart';
import '../models/farmer.dart';
import 'package:csv/csv.dart';
import '../models/location.dart';

class MockApi {
  // final Random _random = Random();

  Future<List<Map<String, dynamic>>> getFarmers() async {
    // Load the CSV data from the file
    final csvData =
        await rootBundle.loadString('lib/farmers_module/data/farmers.csv');

    // Parse the CSV data into a list of Farmer objects
    final farmers = await _parseCsvDataToFarmers(csvData);
    // Convert the list of Farmer objects to a list of Maps
    return farmers.map((farmer) => farmer.toJson()).toList();
  }

  // Future<List<Farmer>> _parseCsvDataToFarmers(String csvData) async {
  //   final List<List<dynamic>> csvRows =
  //       const CsvToListConverter().convert(csvData);
  //   final List<Farmer> farmers = [];

  //   for (int i = 1; i < csvRows.length; i++) {
  //     // Skip the header row
  //     final row = csvRows[i];
  //     final farmerId = row[5] as String;
  //     final farmerName = row[6] as String;
  //     final latitude = double.parse(row[7]);
  //     final longitude = double.parse(row[8]);
  //     final district = row[2] as String;
  //     final village = row[4] as String;
  //     final mandal = row[3] as String;
  //     final phaseIndex = int.parse(row[9] as String);
  //     final farmerPhase = FarmerPhase.values[phaseIndex];

  //     final farmer = Farmer(
  //       id: farmerId,
  //       name: farmerName,
  //       location: Location(
  //         latitude: latitude,
  //         longitude: longitude,
  //         district: district,
  //         mandal: mandal,
  //         village: village,
  //       ),
  //       phase: farmerPhase,
  //     );
  //     farmers.add(farmer);
  //   }

  //   return farmers;
  // }
  Future<List<Farmer>> _parseCsvDataToFarmers(String csvData) async {
    final List<List<dynamic>> csvRows =
        const CsvToListConverter().convert(csvData);
    final List<Farmer> farmers = [];

    for (int i = 1; i < csvRows.length; i++) {
      // Skip the header row
      final row = csvRows[i];
      final farmerId = row[5] as String;
      final farmerName = row[6] as String;
      final latitude = row[8] as double;
      final longitude = row[7] as double;
      final district = row[2] as String;
      final village = row[4] as String;
      final mandal = row[3] as String;
      final phaseIndex = row[9] as int;
      final farmerPhase = FarmerPhase.values[phaseIndex];

      final farmer = Farmer(
        id: farmerId,
        name: farmerName,
        location: Location(
          latitude: latitude,
          longitude: longitude,
          district: district,
          village: village,
          mandal: mandal,
        ),
        phase: farmerPhase,
      );
      farmers.add(farmer);
    }

    return farmers;
  }
}
