import 'package:flutter/material.dart';
import '../animalItem.dart';

class SecondApp extends StatefulWidget {
  List<Animal>? animalList;
  SecondApp({Key? key, this.animalList}) : super(key :key);
  @override
  State<StatefulWidget> createState() { return _SecondApp(); }
}

class _SecondApp extends State<SecondApp> {
  final nameController = TextEditingController();
  int? _radioValue = 0;
  bool? isFlyable = false;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField( controller: nameController, keyboardType: TextInputType.text, maxLines: 1, ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio(value: 0, groupValue: _radioValue, onChanged: _radioChange,), const Text('양서류'),
                Radio(value: 1, groupValue: _radioValue, onChanged: _radioChange,), const Text('파충류'),
                Radio(value: 2, groupValue: _radioValue, onChanged: _radioChange,), const Text('포유류'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('날 수 있나요?'), Checkbox(value: isFlyable, onChanged: (bool? check){
                  setState(() {
                    isFlyable = check;
                  });
                },)
              ],
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector( child: Image.asset('repo/images/cow.png', width: 80), onTap: (){ _imagePath = 'repo/images/cow.png'; print(_imagePath);}, ),
                  GestureDetector( child: Image.asset('repo/images/bee.png', width: 80), onTap: (){ _imagePath = 'repo/images/bee.png'; print(_imagePath);}, ),
                  GestureDetector( child: Image.asset('repo/images/pig.png', width: 80), onTap: (){ _imagePath = 'repo/images/pig.png'; print(_imagePath);}, ),
                  GestureDetector( child: Image.asset('repo/images/cat.png', width: 80), onTap: (){ _imagePath = 'repo/images/cat.png'; print(_imagePath);}, ),
                  GestureDetector( child: Image.asset('repo/images/fox.png', width: 80), onTap: (){ _imagePath = 'repo/images/fox.png'; print(_imagePath);}, ),
                  GestureDetector( child: Image.asset('repo/images/monkey.png', width: 80), onTap: (){ _imagePath = 'repo/images/monkey.png'; print(_imagePath);}, ),
                ],
              ),
            ),
            ElevatedButton(onPressed: (){
              var animal = Animal(
                animalName: nameController.value.text,
                kind: getKind(_radioValue),
                imagePath: _imagePath,
                isFlyable: isFlyable,
              );
              AlertDialog dialog = AlertDialog(
                title: const Text('동물 추가하기'),
                content: Text(
                  '이 동물은 ${animal.animalName} 입니다.'
                  '또 동물의 종류는 ${animal.kind} 입니다. \n이 동물을 추가하시겠습니까?',
                  style: const TextStyle(fontSize: 30.0),
                ),
                actions: [
                  ElevatedButton(onPressed: (){
                    print('before::${widget.animalList?.length} ');
                    widget.animalList?.add(animal);
                    Navigator.of(context).pop();
                    print('after::${widget.animalList?.length} ');
                  }, child: const Text('예')),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: const Text('아니요')),
                ],
              );
              showDialog(context: context, builder: (BuildContext context){ return dialog; });
            }, child: const Text('동물 추가하기'))
          ],
        ),
      ),
    );
  }

  _radioChange(int? value) {
    setState(() {
      _radioValue = value;
    });
  }

  getKind(int? radioValue) {
    switch (radioValue) {
      case 0: return "양서류";
      case 1: return "파충류";
      case 2: return "포유류";
    }
  }

}