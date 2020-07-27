import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:random_routes/BLoC/FBBloc.dart'; 
import 'package:random_routes/BLoC/GoogleMapBLoC.dart';  

import 'Screens/HomeScreen.dart'; 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget { 
  final facebookLogin = FacebookLogin()   ;

  @override
  Widget build(BuildContext context) {
    //init Blocs
    return BlocProvider(
      blocs: [ 
        Bloc( (i) =>  GoogleMapBloc() , singleton: true),
        Bloc( (i) =>  FBBloc() , singleton: true),
      ],
      child: MaterialApp(
        home: HomeScreen()
      )
    ); 
  }

}
 