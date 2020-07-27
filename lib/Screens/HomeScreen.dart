import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:random_routes/BLoC/FBBloc.dart';
import 'package:random_routes/Screens/LandingScreen.dart';
import 'package:random_routes/Screens/SignInScreen.dart';

//Decider screen between whether or not a user is logged in
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //use bloc to check current state 
    //whether or not a user is logged in
    final blocFB = BlocProvider.getBloc<FBBloc>();
    return StreamBuilder<bool>(
      initialData: false,
      stream: blocFB.getIsLoggedIn,
      builder: (context, ssIsLoggedIn){
        return ssIsLoggedIn.data 
        ? LandingScreen( )
        : Scaffold(
          body: Container(
            child: SignInScreen( 
            )
          ),
        ) ;
      },
    );
  }

  
                    
}