// lib/farmers_module/services/mock_api.dart
import 'dart:async';
import 'dart:math';
import '../models/farmer.dart';

class MockApi {
  final Random _random = Random();

  // District data structure
  final Map<String, Map<String, dynamic>> _districtData = {
    'Karimnagar': {
      'center': const LatLng(18.4386, 79.1288),
      'villages': {
        'Manakondur': const LatLng(18.4517, 79.0947),
        'Thimmapur': const LatLng(18.4234, 79.1756),
        'Rajanna': const LatLng(18.3989, 79.1547),
        'Chandurthi': const LatLng(18.4789, 79.0834),
        'Gambhiraopet': const LatLng(18.4123, 79.1678),
      }
    },
    'Warangal': {
      'center': const LatLng(18.0000, 79.5833),
      'villages': {
        'Dharmasagar': const LatLng(17.9856, 79.5634),
        'Hasanparthy': const LatLng(18.0234, 79.5923),
        'Elkathurthi': const LatLng(18.0123, 79.5445),
        'Shayampet': const LatLng(17.9789, 79.6012),
        'Wardhannapet': const LatLng(18.0345, 79.5567),
      }
    }
  };

  // Generate coordinates within 3km radius of village center
  LatLng _generateNearbyCoordinate(LatLng center) {
    // 0.027 degrees is approximately 3km at these latitudes
    double radius = 0.027;
    double ang = _random.nextDouble() * 2 * pi;
    double rad = _random.nextDouble() * radius;

    return LatLng(
      center.latitude + rad * cos(ang),
      center.longitude + rad * sin(ang),
    );
  }

  String _generateFarmerName() {
    final firstNames = [
      'Raj',
      'Krishna',
      'Venkat',
      'Srinu',
      'Ramesh',
      'Suresh',
      'Naresh',
      'Mahesh',
      'Raju',
      'Prakash'
    ];
    final lastNames = [
      'Reddy',
      'Rao',
      'Goud',
      'Naidu',
      'Kumar',
      'Achari',
      'Sharma',
      'Varma',
      'Chari',
      'Prasad'
    ];
    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }

  Future<List<Map<String, dynamic>>> getFarmers() async {
    await Future.delayed(Duration(seconds: 1));
    List<Map<String, dynamic>> farmers = [];
    int farmerId = 0;

    _districtData.forEach((district, districtInfo) {
      Map<String, LatLng> villages =
          Map<String, LatLng>.from(districtInfo['villages']);

      villages.forEach((village, centerCoord) {
        // Generate 50 farmers per village
        int farmersPerVillage = 50;
        for (int i = 0; i < farmersPerVillage; i++) {
          LatLng farmerCoord = _generateNearbyCoordinate(centerCoord);
          farmers.add({
            "id": (farmerId++).toString(),
            "name": _generateFarmerName(),
            "location": {
              "latitude": farmerCoord.latitude,
              "longitude": farmerCoord.longitude,
              "district": district,
              "village": village,
            },
            // Distribute phases somewhat evenly but with randomness
            "phase": _random.nextInt(4),
          });
        }
      });
    });

    return farmers;
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}
