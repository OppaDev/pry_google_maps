import 'package:pry_google_maps/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation();
  Stream<LocationEntity> getLocationUpdates();
  Future<String?> getAddressFromCoordinates(double latitude, double longitude);
}