import 'package:flutter/material.dart';
import 'package:listview_example/sub/firstPage.dart';
import 'sub/firstPage.dart';
import 'sub/secondPage.dart';
import './animalItem.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  TabController? controller;
  List<Animal> animals = new List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Example'),),
      body: TabBarView(
        children: <Widget>[FirstApp(animalList: animals), SecondApp(animalList: animals,)],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(tabs: const <Tab>[
        Tab(icon: Icon(Icons.looks_one, color: Colors.blue,)),
        Tab(icon: Icon(Icons.looks_two, color: Colors.blue,))
      ], controller: controller,),

    );
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    animals.add(Animal(animalName: "bee", kind: "곤충", imagePath: "repo/images/bee.png"));
    animals.add(Animal(animalName: "cat", kind: "포유류", imagePath: "repo/images/cat.png"));
    animals.add(Animal(animalName: "cow", kind: "포유류", imagePath: "repo/images/cow.png"));
    animals.add(Animal(animalName: "dog", kind: "포유류", imagePath: "repo/images/dog.png"));
    animals.add(Animal(animalName: "fox", kind: "포유류", imagePath: "repo/images/fox.png"));
    animals.add(Animal(animalName: "monkey", kind: "영장류", imagePath: "repo/images/monkey.png"));
    animals.add(Animal(animalName: "pig", kind: "포유류", imagePath: "repo/images/pig.png"));
    animals.add(Animal(animalName: "wolf", kind: "포유류", imagePath: "repo/images/wolf.png"));
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}

