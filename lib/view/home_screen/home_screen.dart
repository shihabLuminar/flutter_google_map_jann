import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = new Location();
  LatLng kakkanadPoints = LatLng(10.0159, 76.3419);
  LatLng csezPoints = LatLng(10.0039, 76.3430);
  LatLng? myLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getLocationUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: kakkanadPoints, zoom: 13),
              markers: {
                Marker(
                    markerId: MarkerId("kakkanad"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: kakkanadPoints),
                Marker(
                    markerId: MarkerId("csez"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: csezPoints),
                Marker(
                    markerId: MarkerId("myLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: myLocation!)
              },
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        log("denied1");

        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        log("denied");
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentUserLocation) {
      print(currentUserLocation.latitude.toString());
      print(currentUserLocation.longitude.toString());
      if (currentUserLocation.latitude != null &&
          currentUserLocation.longitude != null) {
        setState(() {
          myLocation = LatLng(
              currentUserLocation.latitude!, currentUserLocation.longitude!);
          print(myLocation?.toString());
        });
      }
    });
  }
}
