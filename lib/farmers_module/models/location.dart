// lib/models/location.dart
class Location {
  final double latitude;
  final double longitude;
  final String district;
  final String village;

  Location({
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.village,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
      district: json['district'],
      village: json['village'],
    );
  }
}
