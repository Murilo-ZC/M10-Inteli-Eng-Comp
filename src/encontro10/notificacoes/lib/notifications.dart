// lib/notifications.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> initNotifications() async{
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true
  );
}

// Verifica se as notificações estão ativadas
Future<bool> checkNotificationPermission() async{
  return await AwesomeNotifications().isNotificationAllowed();
}

// Pede para o usuário ativar as notificações
Future<void> requestNotificationPermission() async{
  await AwesomeNotifications().requestPermissionToSendNotifications();
}