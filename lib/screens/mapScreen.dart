import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recyclingapp/entities/instructionMetadata.dart';
import 'package:recyclingapp/entities/material.dart';
import 'package:recyclingapp/providers/instructionProvider.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../utils/httpConnector.dart';
import '../widgets/customMarker.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    required this.panelController,
    required this.scrollController,
  });
  final ScrollController scrollController;
  final PanelController panelController;

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final HttpConnector httpConnector = HttpConnector();
  LatLng _latLng = LatLng(-24.733022, -65.495158);
  String? _materialName;
  double _zoom = 3.0;
  late MapController _mapController;
  List<InstructionMetadata> _instructions = [];
  List<RecyclableMaterial> _materials = [];
  double _rotation = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    setMaterials();
    _mapController = MapController();
    centerMap(_mapController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom, double rotation) {
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);
    final rotationTween =
        Tween<double>(begin: _mapController.rotation, end: rotation);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
      _mapController.rotate(rotationTween.evaluate(animation));
    });
    _controller.forward();
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
            widget.panelController.close(),
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
            for (var instructionMetadata in _instructions)
              Marker(
                width: 60,
                height: 60,
                point: LatLng(instructionMetadata.lat, instructionMetadata.lon),
                builder: (context) => Transform.rotate(
                    angle: -this._rotation * pi / 180,
                    child: CustomMarker(
                        materialName: instructionMetadata.materialName,
                        onPressed: () async {
                          context.read<Instruction>().resetInstruction();
                          widget.scrollController.jumpTo(0);
                          widget.panelController.animatePanelToSnapPoint();
                          String instructionMarkdown = await httpConnector
                              .getInstructionMarkdown(instructionMetadata.id);
                          context.read<Instruction>().setInstructionMetadata(
                              instructionMetadata, false);
                          context
                              .read<Instruction>()
                              .setInstructionMarkdown(instructionMarkdown);
                        })),
                anchorPos: AnchorPos.align(AnchorAlign.center),
              )
          ])
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                centerMap(_mapController);
              },
              child: const Icon(Icons.location_searching),
            ),
          ),
          Positioned(
            top: 64.0,
            right: 16.0,
            child: SpeedDial(
              backgroundColor: Colors.white,
              icon: Icons.filter_alt_rounded,
              direction: SpeedDialDirection.down,
              children: [
                SpeedDialChild(
                    child: Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: SvgPicture.asset('assets/icons/todos.svg'),
                    ),
                    backgroundColor: Colors.transparent,
                    label: "todos",
                    elevation: 0,
                    onTap: () => {
                          setState(() {
                            this._materialName = null;
                          }),
                          getInstructions()
                        }),
                for (var material in _materials)
                  SpeedDialChild(
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                            'assets/icons/${material.name}.svg'),
                      ),
                      backgroundColor: Colors.transparent,
                      label: material.name,
                      elevation: 0,
                      onTap: () => {
                            setState(() {
                              this._materialName = material.name;
                            }),
                            getInstructions()
                          })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> centerMap(mapController) async {
    if (await Permission.locationWhenInUse.request().isDenied) {
      exit(0);
    }
    InstructionMetadata? instructionMetadata =
        context.read<Instruction>().instructionMetadata;
    bool firstLoad = context.read<Instruction>().firstLoad;
    if (instructionMetadata != null && firstLoad) {
      context.read<Instruction>().firstLoad = false;
      final latLng = LatLng(instructionMetadata.lat, instructionMetadata.lon);
      _animatedMapMove(latLng, 15.0, 0);
      setState(() {
        _latLng = latLng;
        _rotation = _mapController.rotation;
        _materialName = instructionMetadata.materialName;
      });
    } else {
      final Location location = Location();
      final locationData = await location.getLocation();
      final latLng = LatLng(locationData.latitude!, locationData.longitude!);
      _animatedMapMove(latLng, 15.0, 0);
      setState(() {
        _latLng = latLng;
        _rotation = _mapController.rotation;
      });
    }

    getInstructions();
  }

  Future<void> getInstructions() async {
    HttpConnector networkHelper = HttpConnector();
    List<InstructionMetadata> instructions = await networkHelper
        .searchInstructions(_latLng.latitude, _latLng.latitude, _materialName);
    setState(() {
      _instructions = instructions;
    });
  }

  Future<void> setMaterials() async {
    List<RecyclableMaterial> materials = await httpConnector.getMaterialsList();
    setState(() {
      _materials = materials;
    });
  }
}
