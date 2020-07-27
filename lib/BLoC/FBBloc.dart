import 'dart:async';  
import 'package:bloc_pattern/bloc_pattern.dart'; 
import 'package:flutter_facebook_login/flutter_facebook_login.dart';  
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:rxdart/subjects.dart'; 

// FBBloc for handling userLogged in state and currentUser data
// Uses: async, htto, JSON for processing the request to Facebooks Graph API to get user's data
//       flutter_facebook_login for allowing facebook login
class FBBloc extends BlocBase  {
  bool isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  final StreamController<bool> _isLoggedInController = BehaviorSubject<bool>();
  Stream<bool> get getIsLoggedIn => _isLoggedInController.stream;


  final StreamController<Map> _userProfileController = BehaviorSubject<Map>();
  Stream<Map> get getUserProfile => _userProfileController.stream; 

  FBBloc(){
    userProfile={};
    handleLoginChange(false);
  }
  // changes login state to val
  void handleLoginChange(bool val){
    isLoggedIn = val;
    _isLoggedInController.add(val);
  }

  //changes current user Profile to newProfile
  void handleProfileChange(Map newProfile){
    userProfile = newProfile;
    _userProfileController.add(newProfile);
  }
  
  //initiates logout for user
  void logout(){
    facebookLogin.logOut();
    handleLoginChange(false);
  }

  
  //this initiates the log in sequence using the users facebook account
  void login() async{

    //initiates the facebook login popup
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      //the user successfully loggedin
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        //through the token, make a request for the users profile data through
        // Facebook's Graph API
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.body);
        //update states
        handleProfileChange(profile);
        handleLoginChange(true);
        break;
      //the user cancells/ closes the popup
      case FacebookLoginStatus.cancelledByUser:
        //update state
        handleLoginChange(false); 
        break;
      // other errors
      case FacebookLoginStatus.error:        
        //updateState
        handleLoginChange(false); 
        break;
    }

  }

  @override
  void dispose() { 
    super.dispose(); 
    _isLoggedInController.close();
    _userProfileController.close(); 
  }


 
}