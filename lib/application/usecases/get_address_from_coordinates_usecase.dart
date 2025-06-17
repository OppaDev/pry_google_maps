import 'package:pry_google_maps/domain/repositories/location_repository.dart';

class GetAddressFromCoordinatesUseCase {
  final LocationRepository repository;

  GetAddressFromCoordinatesUseCase(this.repository);

  Future<String?> call(double latitude, double longitude) async {
    return await repository.getAddressFromCoordinates(latitude, longitude);
  }
}