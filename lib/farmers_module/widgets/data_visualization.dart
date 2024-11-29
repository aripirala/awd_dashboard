// lib/farmers_module/widgets/data_visualization.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../models/farmer.dart';
import '../utils/phase_colors.dart';

class DataVisualizationPanel extends StatelessWidget {
  const DataVisualizationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmerProvider>(
      builder: (context, provider, _) {
        final phaseCounts = _getPhaseDistribution(provider.filteredFarmers);
        final districtCounts =
            _getDistrictDistribution(provider.filteredFarmers);
        final totalFarmers = provider.filteredFarmers.length;

        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, totalFarmers),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildPhaseSection(
                          context, phaseCounts, totalFarmers),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildDistrictSection(
                          context, districtCounts, totalFarmers),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, int totalFarmers) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distribution Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalFarmers farmers total',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseSection(
      BuildContext context, Map<FarmerPhase, int> distribution, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phase Distribution',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...PhaseColors.phaseOrder.map((phase) {
          final count = distribution[phase] ?? 0;
          final percentage = total > 0 ? (count / total * 100) : 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: PhaseColors.getColor(phase).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: PhaseColors.getColor(phase),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PhaseColors.phaseName(phase),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$count farmers',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PhaseColors.getColor(phase),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: PhaseColors.getColor(phase),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDistrictSection(
      BuildContext context, Map<String, int> distribution, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'District Distribution',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...distribution.entries.map((entry) {
          final percentage = total > 0 ? (entry.value / total * 100) : 0;
          final color = Theme.of(context).primaryColor;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${entry.value} farmers',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Map<FarmerPhase, int> _getPhaseDistribution(List<Farmer> farmers) {
    final Map<FarmerPhase, int> distribution = {};
    for (var farmer in farmers) {
      distribution[farmer.phase] = (distribution[farmer.phase] ?? 0) + 1;
    }
    return distribution;
  }

  Map<String, int> _getDistrictDistribution(List<Farmer> farmers) {
    final Map<String, int> distribution = {};
    for (var farmer in farmers) {
      distribution[farmer.location.district] =
          (distribution[farmer.location.district] ?? 0) + 1;
    }
    return distribution;
  }
}
