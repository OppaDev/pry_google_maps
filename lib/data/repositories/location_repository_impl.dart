import 'package:geolocator/geolocator.dart';
import 'package:pry_google_maps/data/datasources/geocoding_remote_data_source.dart';
import 'package:pry_google_maps/data/datasources/location_remote_data_source.dart';
import 'package:pry_google_maps/domain/entities/location_entity.dart';
import 'package:pry_google_maps/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource locationRemoteDataSource;
  final GeocodingRemoteDataSource geocodingRemoteDataSource;

  LocationRepositoryImpl({
    required this.locationRemoteDataSource,
    required this.geocodingRemoteDataSource,
  });

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      final position = await locationRemoteDataSource.getCurrentPosition();
      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      // Manejar o relanzar la excepción
      print("Error en getCurrentLocation Repository: $e");
      rethrow;
    }
  }

  @override
  Stream<LocationEntity> getLocationUpdates() {
    try {
      return locationRemoteDataSource.getPositionStream().map((position) {
        return LocationEntity(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      });
    } catch (e) {
      print("Error en getLocationUpdates Repository: $e");
      // Devolver un stream de error o relanzar
      return Stream.error(e);
    }
  }

  @override
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      return await geocodingRemoteDataSource.getAddressFromCoordinates(latitude, longitude);
    } catch (e) {
      print("Error en getAddressFromCoordinates Repository: $e");
      return null; // O manejar el error de otra forma
    }
  }
}