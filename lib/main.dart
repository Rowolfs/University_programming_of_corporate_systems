import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() => runApp(const GeoSensorsApp());

class GeoSensorsApp extends StatelessWidget {
  const GeoSensorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo & Sensors',
      theme: ThemeData(useMaterial3: true),
      home: const GeoSensorsPage(),
    );
  }
}

class GeoSensorsPage extends StatefulWidget {
  const GeoSensorsPage({super.key});
  @override
  State<GeoSensorsPage> createState() => _GeoSensorsPageState();
}

class _GeoSensorsPageState extends State<GeoSensorsPage> {
  Position? _position;
  String _address = '–';
  double? _compass;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    setState(() {
      _position = pos;
      _address =
          '${placemarks.first.locality}, ${placemarks.first.street ?? ''}';
    });
  }

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((event) {
      setState(() => _accelerometerValues = [event.x, event.y, event.z]);
    });

    gyroscopeEvents.listen((event) {
      setState(() => _gyroscopeValues = [event.x, event.y, event.z]);
    });

    FlutterCompass.events!.listen((event) {
      setState(() => _compass = event.heading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geo & Sensors Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Определить местоположение'),
            ),
            const SizedBox(height: 12),
            Text(
              _position != null
                  ? 'Координаты: ${_position!.latitude}, ${_position!.longitude}'
                  : 'Координаты: –',
            ),
            Text('Адрес: $_address'),
            const Divider(height: 30),
            Text('Компас: ${_compass?.toStringAsFixed(2) ?? '–'}°'),
            const Divider(height: 30),
            Text(
                'Акселерометр: ${_accelerometerValues?.map((e) => e.toStringAsFixed(2)).join(', ') ?? '–'}'),
            Text(
                'Гироскоп: ${_gyroscopeValues?.map((e) => e.toStringAsFixed(2)).join(', ') ?? '–'}'),
          ],
        ),
      ),
    );
  }
}
