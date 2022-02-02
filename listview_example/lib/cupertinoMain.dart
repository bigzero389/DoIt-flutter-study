import 'package:flutter/cupertino.dart';
import 'package:listview_example/iosSub/cupertinoFirstPage.dart';
import 'animalItem.dart';
import 'iosSub/cupertinoSecondPage.dart';

class CupertinoMain extends StatefulWidget {
  const CupertinoMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CupertinoMain();
  }
}

class _CupertinoMain extends State<CupertinoMain> {
  CupertinoTabBar? tabBar;
  List<Animal> animals = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    tabBar = CupertinoTabBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.add)),
    ]);

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
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoTabScaffold(
        tabBar: tabBar!,
        tabBuilder: (context, value){
          if (value == 0) {
            return CupertinoFirstPage(animalList: animals);
          } else {
            return CupertinoSecondPage(animalList: animals);
          }
        },
      ),
    );
  }
}