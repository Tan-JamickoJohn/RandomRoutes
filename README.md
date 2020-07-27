# random_routes

A Flutter app that uses Google Map API to generate a random route from the users current location.
- Uses BLoC pattern for state management
- Allows login with facebook
- Uses Facebook Graph API to fetch user data


## Getting Started
- Start a new flutter project
- Copy all the files provided here
- Make sure to change any references to 'jamicko.tan.random_routes' (such as in the manifests file) to whatever name you chose to name your app. 
- [The next two steps are can be achieved by following the steps here: ](https://pub.dev/packages/google_maps_flutter)
- Enable Google Maps API and Directions API
- Obtain a google maps API KEY : you will have to include a billing account. However, do not worry since GCP provides a $300 free credit once you add billing details.
- IMPORTANT: without following the last two steps, the route finding will not work. Without a billing account from GCP, you will only be allowed to make one request a day from the Google maps API 
- After obtaining the Google API KEY, copy and paste this key in the GoogleMapBloc.dart and in the AndroidManifest. For your convenience, I added a 'TODO:' above those lines in the respective files. 
- [Follow the steps here to enable login with facebook](https://pub.dev/packages/flutter_facebook_login)
- Again, change any references to 'jamicko.tan.random_routes' to whatever name you chose to name your app.
