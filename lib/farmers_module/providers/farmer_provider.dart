import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/farmer.dart';
import '../services/api_service.dart';

class FarmerProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  static const double _gridSize = 1.0;

  List<Farmer> _farmers = [];
  List<Farmer> _visibleFarmers = [];
  Set<String> _selectedDistricts = {};
  Set<String> _selectedVillages = {};
  Set<FarmerPhase> _selectedPhases = {};
  bool _isLoading = false;
  String? _error;
  LatLngBounds? _lastBounds;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Farmer> get farmers => _farmers;
  List<Farmer> get visibleFarmers => _visibleFarmers;
  Set<String> get selectedDistricts => _selectedDistricts;
  Set<String> get selectedVillages => _selectedVillages;
  Set<FarmerPhase> get selectedPhases => _selectedPhases;

  List<Farmer> get filteredFarmers {
    if (_selectedDistricts.isEmpty &&
        _selectedVillages.isEmpty &&
        _selectedPhases.isEmpty) {
      return _visibleFarmers;
    }

    return _visibleFarmers.where((farmer) {
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

  Future<void> updateVisibleFarmers(LatLngBounds bounds) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_farmers.isEmpty) {
        _farmers = await _apiService.getFarmers();
      }

      _lastBounds = bounds;
      final newFarmers = await _apiService.getFarmers(bounds: bounds);
      _visibleFarmers = newFarmers;
    } catch (e) {
      _error = e.toString();
      _visibleFarmers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _selectedDistricts.clear();
    _selectedVillages.clear();
    _selectedPhases.clear();

    if (_lastBounds != null) {
      updateVisibleFarmers(_lastBounds!);
    }
  }

  String _getGridKey(double lat, double lng) {
    final gridLat = (lat / _gridSize).floor() * _gridSize;
    final gridLng = (lng / _gridSize).floor() * _gridSize;
    return '${gridLat}_${gridLng}';
  }

  // Initial data fetching
  // Future<void> fetchFarmers() async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();

  //     final farmers = await _apiService.getFarmers();
  //     _farmers = farmers;
  //     _visibleFarmers = farmers;

  //     // Initialize grid cache
  //     for (var farmer in farmers) {
  //       final gridKey = _getGridKey(
  //         farmer.location.latitude,
  //         farmer.location.longitude,
  //       );
  //       _gridCache[gridKey] ??= [];
  //       _gridCache[gridKey]!.add(farmer);
  //     }
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchFarmers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_farmers.isEmpty) {
        _farmers = await _apiService.getFarmers();
        _visibleFarmers = _farmers;
      }
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
    _selectedVillages.clear();
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
    if (_selectedDistricts.isEmpty) {
      return _visibleFarmers.map((f) => f.location.village).toSet().toList()
        ..sort();
    }
    return _visibleFarmers
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

  // void resetFiltersAndCache() {
  //   _gridCache.clear();
  //   _selectedDistricts.clear();
  //   _selectedVillages.clear();
  //   _selectedPhases.clear();
  //   _visibleFarmers = _farmers;
  //   notifyListeners();
  // }

  // LatLngBounds? _getLastKnownBounds() => _lastBounds;
}
