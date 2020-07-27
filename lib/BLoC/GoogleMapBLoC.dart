import 'dart:async';  
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';   
import 'package:location/location.dart'; 
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math';
import 'package:random_routes/util/NotificationHandler.dart';
import 'package:rxdart/rxdart.dart';


//Google Maps BLoc
// Responsible for handling states for map Markers, Polylines(routes), and the users current location
// Uses: flutter_polyline_points package for drawing the polyline ie route
//       math package for random generator
//       rxdart for a stream builder with multiple listeners
//       google_maps_flutter package for the Map widget, markers, routes calculation
class GoogleMapBloc extends BlocBase  {
  Set<Marker> markers;
  Set<Polyline> polylines;
  LatLng userLocation;

  //some variables needed for drawing the polylines
  List<LatLng> _routeCoords = [];
  PolylinePoints _polylinePoints;
  Map<PolylineId, Polyline> _polylines = {};   



  final StreamController<LatLng> _userLocationController = BehaviorSubject<LatLng>();
  Stream<LatLng> get getUserLocation => _userLocationController.stream;


  final StreamController<Set<Marker>> _markersController = BehaviorSubject<Set<Marker>>();
  Stream<Set<Marker>> get getMarkers => _markersController.stream;

  
  final StreamController<Set<Polyline>> _polylinesController = BehaviorSubject<Set<Polyline>>();
  Stream<Set<Polyline>> get getPolylines => _polylinesController.stream;

  //on bloc load, get the users location
  GoogleMapBloc() { 
    getCurrLocation();
  }

  //gets users location
  getCurrLocation() { 
    try { 
      var location = new Location(); 
      location.getLocation().then((coords) { 
        userLocation = LatLng(
          coords.latitude, 
          coords.longitude,
        ); 
        _userLocationController.sink.add(userLocation);
      });
    } catch (e) {
      print(e);
    }
  } 

  //rebuilds  the map with a new random destination
  rebuildMap(NotificationHandler nf, LatLng currLocation, GoogleMapController c){
    //generate random location
    var rng = new Random(); 
    double signX = (rng.nextInt(10) >= 5) ? -1 : 1;
    double signY = (rng.nextInt(10) >= 5) ? -1 : 1;
    double x = signX * rng.nextInt(2500)/100000;
    double y = signY * rng.nextInt(2500)/100000; 
    LatLng randomLoc = LatLng(
      currLocation.latitude + x , 
      currLocation.longitude + y
    );
    //create route to random location
    _createPolylines(currLocation, randomLoc );
    //send notification regarding new location
    nf.showNotification(randomLoc.latitude, randomLoc.longitude);
    //re position  camera to show new route
    c.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currLocation.latitude, currLocation.longitude),
          zoom: 13,
        ),
      ),
    );
  }
  
  //Given a start and destination, this creates the route and add markers to the 2 locations
  _createPolylines(LatLng start, LatLng destination) async {  
    //clear current route coords
    Set<Marker> tempMarkers = {};
    _routeCoords = [];
    _polylinePoints = PolylinePoints();
    //generate polylines
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      //TODO: ADD YOUR GOOGLE MAPS API KEY BELOW
      "your google maps API key", // Google Maps API Key 
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );
    // add coordinates to list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _routeCoords.add(LatLng(point.latitude, point.longitude));
      });
    } 
    PolylineId id = PolylineId('route');
    // Initialize
    Polyline polyline = Polyline(
      polylineId: id ,
      color: Colors.red,
      points: _routeCoords,
      width: 3,
    );
    // add polyline to the mmap
    _polylines[id] = polyline;

    polylines = Set<Polyline>.of(_polylines.values);
    _polylinesController.sink.add(polylines);

    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId('startCoordinates'),
      position: LatLng(start.latitude, start.longitude),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('destinationCoordinates'),
      position: LatLng( destination.latitude, destination.longitude),
      icon: BitmapDescriptor.defaultMarker,
    );


    //add markers 
    tempMarkers.add(startMarker);
    tempMarkers.add(destinationMarker);
    _markersController.sink.add(tempMarkers);
  }
  
 
  @override
  void dispose() { 
    super.dispose(); 
    _markersController.close();
    _polylinesController.close();
    _userLocationController.close();
  }

 
}