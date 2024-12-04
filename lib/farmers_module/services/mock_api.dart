import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/farmer.dart';
import 'package:csv/csv.dart';
import '../models/location.dart';

class MockApi {
  static const int pageSize = 1000;
  List<Farmer>? _allFarmers;
  Map<String, List<Farmer>> _boundsCacheMap = {};

  String _getBoundsCacheKey(LatLngBounds bounds) {
    return '${bounds.south.toStringAsFixed(2)}_${bounds.north.toStringAsFixed(2)}_${bounds.west.toStringAsFixed(2)}_${bounds.east.toStringAsFixed(2)}';
  }

  Future<List<Farmer>> getFarmers({LatLngBounds? bounds}) async {
    try {
      if (_allFarmers == null) {
        final csvData =
            await rootBundle.loadString('lib/farmers_module/data/farmers.csv');
        _allFarmers = await _parseCsvDataToFarmers(csvData);
      }

      if (bounds == null) return List<Farmer>.from(_allFarmers!);

      final cacheKey = _getBoundsCacheKey(bounds);
      if (_boundsCacheMap.containsKey(cacheKey)) {
        return _boundsCacheMap[cacheKey]!;
      }

      final filteredFarmers = _allFarmers!.where((farmer) {
        return farmer.location.latitude >= bounds.south &&
            farmer.location.latitude <= bounds.north &&
            farmer.location.longitude >= bounds.west &&
            farmer.location.longitude <= bounds.east;
      }).toList();

      _boundsCacheMap[cacheKey] = filteredFarmers;
      return filteredFarmers;
    } catch (e) {
      print('Error in MockApi: $e');
      return [];
    }
  }

  Future<List<Farmer>> _parseCsvDataToFarmers(String csvData) async {
    final List<List<dynamic>> csvRows =
        const CsvToListConverter().convert(csvData);
    final List<Farmer> farmers = [];

    for (int i = 1; i < csvRows.length; i++) {
      try {
        final row = csvRows[i];
        final farmer = Farmer(
          id: row[5] as String,
          name: row[6] as String,
          location: Location(
            latitude: row[8] as double,
            longitude: row[7] as double,
            district: row[2] as String,
            village: row[4] as String,
            mandal: row[3] as String,
          ),
          phase: FarmerPhase.values[row[9] as int],
        );
        farmers.add(farmer);
      } catch (e) {
        print('Error parsing row $i: $e');
        continue;
      }
    }
    return farmers;
  }
}
