import 'package:flutter/material.dart';
import 'package:google_map/google_map_app.dart';

void main(){
  runApp(GoogleMapApp());
}

///
///
/// Functionality implemented:
/// 1. Automatic Map Animation:
//    - Display a Google Map view that smoothly animates to the user's current location.
///
/// 2. Real-Time Location Updates:
//    - Fetch the user's current location every 10 seconds.
//    - Update the marker's position on the map to reflect the latest location.
///
/// 3. Polyline Tracking:
//    - Draw a polyline on the map connecting the previous and current locations.
//    - Keep updating the polyline as the user's location changes.
///
/// 4. Marker Information Window:
//    - Allow users to tap the marker to open an info window.
//    - Display an info window with "My current location" as the title and the user's latitude and longitude as the snippet.