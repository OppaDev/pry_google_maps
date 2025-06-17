import 'package:pry_google_maps/domain/entities/location_entity.dart';
import 'package:pry_google_maps/domain/repositories/location_repository.dart';

class GetLocationUpdatesUseCase {
  final LocationRepository repository;

  GetLocationUpdatesUseCase(this.repository);

  Stream<LocationEntity> call() {
    return repository.getLocationUpdates();
  }
}