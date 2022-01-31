import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Widget Example';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: WidgetApp(),
    );
  }
}

class WidgetApp extends StatefulWidget {
  const WidgetApp({Key? key}) : super(key: key);

  @override
  _WidgetExampleState createState() => _WidgetExampleState();
}

class _WidgetExampleState extends State<WidgetApp> {
  String sum = '';
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();

  final List _buttonList = ['더하기', '빼기', '곱하기', '나누기'];
  List<DropdownMenuItem<String>> _dropDownMenuItems = new List.empty(growable: true);

  String? _buttonText;
  String? _iconText;

  @override
  void initState() {
    super.initState();
    for(var item in _buttonList) {
      _dropDownMenuItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    _buttonText = _dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('Widget Example'), ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding( padding: EdgeInsets.all(15), child: Text('flutter'), ),
            Padding( padding: const EdgeInsets.only(left: 20, right: 20), child: TextField(keyboardType: TextInputType.number, controller: value1,),),
            Padding( padding: const EdgeInsets.only(left: 20, right: 20), child: TextField(keyboardType: TextInputType.number, controller: value2,),),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add),
                    Text(_buttonText! + '[' + _iconText! + ']'),
                  ],
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
                onPressed: (){
                  setState(() {
                    var value1Int = double.parse(value1.value.text);
                    var value2Int = double.parse(value2.value.text);
                    var result;
                    if (_buttonText == '더하기') {
                      result = value1Int + value2Int;
                    } else if (_buttonText == '빼기') {
                      result = value1Int - value2Int;
                    } else if (_buttonText == '곱하기') {
                      result = value1Int * value2Int;
                    } else if (_buttonText == '나누기') {
                      if (value2Int != 0) {
                        result = value1Int / value2Int;
                      } else {
                        result = 'ERROR : divide zero !!';
                      }
                    } else {
                      result = 'ERROR : calculation type!!';
                    }
                    sum = result.toString();
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: DropdownButton(items: _dropDownMenuItems, onChanged: (String? value){
               setState(() {
                 _buttonText = value;
                 if (value == "더하기") {
                   _iconText = "+";
                 } else if (value == "빼기") {
                   _iconText = "-";
                 } else if (value == "곱하기") {
                   _iconText = "X";
                 } else {
                   _iconText = "/";
                 }
               });
              }, value: _buttonText,),
            ),
            Padding( padding: const EdgeInsets.all(15), child: Text('결과: $sum',style: const TextStyle(fontSize: 20),)),
          ],
        ),
      ),
   );
  }
}
