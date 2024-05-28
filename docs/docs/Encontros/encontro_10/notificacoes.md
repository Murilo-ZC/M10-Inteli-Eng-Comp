---
sidebar_position: 4
title: Implementando Notificações Locais
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Notificações Locais

Pessoal, vamos desenvolver um projeto que faz a implementação de notificações locais. Para isso, vamos utilizar a biblioteca [Awesome Notifications](https://pub.dev/packages/awesome_notifications), como já apresentado nos autoestudos anteriores. Nosso projeto vai focar apenas em realizar a implementação destas notificações em um primeiro momento. Vamos lá 🤖!

### Instalação das dependências e configuração do projeto

Primeiro vamos instalar nossas dependências. Para isso, vamos adicionar a biblioteca Awesome Notifications ao nosso arquivo `pubspec.yaml`:

```yaml
dependencies:
  awesome_notifications: ^0.9.3+1
```

Ou ainda, podemos adicionar ela diretamente no terminal:

```bash
flutter pub add awesome_notifications
```

Após isso, vamos rodar o comando `flutter pub get` para baixar as dependências.

Agora vamos configurar nosso projeto para que ele consiga trabalhar com as notificações.

:::danger[IMPORTANTE]

As configurações a seguir são apresentadas para projetos desenvolvidos para o sistema operacional Android. Caso você deseje implementar as notificações para o sistema operacional iOS, é necessário realizar as configurações específicas para este sistema. Verificar a documentação do pacote. O mesmo vale para os demais sistemas operacionais.

:::

Para utilizar o pacote do Awesome Notifications, é necessário ajustar alguns arquivos de configuração do projeto. Primeiro, vamos ajustar as ferramentas mínimas necessárias para que ele possa ser utilizado. Para isso, vamos editar o arquivo `android/app/build.gradle` e adicionar a seguinte configuração:

```gradle
buildscript {
    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
    }
}

plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

android {
    namespace "com.example.notificacoes"
    compileSdk flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion
    compileSdkVersion 34

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.notificacoes"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        // minSdkVersion flutter.minSdkVersion
        // targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        minSdkVersion 21
        targetSdkVersion 34
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}



dependencies {}

```

Essa mudança traz algumas implicações:

- Sobe o `minSdkVersion` para 21, o que significa que o projeto agora é compatível com o Android 5.0 em diante.

Essa alteração é importante, pois, caso necessário realizar a construção do projeto para versão anterior do Android, não será possível utilizar o pacote Awesome Notifications.

Agora vamos ajustar o arquivo `android/app/src/main/AndroidManifest.xml` para adicionar as permissões necessárias para que o pacote possa funcionar corretamente. Adicione as seguintes permissões:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
   <!-- Código anterior omitido para facilitar a leitura -->

    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.WAKE_LOCK" />
</manifest>

```

O que fizemos aqui foi adicionar as permissões necessárias para que o pacote possa funcionar corretamente. A primeira permissão é para que o dispositivo possa vibrar ao receber uma notificação, e a segunda é para que o aplicativo possa receber notificações mesmo após o dispositivo ser reiniciado.

As configurações do projeto estão prontas. Contudo, ainda vamos precisar de mais algumas configurações de código para que o nosso projeto funcione corretamente. Vamos lá!


### Desenvolvendo as dependências de código

Agora vamos inicializar nosso plug-in de notificações. Vamos criar o arquivo `lib/notifications.dart` e adicionar o seguinte código:

```dart
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
```

Pessoal vamos compreender o que fizemos aqui:

- Importamos o pacote Awesome Notifications e o pacote Material do Flutter;
- Criamos uma função `initNotifications` que inicializa o pacote de notificações;
- Inicializamos o pacote de notificações com o método `initialize` do pacote Awesome Notifications;
- Passamos como parâmetros o ícone da notificação, as configurações do canal de notificação e o grupo de canais de notificação. Aqui cabe um nível maior de detalhamento:
    - O ícone da notificação é o ícone que será exibido na notificação. Caso você queira utilizar o ícone padrão do aplicativo, basta passar `null` como parâmetro;
    - O canal de notificação é o canal pelo qual a notificação será enviada. Aqui passamos o grupo de canais de notificação, a chave do canal, o nome do canal, a descrição do canal, a cor padrão do canal e a cor do LED da notificação;
    - O grupo de canais de notificação é o grupo de canais que será exibido no aplicativo. Aqui passamos a chave do grupo de canais e o nome do grupo de canais.

As informações de canais e grupos de notificação são importantes para que possam gerenciar as notificações de forma mais organizada. Por exemplo, você pode ter um canal de notificação para notificações de chat e outro canal de notificação para notificações de sistema. Isso permite que o usuário possa gerenciar as notificações de forma mais eficiente, liberando um tipo de notificação e bloqueando outro. Mais informações podem ser obtidas [aqui](https://developer.android.com/develop/ui/views/notifications/channels?hl=pt-br) e [aqui](https://medium.com/@ChanakaDev/android-channels-in-flutter-003907b151e5).

Agora vamos chamar a função `initNotifications` no arquivo `lib/main.dart`:

```dart

```

