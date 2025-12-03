import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserCurrentLocationScreen extends StatefulWidget {
  const UserCurrentLocationScreen({super.key});

  @override
  State<UserCurrentLocationScreen> createState() =>
      _UserCurrentLocationScreenState();
}

class _UserCurrentLocationScreenState extends State<UserCurrentLocationScreen> {
  Position? _currentPosition;
  GoogleMapController? _mapController;

  Marker? _userMarker;

  Timer? _locationTimer;

  //Store all visited locations (for polyline)
  final List<LatLng> _polylineCoordinates = [];

  //Polyline Set
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  // --------------------------------------------------------------
  // Fetch Current Location (first time)
  // --------------------------------------------------------------
  Future<void> _getCurrentLocation() async {
    await _handleLocationPermission(() async {
      _currentPosition = await Geolocator.getCurrentPosition();

      /// Add first point to polyline
      _addPolylinePoint(_currentPosition!);

      _updateMarker(_currentPosition!);

      setState(() {});
    });
  }

  // --------------------------------------------------------------
  // Timer: Update location every 10 seconds
  // --------------------------------------------------------------
  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      print("Fetching location every 10 seconds...");

      _currentPosition = await Geolocator.getCurrentPosition();

      _updateMarker(_currentPosition!);

      // add new point to polyline list
      _addPolylinePoint(_currentPosition!);

      // rebuild the polyline
      _updatePolyline();

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          ),
        );
      }

      setState(() {});
    });
  }

  // --------------------------------------------------------------
  // Add one new point to polyline list
  // --------------------------------------------------------------
  void _addPolylinePoint(Position position) {
    _polylineCoordinates.add(
      LatLng(position.latitude, position.longitude),
    );
  }

  // --------------------------------------------------------------
  // Create / Update polyline
  // --------------------------------------------------------------
  void _updatePolyline() {
    _polylines.clear();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId("user_path"),
        width: 5,
        color: Colors.purple,
        points: _polylineCoordinates,
      ),
    );
  }

  // --------------------------------------------------------------
  // Marker Update
  // --------------------------------------------------------------
  void _updateMarker(Position position) {
    _userMarker = Marker(
      markerId: const MarkerId("user_marker"),
      position: LatLng(position.latitude, position.longitude),

      // BLUE marker
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

      //Info Window (title + snippet)
      infoWindow: InfoWindow(
        title: "My current location",
        snippet: "Lat: ${position.latitude}, Lng: ${position.longitude}",
      ),

    );
  }


  // --------------------------------------------------------------
  // Permission Handler
  // --------------------------------------------------------------
  Future<void> _handleLocationPermission(VoidCallback onSuccess) async {
    LocationPermission permissionStatus =
    await Geolocator.checkPermission();

    if (_isPermissionGranted(permissionStatus)) {
      bool isEnabled = await Geolocator.isLocationServiceEnabled();
      if (isEnabled) {
        onSuccess();
      } else {

        // -> Request service
        Geolocator.openLocationSettings();
      }
    } else {
      LocationPermission newStatus = await Geolocator.requestPermission();
      if (_isPermissionGranted(newStatus)) {
        onSuccess();
      }
    }
  }

  bool _isPermissionGranted(LocationPermission status) {
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  // --------------------------------------------------------------
  // UI
  // --------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location + Polyline")),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
        ),
        markers: _userMarker != null ? {_userMarker!} : {},
        polylines: _polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
