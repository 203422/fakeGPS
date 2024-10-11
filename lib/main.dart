import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Verificar Ubicación',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LocationStatusScreen(),
    );
  }
}

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({super.key});
  @override
  State<LocationStatusScreen> createState() => _LocationStatusScreenState();
}

class _LocationStatusScreenState extends State<LocationStatusScreen> {
  String _locationStatus = "Comprobando ubicación...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    setState(() {
      isLoading = true;
    });

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        _locationStatus = "Permiso de ubicación denegado";
        isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    bool isFake = _isLocationSpoofed(position);

    setState(() {
      _locationStatus = isFake ? "Ubicación Falsa" : "Ubicación Verdadera";
      isLoading = false;
    });
  }

  bool _isLocationSpoofed(Position position) {
    if (position.accuracy > 50) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Verificar Ubicación')),
      ),
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.deepPurple,),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _locationStatus,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 84,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _locationStatus,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
      ),
    );
  }
}
