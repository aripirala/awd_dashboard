// lib/farmers_module/models/farmer.dart

import 'location.dart';

enum FarmerPhase { plotting, pipe_installation, dry1, dry2, complete }

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
      id: json['id'] as String,
      name: json['name'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      phase: FarmerPhase.values[json['phase'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location.toJson(),
      'phase': phase.index,
    };
  }
}
