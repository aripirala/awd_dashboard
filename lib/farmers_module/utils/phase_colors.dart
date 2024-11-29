// lib/farmers_module/utils/phase_colors.dart
import 'package:flutter/material.dart';
import '../models/farmer.dart';

class PhaseColors {
  static const plotting = Color(0xFF87CEEB);
  static const pipeInstallation = Color(0xFFF4A387);
  static const dry1 = Color(0xFF98B4A6);
  static const dry2 = Color(0xFF9C89B8);

  // Define the order of phases
  static const List<FarmerPhase> phaseOrder = [
    FarmerPhase.plotting,
    FarmerPhase.pipe_installation,
    FarmerPhase.dry1,
    FarmerPhase.dry2,
  ];

  static String phaseName(FarmerPhase phase) {
    switch (phase) {
      case FarmerPhase.plotting:
        return 'Plotting';
      case FarmerPhase.pipe_installation:
        return 'Pipe Installation';
      case FarmerPhase.dry1:
        return 'Dry 1';
      case FarmerPhase.dry2:
        return 'Dry 2';
    }
  }

  static Color getColor(FarmerPhase phase) {
    switch (phase) {
      case FarmerPhase.plotting:
        return plotting;
      case FarmerPhase.pipe_installation:
        return pipeInstallation;
      case FarmerPhase.dry1:
        return dry1;
      case FarmerPhase.dry2:
        return dry2;
    }
  }
}
