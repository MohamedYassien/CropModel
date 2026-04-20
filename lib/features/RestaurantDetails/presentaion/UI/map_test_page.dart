import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({super.key});

  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class _MapTestPageState extends State<MapTestPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(30.0444, 31.2357);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps Test"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        mapType: MapType.normal,
        myLocationEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}