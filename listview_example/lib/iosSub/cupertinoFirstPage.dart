import 'package:flutter/cupertino.dart';
import '../animalItem.dart';

class CupertinoFirstPage extends StatelessWidget {
  final List<Animal> animalList;

  const CupertinoFirstPage({Key? key, required this.animalList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('동물 리스트'),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(5),
            height: 100,
            child: Column(
              children: [
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Image.asset( animalList[index].imagePath!, fit: BoxFit.contain, width: 80, height: 80, ),
                      Text(animalList[index].animalName!),
                    ],
                  ),
                  onLongPress: (){
                    showCupertinoDialog(context: context, builder: (context){
                      return CupertinoAlertDialog(
                        title: const Text('동물 삭제'),
                        content: const Text('동물을 삭제합니까?'),
                        actions: [
                          CupertinoButton(
                            child: const Text('확인'),
                            onPressed: () {
                              animalList.removeAt(index);
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
                Container(
                  height: 2,
                  color: CupertinoColors.black,
                ),
              ],
            ),
          );
        },
        itemCount: animalList.length,
      ),
    );
  }
}
