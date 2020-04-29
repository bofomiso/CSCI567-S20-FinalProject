import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_map_place/search_map_place.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _mapController = Completer(); 
  //Position position;
  static LatLng initialPosition;

  void getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
    initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState(){
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
       title:Text('Map'),
      ),
      body: initialPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) :
        Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 15.0 
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
            Positioned(
              top:50,
              left: MediaQuery.of(context).size.width * 0.1,
              child: SearchMapPlaceWidget(
                apiKey: "AIzaSyCfTC1EkyNxIsaxjJXcF9jM50ZXvi41GPE",
                location: initialPosition,
                radius: 10000, //in meters
                strictBounds: true,
                
                onSelected: (Place place) async {
                  final geolocation = await place.geolocation;
                  final GoogleMapController controller = await _mapController.future;
                  controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                  controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
            ),
          ],
        ),
      );
    }
  }
