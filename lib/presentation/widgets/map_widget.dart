import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    super.key,
    required this.initialCameraPosition,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: onMapCreated,
      markers: markers,
      myLocationEnabled: false, // Controlado manualmente por el marcador
      myLocationButtonEnabled: false, // Ídem
      zoomControlsEnabled: false, // Controlado por FABs
    );
  }
}