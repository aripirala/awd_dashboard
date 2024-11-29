// lib/farmers_module/widgets/search_box.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../models/farmer.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

enum SearchType { farmer, village, district }

class SearchResult {
  final String title;
  final String subtitle;
  final LatLng location;
  final IconData icon;
  final SearchType type;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.icon,
    required this.type,
  });
}

class SearchBox extends StatefulWidget {
  final Function(LatLng location, SearchType type) onLocationSelected;
  final Function(Farmer)? onFarmerSelected;

  const SearchBox({
    Key? key,
    required this.onLocationSelected,
    this.onFarmerSelected,
  }) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<SearchResult> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmerProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search farmers, districts, or villages...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearching = false;
                              _searchResults.clear();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  _performSearch(value, provider.farmers);
                },
              ),
              if (_isSearching && _searchResults.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return ListTile(
                        leading: Icon(result.icon),
                        title: Text(result.title),
                        subtitle: Text(result.subtitle),
                        onTap: () {
                          widget.onLocationSelected(
                              result.location, result.type);
                          setState(() {
                            _isSearching = false;
                            _searchResults.clear();
                          });
                          _searchController.text = result.title;
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _performSearch(String query, List<Farmer> farmers) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    final results = <SearchResult>[];
    final lowerQuery = query.toLowerCase();

    // Search farmers
    for (var farmer in farmers) {
      if (farmer.name.toLowerCase().contains(lowerQuery)) {
        results.add(SearchResult(
          title: farmer.name,
          subtitle: '${farmer.location.district} - ${farmer.location.village}',
          location: LatLng(farmer.location.latitude, farmer.location.longitude),
          icon: Icons.person,
          type: SearchType.farmer,
        ));
      }
    }

    // Search districts
    final districts = farmers.map((f) => f.location.district).toSet();
    for (var district in districts) {
      if (district.toLowerCase().contains(lowerQuery)) {
        final districtFarmers =
            farmers.where((f) => f.location.district == district);
        if (districtFarmers.isNotEmpty) {
          final avgLat = districtFarmers
                  .map((f) => f.location.latitude)
                  .reduce((a, b) => a + b) /
              districtFarmers.length;
          final avgLng = districtFarmers
                  .map((f) => f.location.longitude)
                  .reduce((a, b) => a + b) /
              districtFarmers.length;

          results.add(SearchResult(
            title: district,
            subtitle: '${districtFarmers.length} farmers',
            location: LatLng(avgLat, avgLng),
            icon: Icons.location_city,
            type: SearchType.district,
          ));
        }
      }
    }

    // Search villages
    final villages = farmers
        .map((f) => '${f.location.village}, ${f.location.district}')
        .toSet();
    for (var village in villages) {
      if (village.toLowerCase().contains(lowerQuery)) {
        final villageFarmers = farmers.where(
            (f) => '${f.location.village}, ${f.location.district}' == village);
        if (villageFarmers.isNotEmpty) {
          final first = villageFarmers.first;
          results.add(SearchResult(
            title: first.location.village,
            subtitle: first.location.district,
            location: LatLng(first.location.latitude, first.location.longitude),
            icon: Icons.home,
            type: SearchType.village,
          ));
        }
      }
    }

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
