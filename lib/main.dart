import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tu_app_geolocalizacion/presentation/views/map_screen.dart'; // Ajusta el nombre de tu paquete

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario para plugins como geolocator
  runApp(
    const ProviderScope( // Para Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocalización App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}