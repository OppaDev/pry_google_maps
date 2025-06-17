import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String? address; // Opcional, para la dirección

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];

  LocationEntity copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}