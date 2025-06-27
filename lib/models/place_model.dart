import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id, required this.name, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'نبراويال',
    latLng: const LatLng(30.049006430481054, 31.23864875973549),
  ),
  PlaceModel(
    id: 1,
    name: 'شارع هدي شعراوي',
    latLng: const LatLng(30.046309448782093, 31.23903764423159),
  ),
  PlaceModel(
    id: 1,
    name: 'شارع الفلكي',
    latLng: const LatLng(30.046481862362004, 31.240466176093506),
  ),
];
