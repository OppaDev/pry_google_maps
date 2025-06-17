import 'package:flutter/material.dart';
    import 'package:google_maps_flutter/google_maps_flutter.dart';
    import 'package:geolocator/geolocator.dart';

    class MapPage extends StatefulWidget {
      const MapPage({Key? key}) : super(key: key);

      @override
      State<MapPage> createState() => _MapPageState();
    }

    class _MapPageState extends State<MapPage> {
      GoogleMapController? mapController;
      LatLng? _currentPosition;

      @override
      void initState() {
        super.initState();
        _determinePosition();
      }

      Future<void> _determinePosition() async {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
        }
      }

      void _onMapCreated(GoogleMapController controller) {
        mapController = controller;
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Geolocalización'),
          ),
          body: _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 16.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
        );
      }
    }