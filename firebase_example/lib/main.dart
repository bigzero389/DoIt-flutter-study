import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/tabsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'memoPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      // home: FirebaseApp( analytics: analytics, observer: observer, ),
      // home: const MemoPage(),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _initFirebaseMessaging(context);
            _getToken();
            return const MemoPage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _initFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.title);
      print(event.notification!.body);
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(event.notification!.body!),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: const Text('OK'))
          ],
        );
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) { });
  }

  _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    print("messaging.getToken(), ${await messaging.getToken()}");
  }
}

class FirebaseApp extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const FirebaseApp({Key? key, required this.analytics, required this.observer}) : super(key: key);

  @override
  _FirebaseAppState createState() {
    return _FirebaseAppState(analytics, observer);
  }
}

class _FirebaseAppState extends State<FirebaseApp> {
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  String _message = '';

  _FirebaseAppState(this.analytics, this.observer);

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'bigzero_test_event',
      parameters: <String, dynamic> {
        'String': 'hello bigzero flutter',
        'int': 100,
      }
    );
    setMessage('Analytics 보내기 성공');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Example'),),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {
              _sendAnalyticsEvent();
            }, child: const Text('테스트')),
            Text(_message, style: const TextStyle(color: Colors.blueAccent),)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.tab),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<TabsPage>(
            builder: (BuildContext context) {
              return TabsPage(observer);
            } ,
            settings: RouteSettings(name: '/tabs') )
          );
        },
      ),
    );
  }
}