# Farmers Dashboard Integration Guide

## Integration Steps

1. Add module to existing app:
```
your_app/
  lib/
    farmers_module/  <- Copy entire folder here
    other_modules/
    main.dart
```

2. Add required dependencies to pubspec.yaml:
```yaml
dependencies:
  flutter_map: ^6.0.1
  flutter_map_marker_cluster: ^1.3.0
  provider: ^6.0.5
  latlong2: ^0.9.0
  csv: ^5.0.1  # If using CSV data
```

3. Add route in your app's navigation:
```dart
MaterialApp(
  routes: {
    '/farmers': (context) => FarmersDashboardModule(),
    // other routes...
  },
);
```

## API Integration

Replace mock API with real API by updating `api_service.dart`:

```dart
class ApiService {
  final String baseUrl = 'YOUR_API_BASE_URL';

  Future<List<Farmer>> getFarmers({LatLngBounds? bounds}) async {
    try {
      final queryParams = bounds != null
        ? '?south=${bounds.south}&north=${bounds.north}&west=${bounds.west}&east=${bounds.east}'
        : '';

      final response = await http.get(Uri.parse('$baseUrl/farmers$queryParams'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Farmer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load farmers');
      }
    } catch (e) {
      throw Exception('Error fetching farmers: $e');
    }
  }
}
```

Expected API Response Format:
```json
[
  {
    "id": "F_111684735_70",
    "name": "Farmer Name",
    "location": {
      "latitude": 18.64471619,
      "longitude": 79.11731012,
      "district": "Karimnagar",
      "village": "Gopalraopet",
      "mandal": "Ramadugu"
    },
    "phase": 4
  }
]
```

## Data Requirements
- All latitude/longitude coordinates must be valid decimal numbers
- Phase must be an integer between 0-3
- All string fields (name, district, village, mandal) must be non-empty
- IDs must be unique

## Configuration
Configure base API URL in your app's environment config:
```dart
const apiBaseUrl = String.fromEnvironment('API_BASE_URL',
  defaultValue: 'http://localhost:8080/api');
```
