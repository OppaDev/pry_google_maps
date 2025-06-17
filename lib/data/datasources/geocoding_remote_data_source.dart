import 'package:geocoding/geocoding.dart';

class GeocodingRemoteDataSource {
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // Construir la dirección como desees
        return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      }
      return null;
    } catch (e) {
      print("Error en geocoding: $e");
      return null;
    }
  }
}