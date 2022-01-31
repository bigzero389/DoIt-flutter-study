import 'package:flutter/material.dart';
import '../animalItem.dart';

class FirstApp extends StatelessWidget {
  final List<Animal>? animalList;
  const FirstApp({Key? key, this.animalList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(itemBuilder: (context, position){
          return GestureDetector(
            child: Card(
              child: Row(
                children: <Widget>[
                  Image.asset(animalList![position].imagePath!),
                  Text(animalList![position].animalName!),
                ],
              ),
            ),
            onTap: (){
              AlertDialog dialog = AlertDialog(
                content: Text('이 동물은 ${animalList![position].kind}입니다.', style: const TextStyle(fontSize: 30.0),),
              );
              showDialog(context: context, builder: (BuildContext context){ return dialog; });
            },
            onLongPress: (){
              AlertDialog dialog = AlertDialog(
                content: Text('이 동물은 ${animalList![position].animalName} 입니다. 삭제하시겠습니까?', style: const TextStyle(fontSize: 30.0),),
                actions: [
                  ElevatedButton(onPressed: (){
                    animalList?.removeAt(position);
                    Navigator.of(context).pop();
                  }, child: const Text('예')),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: const Text('아니요')),
                ],
              );
              showDialog(context: context, builder: (BuildContext context){ return dialog; });
            },
          );
        }, itemCount: animalList!.length,),
      ),
    );
  }
}