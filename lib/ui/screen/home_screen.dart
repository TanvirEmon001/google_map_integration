import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map")),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        trafficEnabled: true,
        onTap: (LatLng latLng) {
          print('Tapped on : $latLng');
        },
        onLongPress: (LatLng latLng) {
          print('Long pressed on : $latLng');
        },
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(22.3834464, 91.8179684),
        ),
        onMapCreated: (GoogleMapController controller){
          _mapController = controller;
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(23.795285011504653, 90.40711339563131),
                    zoom: 15,
                  ),
                ),
              );
            },
            child: Icon(Icons.factory),
          ),
          FloatingActionButton(
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(23.719435420479336, 90.36848187446594),
                    zoom: 15,
                  ),
                ),
              );
            },
            child: Icon(Icons.home),
          ),
        ],
      ),
    );
  }
}
