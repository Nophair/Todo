import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todo_list/layout/home_layout.dart';
import 'package:todo_list/shared/bloc_observer.dart';


void main() async {
  Bloc.observer = MyBlocObserver();
  await AwesomeNotifications().initialize(
    'resource://drawable/tasks2', [
    NotificationChannel(
      channelGroupKey:'high_importance_channel_group',
      channelKey: 'high_importance_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      // defaultColor: const Color(0xFFde2821),
      // ledColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      onlyAlertOnce: true,
      playSound: true,
      criticalAlerts: true,
      enableVibration: true,
    ),
    NotificationChannel(
      channelGroupKey:'high_importance_channel_group',
      channelKey: 'schedule',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      // defaultColor: const Color(0xFFde2821),
      // ledColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      onlyAlertOnce: true,
      playSound: true,
      criticalAlerts: true,
      enableVibration: true,
    ),
  ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'high_importance_channel_group',
        channelGroupName: 'Group 1',
      )
    ],
    debug: true,
  );
  bool isAllowedToSendNotification =
  await AwesomeNotifications().isNotificationAllowed();
  if (isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}