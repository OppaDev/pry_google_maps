import 'package:flutter/material.dart';

class LocationInfoWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool isLoading;

  const LocationInfoWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.address,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && latitude == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("Obteniendo ubicación...")),
        ),
      );
    }
    if (latitude == null || longitude == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("Ubicación no disponible")),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latitud: ${latitude!.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Longitud: ${longitude!.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (address != null && address!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Dirección: $address',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ] else if (isLoading) ...[
              const SizedBox(height: 8),
              const Text('Obteniendo dirección...'),
            ]
          ],
        ),
      ),
    );
  }
}