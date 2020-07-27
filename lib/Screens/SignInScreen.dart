import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart'; 
import 'package:random_routes/BLoC/FBBloc.dart'; 


// Sign in Screen
// Uses: FBBloc: for managing isLoggedin State
class SignInScreen extends StatelessWidget { 
  final blocFB = BlocProvider.getBloc<FBBloc>();
  SignInScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome to '),
          SizedBox(height: 12,),
          Text('Random Routes', style:TextStyle(fontSize: 24, fontWeight:FontWeight.bold)),
          SizedBox(height: 24,),
          RaisedButton(
            color: Colors.blue,
            child: Text("CONTINUE WITH FACEBOOK", style:TextStyle(color: Colors.white)),
            onPressed: () async{ 
              blocFB.login();
            },
          ),
        ],
      )
    );

  }

}