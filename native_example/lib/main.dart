import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'sendDataExample.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoApp(
        home: CupertinoNativeApp(),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
         primarySwatch: Colors.blue,
        ),
        // home: NativeApp(),
        // home: SendDataExample(),
        home: NativeApp(),
      );
    }
  }
}

class CupertinoNativeApp extends StatefulWidget {
  const CupertinoNativeApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class NativeApp extends StatefulWidget {
  const NativeApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class _NativeApp extends State<NativeApp> {
  String _deviceInfo = 'Unknown info';
  static const platform = MethodChannel('com.flutter.dev/info');
  static const platform3 = MethodChannel('com.flutter.dev/dialog');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native 통신 예제'),),
      body: Center(
        child: Column(
          children: [
            Text(_deviceInfo, style: const TextStyle(fontSize: 30),),
            TextButton(onPressed: () {
              _showDialog();
            }, child: const Text('네이티브 창 열기'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getDeviceInfo();
        }, child: const Icon(Icons.get_app),
      ),
    );
  }

  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = 'Device info : $result';
    } on PlatformException catch(e) {
      deviceInfo = 'Failed to get Device info: ${e.message}';
    }
    print('DeviceInfo : '+ deviceInfo);
    setState(() {
      _deviceInfo = deviceInfo;
    });
  }

  Future<void> _showDialog() async {
    try{
      await platform3.invokeMethod('showDialog');
    } on PlatformException catch(e) {

    }
  }
}
