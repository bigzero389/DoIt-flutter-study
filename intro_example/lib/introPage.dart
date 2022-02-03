import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  Widget logo = Icon(Icons.info, size: 50,);

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    var dir = await getApplicationDocumentsDirectory();
    bool isFileExist = await File(dir.path + '/myimage.jpg').exists();
    if (isFileExist) {
      setState(() {
        logo = Image.file(
          File(dir.path + '/myimage.jpg'),
          height: 200,
          width: 200,
          fit: BoxFit.contain,
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            logo,
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return const MyHomePage(title: '');
                })
              );
            }, child: const Text('다음으로 가기'))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
