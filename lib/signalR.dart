import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SignalRProvider with ChangeNotifier {
  late HubConnection hubC;
  late Function onMessageReceived;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Getter to access the SignalR connection state
  HubConnectionState? get connectionState => hubC.state;

  // Constructor to initialize SignalR
  SignalRProvider({required this.onMessageReceived}) {
    initializeSignalR();
  }
  Future<void> initializeLocalNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void receiveMessage(List<Object?>? parameters) {
    if (parameters != null && parameters.length == 2) {
      int fromUserId = parameters[0] as int;
      Map<String, dynamic> messageData = parameters[1] as Map<String, dynamic>;

      int toUserId = messageData['to'] as int;
      int productId = messageData['productId'] as int;
      String text = messageData['text'] as String;
      // Extract other properties as needed

      print('Received message from $fromUserId to $toUserId: $text');

      if (messageData['subtype'] == 'msg') {
        showNotification(text);
      }

      // You can use the extracted information for further processing or display.

      // Invoke the callback function provided during initialization
      onMessageReceived();

      // Show notification or handle the message as needed
    } else {
      print('Invalid parameters for received message');
    }
  }

  Future<void> showNotification(String msg) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '369', // Change this to a unique ID for your app
      'New message',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      msg,
      platformChannelSpecifics,
    );
  }

  // SignalR initialization logic
  Future<void> initializeSignalR() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      // print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    final hubProtLogger = Logger("SignalR - hub");
    final transportProtLogger = Logger("SignalR - transport");
    final serverUrl = "https://devapi.get-ug.com/home?userId=126";
    final httpOptions = HttpConnectionOptions(logger: transportProtLogger);

    hubC = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpOptions)
        .configureLogging(hubProtLogger)
        .build();

    try {
      await hubC.start();
      print('SignalR connection state: ${hubC.state}');
      hubC.on("ReceiveMessage", receiveMessage);
      initialiseChat();
      await initializeLocalNotifications();
    } catch (e) {
      print('Error starting SignalR connection: $e');
    }
  }

  // Function to check if the HubConnection is already established
  bool isHubConnectionEstablished() {
    return hubC.state == HubConnectionState.Connected;
  }

  // Method to handle received messages

  Future<void> initialiseChat() async {
    try {
      if (isHubConnectionEstablished()) {
        hubC.on("ReceiveMessage", receiveMessage);
        print('Receive message function called 1');
      } else {
        print('Hub connection is not established.');
      }
    } catch (e) {
      print('Error initializing chat: $e');
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String recipientId,
    required String productId,
    required String message,
    required String msgType,
    required String? file,
    required String subtype,
    required String fileName,
  }) async {
    try {
      if (!isHubConnectionEstablished()) {
        print(
            'SignalR connection is not initialized. Attempting to reconnect...');
        await initializeSignalR();
        if (!isHubConnectionEstablished()) {
          print('Reconnection failed. Message not sent.');
          return;
        }
      }

      int parsedProductId = int.tryParse(productId) ?? 0;

      String fileToSend = file ?? '';

      int sid = int.parse(senderId);
      int rid = int.parse(recipientId);
      int pid = int.parse(productId);

      List<Object> data = [
        rid,
        sid,
        pid,
        message,
        msgType,
        fileToSend,
        subtype,
        fileName
      ];
      await hubC.invoke(
        'SendPrivateMessage',
        args: data,
      );

      // await hubC.invoke('SendPrivateMessage');
    } catch (error) {
      print('Error sending message: $error');
      print(senderId);
      print(recipientId);
      print(productId);
      print(message);
      print(msgType);
      print(file);
      print(subtype);
      print(fileName);
    }
  }

  Future<void> sendAudioMessage({
    required String senderId,
    required String recipientId,
    required String productId,
    required String message,
    required String msgType,
    required String file,
    required String subtype,
    required String fileName,
  }) async {
    try {
      if (!isHubConnectionEstablished()) {
        print(
            'SignalR connection is not initialized. Attempting to reconnect...');
        await initializeSignalR();
        if (!isHubConnectionEstablished()) {
          print('Reconnection failed. Message not sent.');
          return;
        }
      }

      int parsedProductId = int.tryParse(productId) ?? 0;
      // Object fileToSend = file ?? '';

      int sid = int.parse(senderId);
      int rid = int.parse(recipientId);
      int pid = int.parse(productId);

      List<Object> data = [
        rid,
        sid,
        pid,
        message,
        msgType,
        file,
        subtype,
        fileName
      ];
      await hubC.invoke(
        'SendPrivateMessage',
        args: data,
      );
      print("Audio send true ---------------------------------------");
    } catch (error) {
      print('Error sending message: $error');
      print(senderId);
      print(recipientId);
      print(productId);
      print(message);
      print(msgType);
      // print(file);
      print(subtype);
      print(fileName);
    }
  }

  @override
  void dispose() {
    hubC.off('ReceiveMessage');
    hubC.stop();
    super.dispose();
  }
}
