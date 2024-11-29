// lib/farmers_module/providers/farmer_provider.dart
import 'package:flutter/foundation.dart';
import '../models/farmer.dart';
import '../services/api_service.dart';

class FarmerProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Private state variables
  List<Farmer> _farmers = [];
  Set<String> _selectedDistricts = {};
  Set<String> _selectedVillages = {};
  Set<FarmerPhase> _selectedPhases = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Farmer> get farmers => _farmers;
  Set<String> get selectedDistricts => _selectedDistricts;
  Set<String> get selectedVillages => _selectedVillages;
  Set<FarmerPhase> get selectedPhases => _selectedPhases;

  List<Farmer> get filteredFarmers {
    return _farmers.where((farmer) {
      if (_selectedDistricts.isNotEmpty &&
          !_selectedDistricts.contains(farmer.location.district)) {
        return false;
      }
      if (_selectedVillages.isNotEmpty &&
          !_selectedVillages.contains(farmer.location.village)) {
        return false;
      }
      if (_selectedPhases.isNotEmpty &&
          !_selectedPhases.contains(farmer.phase)) {
        return false;
      }
      return true;
    }).toList();
  }

  // Data fetching
  Future<void> fetchFarmers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final farmers = await _apiService.getFarmers();
      _farmers = farmers;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // District methods
  void toggleDistrict(String district) {
    if (_selectedDistricts.contains(district)) {
      _selectedDistricts.remove(district);
      // Remove related villages when district is deselected
      _selectedVillages.removeWhere((village) => _farmers
          .where((f) => f.location.district == district)
          .any((f) => f.location.village == village));
    } else {
      _selectedDistricts.add(district);
    }
    notifyListeners();
  }

  void selectAllDistricts() {
    _selectedDistricts = Set.from(getAllDistricts());
    notifyListeners();
  }

  void clearDistrictSelection() {
    _selectedDistricts.clear();
    _selectedVillages.clear(); // Clear villages when districts are cleared
    notifyListeners();
  }

  List<String> getAllDistricts() {
    return _farmers.map((f) => f.location.district).toSet().toList()..sort();
  }

  // Village methods
  void toggleVillage(String village) {
    if (_selectedVillages.contains(village)) {
      _selectedVillages.remove(village);
    } else {
      _selectedVillages.add(village);
    }
    notifyListeners();
  }

  void selectAllVillages() {
    _selectedVillages = Set.from(getVillagesForSelectedDistricts());
    notifyListeners();
  }

  void clearVillageSelection() {
    _selectedVillages.clear();
    notifyListeners();
  }

  List<String> getVillagesForSelectedDistricts() {
    if (_selectedDistricts.isEmpty) return [];
    return _farmers
        .where((f) => _selectedDistricts.contains(f.location.district))
        .map((f) => f.location.village)
        .toSet()
        .toList()
      ..sort();
  }

  // Phase methods
  void togglePhase(FarmerPhase phase) {
    if (_selectedPhases.contains(phase)) {
      _selectedPhases.remove(phase);
    } else {
      _selectedPhases.add(phase);
    }
    notifyListeners();
  }

  // Global filter methods
  void clearFilters() {
    _selectedDistricts.clear();
    _selectedVillages.clear();
    _selectedPhases.clear();
    notifyListeners();
  }
}
