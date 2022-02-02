import 'package:flutter/cupertino.dart';
import '../animalItem.dart';

class CupertinoSecondPage extends StatefulWidget {
  final List<Animal> animalList;

  const CupertinoSecondPage({Key? key, required this.animalList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CupertinoSecondPage();
  }
}

class _CupertinoSecondPage extends State<CupertinoSecondPage> {
  TextEditingController? _textController;
  int _kindChoice = 0;
  bool _isFlyable = false;
  String? _imagePath;
  Map<int, Widget> segmentWidget = {
    0: const SizedBox(child: Text('양서류', textAlign: TextAlign.center,), width: 80,),
    1: const SizedBox(child: Text('포유류', textAlign: TextAlign.center,), width: 80,),
    2: const SizedBox(child: Text('파충류', textAlign: TextAlign.center,), width: 80,),
  };

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('동물 추가'),
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CupertinoTextField(
                controller: _textController,
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            CupertinoSegmentedControl(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              groupValue: _kindChoice,
              children: segmentWidget,
              onValueChanged: (int value){
                setState(() {
                  _kindChoice = value;
                });
              },
            ),
            Row(
              children: [
                const Text('날개가 존재합니까?'),
                CupertinoSwitch(value: _isFlyable, onChanged: (value){
                  setState(() {
                    _isFlyable = value;
                  });
                })
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(child: Image.asset('repo/images/cow.png', width: 100,), onTap: (){ _imagePath = 'repo/images/cow.png'; },),
                  GestureDetector(child: Image.asset('repo/images/bee.png', width: 100,), onTap: (){ _imagePath = 'repo/images/bee.png'; },),
                  GestureDetector(child: Image.asset('repo/images/cat.png', width: 100,), onTap: (){ _imagePath = 'repo/images/cat.png'; },),
                  GestureDetector(child: Image.asset('repo/images/fox.png', width: 100,), onTap: (){ _imagePath = 'repo/images/fox.png'; },),
                  GestureDetector(child: Image.asset('repo/images/monkey.png', width: 100,), onTap: (){ _imagePath = 'repo/images/monkey.png'; },),
                ],
              ),
            ),
            CupertinoButton(
              child: const Text('동물 추가하기'),
              onPressed: (){
                showCupertinoDialog(context: context, builder: (context){
                  return CupertinoAlertDialog(
                    title: const Text('동물 등록'),
                    content: const Text('동물 추가합니까?'),
                    actions: [
                      CupertinoButton(
                        child: const Text('확인'),
                        onPressed: () {
                          widget.animalList.add(Animal(
                            animalName: _textController?.value.text,
                            kind: getKind(_kindChoice),
                            imagePath: _imagePath,
                            isFlyable: _isFlyable,
                          ));
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: const Text('아니오'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },);
             },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  getKind(int radioValue) {
    switch (radioValue) {
      case 0: return '양서류';
      case 1: return '파충류';
      case 2: return '포유류';
    }
  }
}
