import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.onPickLocation, this.initialLatLng});
  final void Function(LatLng latLng) onPickLocation;
  final LatLng? initialLatLng;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? latLng;
  late MapController _mapController;
  @override
  void initState() {
    latLng = widget.initialLatLng;
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  widget.initialLatLng ?? const LatLng(36.1994878, 37.1629574),
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                latLng = point;
                _mapController.move(point, 15.0, offset: Offset(0, -1));
                setState(() {});
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dllni.smOwner',
              ),
              MarkerLayer(
                markers: [
                  if (latLng != null)
                    Marker(
                      point: latLng!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 60,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            width: context.width - 80,
            child: GestureDetector(
              onTap: () {
                if (latLng != null) widget.onPickLocation(latLng!);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xff064E3B),
                ),
                padding: EdgeInsetsDirectional.symmetric(vertical: 12),
                margin: EdgeInsetsDirectional.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location, color: context.onPrimary, size: 14),
                    SizedBox(width: 8),
                    AppText.bodyMedium(
                      'تحديد الموقع',
                      color: context.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
