import 'package:tu_app_geolocalizacion/domain/entities/location_entity.dart';
import 'package:tu_app_geolocalizacion/domain/repositories/location_repository.dart';

class GetLocationUpdatesUseCase {
  final LocationRepository repository;

  GetLocationUpdatesUseCase(this.repository);

  Stream<LocationEntity> call() {
    return repository.getLocationUpdates();
  }
}