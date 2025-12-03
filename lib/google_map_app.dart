import 'package:flutter/material.dart';
import 'package:google_map/ui/screen/home_screen.dart';
import 'package:google_map/ui/screen/user_current_location_screen.dart';

class GoogleMapApp extends StatelessWidget {
  const GoogleMapApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: UserCurrentLocationScreen(),
    );
  }

}
