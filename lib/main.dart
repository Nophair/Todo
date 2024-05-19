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
      theme: ThemeData(
        fontFamily: 'NoyhR',
        colorScheme: ThemeData().colorScheme.copyWith(primary: Color(0xFF2fe48d)),
        datePickerTheme: ThemeData().datePickerTheme.copyWith(backgroundColor: Colors.white),
          timePickerTheme: ThemeData().timePickerTheme.copyWith(
            backgroundColor: Colors.white,
            dayPeriodColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? const Color(0xFF2fe48d) : Colors.grey.withOpacity(0.2)),
            dayPeriodTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.white : Colors.black),
            dayPeriodBorderSide: const BorderSide(color: Color(0xFF2fe48d),width: 2),
            dialBackgroundColor: Colors.grey.withOpacity(0.2),
            entryModeIconColor: const Color(0xFF2fe48d),
            hourMinuteColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? const Color(0xFF2fe48d) : Colors.grey.withOpacity(0.2)),
            hourMinuteTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.white : Colors.black),
          )
      ),
    );
  }
}