import 'package:tu_app_geolocalizacion/domain/repositories/location_repository.dart';

class GetAddressFromCoordinatesUseCase {
  final LocationRepository repository;

  GetAddressFromCoordinatesUseCase(this.repository);

  Future<String?> call(double latitude, double longitude) async {
    return await repository.getAddressFromCoordinates(latitude, longitude);
  }
}