import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps/models/place_model.dart';
import 'dart:ui' as ui;

import 'package:maps/services/location_services.dart';
import 'package:maps/widgets/custom_alert_permission.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({Key? key}) : super(key: key);

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _mapController;
  late CameraPosition _initialCameraPosition;
  late LocationServices locationServices;
  late Location location;
  bool isFirstCall = true;
  static const LatLng _defaultLocation = LatLng(
    30.008227970892843,
    31.248526313191743,
  ); // Cairo coordinates

  final Set<Marker> _markers = {
    //Marker(markerId: const MarkerId('1'), position: _defaultLocation),
  };
  //final Set<Polyline> polylines = {};
  @override
  void initState() {
    // Initialize the initial camera position to Cairo coordinates
    _initialCameraPosition = CameraPosition(target: _defaultLocation, zoom: 10);
    location = Location();
    locationServices = LocationServices(); //initPolylines();
    updateMyLocation();
    super.initState();
    //initMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Google Map')),
      body: GoogleMap(
        //polylines: polylines,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          initMapStyle();
          location.onLocationChanged.listen((locationData) {});
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

  void updateMyLocation() async {
    locationServices.checkAndLocationService();
    var hasPermission = await locationServices.checkAndLocationPermission();
    if (hasPermission) {
      locationServices.getRealTimeLocationData((locationData) {
        location.changeSettings(distanceFilter: 4);
        myLocationMarker(locationData);
      });
    } else {
      customAlertPermission(context);
    }
  }

  void setMyCameraPosition(LocationData locationData) {
    if (isFirstCall) {
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 15,
      );
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      isFirstCall = false;
    }else{
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }

  void myLocationMarker(
    LocationData locationData,
  ) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('myLocationMarker'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
      infoWindow: const InfoWindow(title: 'My Location'),
    );
    _markers.add(myLocationMarker);
    setState(() {});
  }

  /* void initMarkers() async {
    var customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.4),
      'assets/images/marker.png',
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
  }*/

  /*void initPolylines() {
    Polyline polyline = Polyline(
      polylineId: const PolylineId('1'),
      points: [
        LatLng(30.008227970892843, 31.248526313191743),
        LatLng(29.993985007748897, 31.274088451786547),
        LatLng(29.996284457244588, 31.23473130558523),
      ],
      color: Colors.red,
      width: 5,
    );
    polylines.add(polyline);
  }*/
}

// LatLng(30.008227970892843, 31.248526313191743),
// LatLng(29.993985007748897, 31.274088451786547),
// LatLng(29.996284457244588, 31.23473130558523),
// Future<Uint8List> getImageFromDataRow(String image, double width) async {
//   var imageData = await rootBundle.load(image);
//   var imageCodec = await ui.instantiateImageCodec(
//     imageData.buffer.asUint8List(),
//     targetWidth: width.round(),
//   );
//   var imageFrame = await imageCodec.getNextFrame();
//   var imageBytData = await imageFrame.image.toByteData(
//     format: ui.ImageByteFormat.png,
//   );
//   if (imageBytData != null) {
//     return imageBytData.buffer.asUint8List();
//   } else {
//     return Uint8List(0);
//   }
// }
