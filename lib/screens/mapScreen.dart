import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as location_package;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/entities/instruction.dart';
import 'package:recyclingapp/providers/instructionMarkdownProvider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../utils/httpConnector.dart';
import '../widgets/customMarker.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    required this.panelController,
  });

  final PanelController? panelController;

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  LatLng _latLng = LatLng(-24.733022, -65.495158);
  double _zoom = 3.0;
  late MapController _mapController;
  List<Instruction> _instructions = [];
  double _rotation = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    centerMap(_mapController);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom, double rotation) {
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);
    final rotationTween =
        Tween<double>(begin: _mapController.rotation, end: rotation);
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
      _mapController.rotate(rotationTween.evaluate(animation));
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _latLng,
          zoom: _zoom,
          maxZoom: 18,
          onPositionChanged: (mapPosition, _) => setState(() {
            this._rotation = this._mapController.rotation;
          }),
          onTap: (tapPosition, point) => {
            widget.panelController!.close(),
          },
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
              keepBuffer: 20),
          MarkerLayer(markers: [
            for (var instruction in _instructions)
              Marker(
                width: 80,
                height: 80,
                point: LatLng(instruction.lat, instruction.lon),
                builder: (context) => Transform.rotate(
                    angle: -this._rotation * pi / 180,
                    child: CustomMarker(onPressed: () {
                      context
                          .read<InstructionMarkdown>()
                          .resetInstructionMarkdown();
                      context
                          .read<InstructionMarkdown>()
                          .setInstruction(instruction, false);
                      context
                          .read<InstructionMarkdown>()
                          .setInstructionMarkdown(instruction);
                      widget.panelController!.animatePanelToSnapPoint();
                    })),
                anchorPos: AnchorPos.align(AnchorAlign.center),
              )
          ])
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
    final locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    _animatedMapMove(latLng, 15.0, 0);
    setState(() {
      this._latLng = latLng;
      this._rotation = this._mapController.rotation;
    });

    getInstructions();
  }

  Future<void> getInstructions() async {
    HttpConnector networkHelper = HttpConnector();
    List<Instruction> instructions = await networkHelper.searchInstructions(
        _latLng.latitude, _latLng.latitude);
    setState(() {
      _instructions = instructions;
    });
  }
}
