import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tu_app_geolocalizacion/presentation/providers/location_provider.dart';
import 'package:tu_app_geolocalizacion/presentation/widgets/location_info_widget.dart';
import 'package:tu_app_geolocalizacion/presentation/widgets/map_widget.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(0, 0), // Un punto neutral inicial
    zoom: 2,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationNotifierProvider);
    final locationNotifier = ref.read(locationNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Geolocalización'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              locationNotifier.fetchInitialLocation();
            },
            tooltip: 'Refrescar Ubicación',
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            initialCameraPosition: locationState.currentLocation != null
                ? CameraPosition(
                    target: LatLng(locationState.currentLocation!.latitude,
                        locationState.currentLocation!.longitude),
                    zoom: 15,
                  )
                : _kInitialPosition,
            markers: locationState.markers,
            onMapCreated: (controller) {
              locationNotifier.setMapController(controller);
            },
          ),
          if (locationState.isLoading && locationState.currentLocation == null)
            const Center(child: CircularProgressIndicator()),
          if (locationState.errorMessage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.redAccent,
                  child: Text(
                    locationState.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: LocationInfoWidget(
              latitude: locationState.currentLocation?.latitude,
              longitude: locationState.currentLocation?.longitude,
              address: locationState.currentAddress,
              isLoading: locationState.isLoading,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Ajustar para no superponer con info
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              mini: true,
              onPressed: () => locationNotifier.zoomIn(),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              mini: true,
              onPressed: () => locationNotifier.zoomOut(),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}