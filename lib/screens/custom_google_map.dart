import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/models/place_model.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({Key? key}) : super(key: key);

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _mapController;
  late CameraPosition _initialCameraPosition;
  static const LatLng _defaultLocation = LatLng(
    30.0444,
    31.2357,
  ); // Cairo coordinates

  final Set<Marker> _markers = {
    //Marker(markerId: const MarkerId('1'), position: _defaultLocation),
  };

  @override
  void initState() {
    // Initialize the initial camera position to Cairo coordinates
    _initialCameraPosition = CameraPosition(target: _defaultLocation, zoom: 15);
    super.initState();
    initMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Google Map')),
      body: GoogleMap(
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          initMapStyle();
        },
        initialCameraPosition: _initialCameraPosition,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void initMapStyle() async {
    var mapStyle = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/night_map_style.json');
    _mapController?.setMapStyle(mapStyle);
  }

  void initMarkers() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        devicePixelRatio: 2,
      ),
      'assets/images/icons-marker.png',
    );
    var myMarkers = places.map((placeModel) {
      return Marker(
        markerId: MarkerId(placeModel.id.toString()),
        position: placeModel.latLng,
        infoWindow: InfoWindow(title: placeModel.name),
        icon: customIcon,
      );
    }).toSet();
    _markers.addAll(myMarkers);
    setState(() {});
  }
}
