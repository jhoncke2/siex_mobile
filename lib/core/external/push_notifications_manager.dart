import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:siex/core/domain/entities/push_notification.dart';

abstract class PushNotificationsTokenGetter{
  Future<String> getPushNotificationsToken();
}

abstract class PushNotificationsManager extends PushNotificationsTokenGetter{
  Future<void> initFirebase();
  void setOnAppNotificationManagement(Function(PushNotification) function);
  void setOnOpenAppFromNotificationManagement(Function(PushNotification) function);
}

class PushNotificationsManagerImpl implements PushNotificationsManager{
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  const PushNotificationsManagerImpl({
    required this.localNotificationsPlugin
  });
  @override
  Future<void> initFirebase()async{
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getInitialMessage();
    var androidInitialize = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payLoad){
        print('**************** on selected notification ******************');
        print(payLoad??'');
    });
    FirebaseMessaging.onMessage.listen((message)async{
      final bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true
      );
      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true
      );
      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics
      );
      await localNotificationsPlugin.show(
        0, 
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['title']
      );
    });
  }

  @override
  Future<String> getPushNotificationsToken()async{
    return (await FirebaseMessaging.instance.getToken()) ?? '';
  }

  @override
  void setOnAppNotificationManagement(Function(PushNotification pushNotification) function) {
    FirebaseMessaging.onMessage.listen((message) {

    });
  }

  @override
  void setOnOpenAppFromNotificationManagement(Function(PushNotification pushNotification) function) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final pushNotification = PushNotification(
        title: message.notification!.title??'', 
        body: message.notification!.body??'', 
        requestId: message.data['request_id']
      );
      function(pushNotification);
    });
  }
}