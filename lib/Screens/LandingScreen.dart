import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';  
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_routes/BLoC/FBBloc.dart';   
import 'package:random_routes/BLoC/GoogleMapBLoC.dart';
import 'package:random_routes/util/NotificationHandler.dart';  

class LandingScreen extends StatefulWidget { 

  LandingScreen();

  @override
  _LandingScreenState createState() => _LandingScreenState();
} 
 
class _LandingScreenState extends State<LandingScreen> {

  GoogleMapController _controller;  
  NotificationHandler notificationHandler;

  @override
  void initState()  {
    super.initState();
    notificationHandler = new NotificationHandler();
  }


  @override
  Widget build(BuildContext context) { 
    final blocGoogleMap = BlocProvider.getBloc<GoogleMapBloc>();
    final blocFB = BlocProvider.getBloc<FBBloc>();
    return StreamBuilder<Map>(
      initialData: {'name':'','email':'','picture':{'data':{'url':'https://via.placeholder.com/50'}} },
      stream: blocFB.getUserProfile,
      builder: (context, ssUserProfile){
        return Scaffold(
          appBar: AppBar(
            title: Text('Random Routes',),
          ),
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height:96),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), 
                      child: Image.network(ssUserProfile.data["picture"]["data"]["url"], height: 50.0, width: 50.0,)
                    ),
                    SizedBox(height: 12,),
                    Text('${ssUserProfile.data["name"]}', 
                      style:TextStyle( fontSize: 24, fontWeight: FontWeight.bold) ,
                    ), 
                    SizedBox(height: 6,),
                    Text('${ssUserProfile.data["email"]}',
                      style: TextStyle(fontSize: 12)
                    )
                  ],
                ), 
                Column(
                  children: <Widget>[
                    OutlineButton( 
                      child: Text("Logout", style: TextStyle(color: Colors.red),), 
                      onPressed: (){ 
                        blocFB.logout(); 
                      },
                    ),
                    SizedBox(height:24),
                  ],
                ), 
              ]
            ),
          ),
          body:StreamBuilder<Set<Polyline>>(
            initialData: {},
            stream: blocGoogleMap.getPolylines,
            builder: (context, ssPolylines){
              return StreamBuilder<Set<Marker>>(
                initialData: {},
                stream: blocGoogleMap.getMarkers,
                builder: (context, ssMarkers){
                  return GoogleMap(
                    onMapCreated: (controller){
                      setState(() {
                        _controller = controller;
                      });
                    },
                    polylines: ssPolylines.data,
                    initialCameraPosition: CameraPosition(target: LatLng(0,0), zoom: 14.0),
                    mapType: MapType.normal,
                    markers: ssMarkers.data,
                  );
                }
              );
            } ,
          ), 
          floatingActionButton: StreamBuilder<LatLng>(
            initialData: LatLng(0,0),
            stream: blocGoogleMap.getUserLocation,
            builder: (context, ssUserLocation){
              return RaisedButton(
                color: Colors.red,
                child: Text('GO SOMEWHERE', style: TextStyle(color: Colors.white)),
                onPressed: (ssUserLocation.hasData)
                ? (){
                  blocGoogleMap.rebuildMap(notificationHandler,ssUserLocation.data , _controller);
                }
                : (){ 
                  blocGoogleMap.getCurrLocation();
                },
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );

  } 

  


 

} 