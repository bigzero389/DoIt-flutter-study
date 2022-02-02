import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubPage Example',
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {'/': (context) => FirstPage(), '/second' : (context) => SecondPage(), },
      // home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Sub Page Main'),
     ),
     body: const Center(
       child: Text('첫 번째 페이지'),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (context) { return SecondPage(); }));
       },
       child: const Icon(Icons.add),
     ),
   );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Pgae'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();  // 지금 페이지 종료.
          },
          child: Text('돌아가기'),
        ),
      ),
    );
  }
}
