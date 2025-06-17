import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tu_app_geolocalizacion/domain/entities/location_entity.dart'; // Para usar LocationEntity directamente

class LocationRemoteDataSource {
  Future<bool> _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Opcional: abrir ajustes de la app si está permanentemente denegado
      // await openAppSettings();
      return false;
    }
    return false;
  }

  Future<Position> getCurrentPosition() async {
    final hasPermission = await _requestPermission();
    if (!hasPermission) {
      throw Exception('Permiso de ubicación denegado.');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Servicios de ubicación deshabilitados.');
    }
    
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Stream<Position> getPositionStream() async* {
    final hasPermission = await _requestPermission();
    if (!hasPermission) {
      throw Exception('Permiso de ubicación denegado.');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Servicios de ubicación deshabilitados.');
    }

    await for (final position in Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Notificar cada 10 metros
      ),
    )) {
      yield position;
    }
  }
}