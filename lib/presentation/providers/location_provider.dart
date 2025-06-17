import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pry_google_maps/application/usecases/get_address_from_coordinates_usecase.dart';
import 'package:pry_google_maps/application/usecases/get_current_location_usecase.dart';
import 'package:pry_google_maps/application/usecases/get_location_updates_usecase.dart';
import 'package:pry_google_maps/data/datasources/geocoding_remote_data_source.dart';
import 'package:pry_google_maps/data/datasources/location_remote_data_source.dart';
import 'package:pry_google_maps/data/repositories/location_repository_impl.dart';
import 'package:pry_google_maps/domain/entities/location_entity.dart';
import 'package:pry_google_maps/domain/repositories/location_repository.dart';

// --- Dependency Injection for Data Sources and Repositories ---
final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSource();
});

final geocodingRemoteDataSourceProvider = Provider<GeocodingRemoteDataSource>((ref) {
  return GeocodingRemoteDataSource();
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    locationRemoteDataSource: ref.watch(locationRemoteDataSourceProvider),
    geocodingRemoteDataSource: ref.watch(geocodingRemoteDataSourceProvider),
  );
});

// --- Dependency Injection for Use Cases ---
final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>((ref) {
  return GetCurrentLocationUseCase(ref.watch(locationRepositoryProvider));
});

final getLocationUpdatesUseCaseProvider = Provider<GetLocationUpdatesUseCase>((ref) {
  return GetLocationUpdatesUseCase(ref.watch(locationRepositoryProvider));
});

final getAddressFromCoordinatesUseCaseProvider = Provider<GetAddressFromCoordinatesUseCase>((ref) {
  return GetAddressFromCoordinatesUseCase(ref.watch(locationRepositoryProvider));
});


// --- State Notifier for Location Data ---
class LocationState {
  final LocationEntity? currentLocation;
  final String? currentAddress;
  final bool isLoading;
  final String? errorMessage;
  final Set<Marker> markers;
  final GoogleMapController? mapController;

  LocationState({
    this.currentLocation,
    this.currentAddress,
    this.isLoading = false,
    this.errorMessage,
    this.markers = const {},
    this.mapController,
  });

  LocationState copyWith({
    LocationEntity? currentLocation,
    String? currentAddress,
    bool? isLoading,
    String? errorMessage,
    Set<Marker>? markers,
    GoogleMapController? mapController,
    bool clearError = false, // Para limpiar el error explícitamente
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      currentAddress: currentAddress ?? this.currentAddress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      markers: markers ?? this.markers,
      mapController: mapController ?? this.mapController,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetLocationUpdatesUseCase _getLocationUpdatesUseCase;
  final GetAddressFromCoordinatesUseCase _getAddressFromCoordinatesUseCase;
  StreamSubscription<LocationEntity>? _locationSubscription;

  LocationNotifier(
    this._getCurrentLocationUseCase,
    this._getLocationUpdatesUseCase,
    this._getAddressFromCoordinatesUseCase,
  ) : super(LocationState()) {
    fetchInitialLocation();
    subscribeToLocationUpdates();
  }

  Future<void> fetchInitialLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final location = await _getCurrentLocationUseCase();
      _updateLocationState(location);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void subscribeToLocationUpdates() {
    _locationSubscription?.cancel(); // Cancelar suscripción anterior si existe
    _locationSubscription = _getLocationUpdatesUseCase().listen(
      (location) {
        _updateLocationState(location);
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.toString());
      },
    );
  }

  Future<void> _updateLocationState(LocationEntity location) async {
    String? address;
    try {
      address = await _getAddressFromCoordinatesUseCase(location.latitude, location.longitude);
    } catch (e) {
      print("Error obteniendo dirección: $e");
      // No actualizamos el mensaje de error del estado principal por esto
    }

    final newMarker = Marker(
      markerId: const MarkerId('currentLocation'),
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(
        title: 'Mi Ubicación',
        snippet: address ?? '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
      ),
    );

    state = state.copyWith(
      currentLocation: location,
      currentAddress: address,
      isLoading: false,
      markers: {newMarker},
      clearError: true,
    );

    // Mover cámara
    state.mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
    );
  }

  void setMapController(GoogleMapController controller) {
    state = state.copyWith(mapController: controller);
    // Si ya tenemos una ubicación, movemos la cámara
    if (state.currentLocation != null) {
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(state.currentLocation!.latitude, state.currentLocation!.longitude)),
      );
    }
  }
  
  void zoomIn() {
    state.mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    state.mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    state.mapController?.dispose();
    super.dispose();
  }
}

final locationNotifierProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(
    ref.watch(getCurrentLocationUseCaseProvider),
    ref.watch(getLocationUpdatesUseCaseProvider),
    ref.watch(getAddressFromCoordinatesUseCaseProvider),
  );
});