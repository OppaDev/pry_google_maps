import 'package:tu_app_geolocalizacion/domain/entities/location_entity.dart';
import 'package:tu_app_geolocalizacion/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<LocationEntity> call() async {
    return await repository.getCurrentLocation();
  }
}