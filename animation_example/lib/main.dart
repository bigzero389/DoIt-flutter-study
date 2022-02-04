import 'package:animation_example/people.dart';
import 'package:animation_example/secondPage.dart';
import 'package:animation_example/sliverPage.dart';
import 'package:flutter/material.dart';

import 'intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const AnimationApp(title: 'animation_example'),
      home: const IntroPage(),
    );
  }
}

class AnimationApp extends StatefulWidget {
  const AnimationApp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _AnimationApp();
}

class _AnimationApp extends State<AnimationApp> {
  List<People> peoples = List.empty(growable: true);
  Color weightColor = Colors.blue;
  int current = 0;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    peoples.add(People('Smith', 180, 92));
    peoples.add(People('Merry', 162, 55));
    peoples.add(People('John', 177, 75));
    peoples.add(People('Batt', 130, 40));
    peoples.add(People('Corn', 194, 140));
    peoples.add(People('Didi', 100, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: SizedBox(
                child: Row(
                  children: <Widget>[
                    SizedBox( width: 100, child: Text('Name : ${peoples[current].name}'), ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: Curves.bounceIn,
                      color: Colors.blue,
                      child: Text( 'Height: ${peoples[current].height}', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center, ),
                      width: 50,
                      height: peoples[current].height,
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInCubic,
                      color: weightColor,
                      child: Text( 'Weight: ${peoples[current].weight}', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center, ),
                      width: 50,
                      height: peoples[current].weight,
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: Curves.linear,
                      color: Colors.pinkAccent,
                      child: Text( 'BMI: ${peoples[current].BMI?.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center, ),
                      width: 50,
                      height: peoples[current].BMI,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                height: 200,
              ),
            ),
            ElevatedButton( onPressed: () {
              setState(() {
                if (current < peoples.length - 1) current++;
                _changeWeightColor(peoples[current].weight);
              });
            }, child: const Text('다음')),
            ElevatedButton( onPressed: () {
              setState(() {
                if (current > 0) current--;
                _changeWeightColor(peoples[current].weight);
              });
            }, child: const Text('이전')),
            ElevatedButton( onPressed: () {
              setState(() {
                _opacity == 1 ? _opacity = 0 : _opacity = 1 ;
              });
            }, child: const Text('사라지기')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondPage()));
              },
              child: SizedBox(
                width: 200,
                child: Row(
                  children: const [
                    Hero(tag: 'tag', child: Icon(Icons.cake)),
                    Text('이동하기'),
                  ],
                ),
            )),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SliverPage()));
            }, child: const Text('페이지이동'))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondPage()));
        },
        tooltip: '두번째 페이지로.',
        child: const Icon(Icons.cake),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _changeWeightColor(double weight) {
    if (weight < 40) {
      weightColor = Colors.blueAccent;
    } else if (weight < 60) {
      weightColor = Colors.indigo;
    } else if (weight < 80) {
      weightColor = Colors.orange;
    } else {
      weightColor = Colors.red;
    }
  }
}
