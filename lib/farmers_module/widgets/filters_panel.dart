// lib/farmers_module/widgets/filters_panel.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farmer_provider.dart';
import '../models/farmer.dart';
import '../utils/phase_colors.dart';

class FiltersPanel extends StatelessWidget {
  final ScrollController? scrollController;

  const FiltersPanel({this.scrollController});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FarmerProvider>(context);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _buildDistrictSelector(context),
                const SizedBox(height: 16),
                _buildVillageSelector(context),
                const SizedBox(height: 16),
                _buildPhaseFilter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filters',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton.icon(
            onPressed: () => Provider.of<FarmerProvider>(context, listen: false)
                .clearFilters(),
            icon: const Icon(Icons.clear_all, size: 20),
            label: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictSelector(BuildContext context) {
    final provider = Provider.of<FarmerProvider>(context);
    final selectedCount = provider.selectedDistricts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Districts',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (selectedCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDistrictSelector(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCount > 0
                        ? provider.selectedDistricts.join(', ')
                        : 'Select districts',
                    style: TextStyle(
                      color: selectedCount > 0
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVillageSelector(BuildContext context) {
    final provider = Provider.of<FarmerProvider>(context);
    final selectedCount = provider.selectedVillages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Villages',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (selectedCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: provider.selectedDistricts.isEmpty
              ? null
              : () => _showVillageSelector(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: provider.selectedDistricts.isEmpty
                  ? Colors.grey.shade100
                  : Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.selectedDistricts.isEmpty
                        ? 'Select districts first'
                        : selectedCount > 0
                            ? provider.selectedVillages.join(', ')
                            : 'Select villages',
                    style: TextStyle(
                      color: provider.selectedDistricts.isEmpty
                          ? Colors.grey.shade600
                          : selectedCount > 0
                              ? Colors.black87
                              : Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phases',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FarmerPhase.values.map((phase) {
            final provider = Provider.of<FarmerProvider>(context);
            final isSelected = provider.selectedPhases.contains(phase);

            return FilterChip(
              selected: isSelected,
              label: Text(PhaseColors.phaseName(phase)),
              onSelected: (bool selected) {
                provider.togglePhase(phase);
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: PhaseColors.getColor(phase).withOpacity(0.2),
              checkmarkColor: PhaseColors.getColor(phase),
              labelStyle: TextStyle(
                color: isSelected
                    ? PhaseColors.getColor(phase)
                    : Colors.grey.shade800,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showDistrictSelector(BuildContext context) {
    final provider = Provider.of<FarmerProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          DistrictSelectorModal(provider: provider),
    );
  }

  void _showVillageSelector(BuildContext context) {
    final provider = Provider.of<FarmerProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          VillageSelectorModal(provider: provider),
    );
  }
}

class VillageSelectorModal extends StatefulWidget {
  final FarmerProvider provider;

  const VillageSelectorModal({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<VillageSelectorModal> createState() => _VillageSelectorModalState();
}

class DistrictSelectorModal extends StatefulWidget {
  final FarmerProvider provider;

  const DistrictSelectorModal({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<DistrictSelectorModal> createState() => _DistrictSelectorModalState();
}

// In the same file (filters_panel.dart), add/update these state classes:

class _DistrictSelectorModalState extends State<DistrictSelectorModal> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildSearchBar(),
              _buildDistrictList(scrollController),
              _buildActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Select Districts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextButton.icon(
            onPressed: widget.provider.clearDistrictSelection,
            icon: const Icon(Icons.clear, size: 20),
            label: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search districts...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDistrictList(ScrollController scrollController) {
    final allDistricts = widget.provider.getAllDistricts();
    final filteredDistricts = allDistricts
        .where((district) => district.toLowerCase().contains(searchQuery))
        .toList();

    return Expanded(
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CheckboxListTile(
            title: const Text('Select All'),
            value:
                widget.provider.selectedDistricts.length == allDistricts.length,
            onChanged: (bool? value) {
              if (value ?? false) {
                widget.provider.selectAllDistricts();
              } else {
                widget.provider.clearDistrictSelection();
              }
              setState(() {});
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(),
          ...filteredDistricts.map((district) {
            return CheckboxListTile(
              title: Text(district),
              value: widget.provider.selectedDistricts.contains(district),
              onChanged: (bool? value) {
                widget.provider.toggleDistrict(district);
                setState(() {});
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Apply (${widget.provider.selectedDistricts.length})',
            ),
          ),
        ],
      ),
    );
  }
}

class _VillageSelectorModalState extends State<VillageSelectorModal> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildSearchBar(),
              _buildVillageList(scrollController),
              _buildActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Select Villages',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextButton.icon(
            onPressed: widget.provider.clearVillageSelection,
            icon: const Icon(Icons.clear, size: 20),
            label: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search villages...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildVillageList(ScrollController scrollController) {
    final villages = widget.provider.getVillagesForSelectedDistricts();
    final filteredVillages = villages
        .where((village) => village.toLowerCase().contains(searchQuery))
        .toList();

    return Expanded(
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CheckboxListTile(
            title: const Text('Select All'),
            value: widget.provider.selectedVillages.length == villages.length,
            onChanged: (bool? value) {
              if (value ?? false) {
                widget.provider.selectAllVillages();
              } else {
                widget.provider.clearVillageSelection();
              }
              setState(() {});
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(),
          ...filteredVillages.map((village) {
            return CheckboxListTile(
              title: Text(village),
              value: widget.provider.selectedVillages.contains(village),
              onChanged: (bool? value) {
                widget.provider.toggleVillage(village);
                setState(() {});
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Apply (${widget.provider.selectedVillages.length})',
            ),
          ),
        ],
      ),
    );
  }
}
