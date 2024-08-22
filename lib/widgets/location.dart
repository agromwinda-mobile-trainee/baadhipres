import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();
  LatLng _currentPosition = LatLng(0, 0);
  late Stream<Position> positionStream;


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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

    positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    positionStream.listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentPosition, 15.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          minZoom: 10.0,
          maxZoom: 26.0,
        ),
       children: [
         TileLayer(
           urlTemplate:
           'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
           subdomains:const ['a', 'b', 'c'],
           //userAgentPackageName: 'dev.fleaflet.flutter_map.example',
           //tileProvider: CancellableNetworkTileProvider(),
          // tileBuilder: tileBuilder,
         ),
         MarkerLayer(
           markers: [
             Marker(
               point:_currentPosition,
               width: 80,
               height: 80,
               child: GestureDetector(
                 onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     content: Text("votre position actuelle"),
                     duration: Duration(seconds: 1),
                     showCloseIcon: true,
                   ),
                 ),
                 child: const Icon(Icons.location_pin, size: 60, color: Colors.redAccent),
               ),
             ),
           ],
         )

        ],

          ),
      );
  }
}