// lib/farmers_module/widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../models/farmer.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import '../utils/phase_colors.dart';
import 'cluster_marker.dart'; // New import

class MapWidget extends StatelessWidget {
  static final LatLng telanganaCenter = LatLng(17.8889, 79.1000);

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmerProvider>(
      builder: (context, farmerProvider, _) {
        final markers = farmerProvider.filteredFarmers.map((farmer) {
          return Marker(
            point: LatLng(
              farmer.location.latitude,
              farmer.location.longitude,
            ),
            width: 30,
            height: 30,
            child: GestureDetector(
              onTap: () => _showFarmerDetails(context, farmer),
              child: Icon(
                Icons.location_pin,
                color: PhaseColors.getColor(farmer.phase),
                size: 30,
              ),
            ),
          );
        }).toList();

        return Column(
          children: [
            _buildDistributionRow(context, farmerProvider.filteredFarmers),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: telanganaCenter,
                      initialZoom: 7.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 45,
                          size: const Size(
                              50, 50), // Updated size for new cluster
                          markers: markers,
                          builder: (context, markers) {
                            final phaseCounts = <FarmerPhase, int>{};
                            for (var marker in markers) {
                              final farmer = farmerProvider.filteredFarmers
                                  .firstWhere((f) =>
                                      f.location.latitude ==
                                          marker.point.latitude &&
                                      f.location.longitude ==
                                          marker.point.longitude);
                              phaseCounts[farmer.phase] =
                                  (phaseCounts[farmer.phase] ?? 0) + 1;
                            }

                            return Tooltip(
                              message: phaseCounts.entries
                                  .map((e) =>
                                      '${PhaseColors.phaseName(e.key)}: ${e.value}')
                                  .join('\n'),
                              preferBelow: false,
                              child: ClusterMarker(
                                distribution: phaseCounts,
                                totalCount: markers.length,
                              ),
                            );
                          },
                          polygonOptions: PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDistributionRow(BuildContext context, List<Farmer> farmers) {
    final Map<FarmerPhase, int> distribution = {};
    for (var farmer in farmers) {
      distribution[farmer.phase] = (distribution[farmer.phase] ?? 0) + 1;
    }
    final total = farmers.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: PhaseColors.phaseOrder.map((phase) {
          final count = distribution[phase] ?? 0;
          final percentage = total > 0 ? (count / total * 100) : 0;

          return Expanded(
            child: Card(
              elevation: 0,
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: PhaseColors.getColor(phase),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            PhaseColors.phaseName(phase),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count farmers',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: PhaseColors.phaseOrder.map((phase) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_pin,
                  color: PhaseColors.getColor(phase),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(PhaseColors.phaseName(phase)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFarmerDetails(BuildContext context, Farmer farmer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(farmer.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('District: ${farmer.location.district}'),
            Text('Village: ${farmer.location.village}'),
            Text('Phase: ${farmer.phase.toString().split('.').last}'),
            Text(
                'Location: ${farmer.location.latitude}, ${farmer.location.longitude}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
