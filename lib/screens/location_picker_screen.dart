import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationPickerScreen extends StatefulWidget {
  final String apiKey ;

  LocationPickerScreen({required this.apiKey});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _pickedLocation;
  String? _address;
  LatLng? _initialLocation;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _initialLocation = LatLng(0.351663, -78.1435014);
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _pickLocation(LatLng location) async {
    setState(() {
      _pickedLocation = location;
      _address = "Buscando dirección...";
    });

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=${widget.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        setState(() {
          _address = data['results'][0]['formatted_address'];
        });
      } else {
        setState(() {
          _address = "Dirección no encontrada";
        });
      }
    } else {
      setState(() {
        _address = "Error obteniendo dirección";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Ubicación'),
      ),
      body: _initialLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialLocation!,
                      zoom: 15,
                    ),
                    onTap: _pickLocation,
                  ),
                ),
                if (_pickedLocation != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                            'Latitud: ${_pickedLocation!.latitude}, Longitud: ${_pickedLocation!.longitude}'),
                        Text('Dirección: $_address'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop({
                              'address': _address,
                              'location': _pickedLocation,
                            });
                          },
                          child: Text('Seleccionar esta ubicación'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
