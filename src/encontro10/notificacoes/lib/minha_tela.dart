import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notificacoes/notifications.dart';

class MinhaTela extends StatelessWidget {
  const MinhaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Teste de Notificações'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Enviar Notificação'),
          onPressed: () async {
            // Realiza o envio da notificação
            if (await checkNotificationPermission()) {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 10,
                  channelKey: 'basic_channel',
                  title: 'Minha Notificação',
                  body: 'Esta é a minha primeira notificação',
                ),
              );
            } else {
              await requestNotificationPermission();
            }
          },
        ),
      ),
    );
  }
}
