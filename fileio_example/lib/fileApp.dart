import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class FileApp extends StatefulWidget {
  const FileApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  int _count = 0;
  List<String> itemList = List.empty(growable: true);
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    readCountFile();
    initData();
  }

  void initData() async {
    var result = await readListFile();
    print('Init Fruit Count: ${itemList.length}');
    print('Init Result Count: $result');

    setState(() {
      itemList.addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Example'),),
      body: Center(
        child: Column(
          children: [
            Text('$_count'),
            TextField(
              controller: controller,
              keyboardType: TextInputType.text,
            ),
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Text(
                      itemList[index], style: TextStyle(fontSize: 30),
                    ),
                  ),
                );
              }, itemCount: itemList.length,),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeFruit(controller.value.text);
          setState(() {
            _count++;
            itemList.add(controller.value.text);
          });
          writeCountFile(_count);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void writeFruit(String fruit) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File(dir.path + '/fruit.txt').readAsString();
    file = file + '\n' + fruit;
    File(dir.path + '/fruit.txt').writeAsStringSync(file);
  }

  Future<List<String>> readListFile() async {
    List<String> itemList = List.empty(growable: true);

    var key = 'isOpened';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isOpened = pref.getBool(key) ?? false;

    var dir = await getApplicationDocumentsDirectory();
    bool fileExist = await File(dir.path + '/fruit.txt').exists();
    print('isOpened::$isOpened, fileExist:$fileExist');

    if (fileExist == false || !isOpened) {
      pref.setBool(key, true);
      var file = await DefaultAssetBundle.of(context).loadString('repo/fruit.txt');
      File(dir.path + '/fruit.txt').writeAsStringSync(file);

      var array = file.split('\n');
      for (var item in array) {
        print('write item::$item');
        itemList.add(item);
      }
      return itemList;
    } else {
      var file = await File(dir.path + '/fruit.txt').readAsString();
      var array = file.split('\n');
      for (var item in array) {
        print('read item::$item');
        itemList.add(item);
      }
      return itemList;
    }
  }

  void writeCountFile(int count) async {
    var dir = await getApplicationDocumentsDirectory();
    File(dir.path + '/count.txt').writeAsString(count.toString());
  }

  void readCountFile() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var cntFromFile = await File(dir.path + '/count.txt').readAsString();
      print(cntFromFile);
      setState(() {
        _count = int.parse(cntFromFile);
      });
    } catch(e) {
      print(e.toString());
    }
  }
}