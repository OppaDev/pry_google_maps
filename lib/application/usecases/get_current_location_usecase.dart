import 'package:pry_google_maps/domain/entities/location_entity.dart';
import 'package:pry_google_maps/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<LocationEntity> call() async {
    return await repository.getCurrentLocation();
  }
}