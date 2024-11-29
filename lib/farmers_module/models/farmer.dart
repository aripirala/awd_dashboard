// lib/farmers_module/models/farmer.dart
import 'location.dart';

enum FarmerPhase { plotting, pipe_installation, dry1, dry2 }

class Farmer {
  final String id;
  final String name;
  final Location location;
  final FarmerPhase phase;

  Farmer({
    required this.id,
    required this.name,
    required this.location,
    required this.phase,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      location: Location.fromJson(json['location']),
      phase: FarmerPhase.values[json['phase']],
    );
  }
}
