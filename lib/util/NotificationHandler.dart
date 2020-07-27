import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Utility class used for showing destination notification
// Uses: flutter_local_notifications package: for showing the notifications
class NotificationHandler {
  
  FlutterLocalNotificationsPlugin _flnp;
  var initSettingsAndroid;
  var initSettingsIOS;
  var initSettingsGen;
  
  //init all settings
  NotificationHandler(){ 
    _flnp = new FlutterLocalNotificationsPlugin();
    initSettingsAndroid = new AndroidInitializationSettings('app_icon');
    initSettingsIOS = new IOSInitializationSettings();
    initSettingsGen = new InitializationSettings(initSettingsAndroid, initSettingsIOS);
    _flnp.initialize(initSettingsGen, onSelectNotification: onSelectNotification);
  }
   
  Future onSelectNotification(String payload) async{
    if (payload!=null){ 
    }
  }


  void showNotification( double lat, double long) async{
    await _getNotification(lat, long);
  }

  Future<void> _getNotification(double lat, double long) async{
    var androidPlatformSpecifics = AndroidNotificationDetails(
      'channelId', 
      'channelName', 
      'channelDescription',
      importance: Importance.Max,
      priority: Priority.High,
      ticker:'test ticker'
    );
    var iOSPlatformSpecifics = IOSNotificationDetails();
    var platformSpecifics = NotificationDetails(androidPlatformSpecifics, iOSPlatformSpecifics);
    await _flnp.show(0, 'Your New Destination', '$lat, $long', platformSpecifics, payload: 'payload');
  }
}