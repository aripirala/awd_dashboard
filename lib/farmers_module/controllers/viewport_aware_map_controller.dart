import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ViewportAwareMapController {
  final MapController mapController;
  final void Function(LatLngBounds bounds)? onBoundsChanged;

  ViewportAwareMapController({
    required this.onBoundsChanged,
  }) : mapController = MapController();

  void move(LatLng center, double zoom) {
    mapController.move(center, zoom);
  }

  void handleEvent(MapEvent event) {
    if (event is MapEventMoveEnd && mapController.bounds != null) {
      onBoundsChanged?.call(mapController.bounds!);
    }
  }

  bool isInVisibleArea(LatLng point, {double buffer = 0.1}) {
    final bounds = mapController.bounds;
    if (bounds == null) return false;

    final width = bounds.east - bounds.west;
    final height = bounds.north - bounds.south;

    final expandedBounds = LatLngBounds(
      LatLng(
        bounds.south - height * buffer,
        bounds.west - width * buffer,
      ),
      LatLng(
        bounds.north + height * buffer,
        bounds.east + width * buffer,
      ),
    );

    return expandedBounds.contains(point);
  }
}
