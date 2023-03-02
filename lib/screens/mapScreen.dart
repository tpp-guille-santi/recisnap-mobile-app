import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as location_package;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapScreenState();
}



class _MapScreenState extends State<MapScreen> {
  LatLng _latLng = LatLng(-24.733022, -65.495158);
  double _zoom = 3.0;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    centerMap(_mapController);
  }

  @override
  Widget build(BuildContext context) {
    print(_latLng.toString());
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _latLng,
          zoom: _zoom,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          centerMap(_mapController);
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> centerMap(mapController) async {
    if (await Permission.locationWhenInUse.request().isDenied) {
      exit(0);
    }
    final location_package.Location location = location_package.Location();
    final _locationData = await location.getLocation();
    final latLng = LatLng(_locationData.latitude!, _locationData.longitude!);
    _mapController.move(latLng, 15.0);
  }
}
