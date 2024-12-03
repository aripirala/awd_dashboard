// lib/farmers_module/models/location.dart
class Location {
  final double latitude;
  final double longitude;
  final String district;
  final String village;
  final String mandal;

  Location({
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.village,
    required this.mandal,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      district: json['district'] as String,
      village: json['village'] as String,
      mandal: json['mandal'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'district': district,
      'village': village,
      'mandal': mandal,
    };
  }
}
