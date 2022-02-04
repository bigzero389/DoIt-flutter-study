import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SendDataExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SendDataExample();
}

class _SendDataExample extends State<SendDataExample> {
  static const platform = const MethodChannel('com.flutter.dev/encrypto');

  TextEditingController controller = TextEditingController();
  String _changeText = 'Nothing';
  String _reChangedText = 'Nothing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Data Example'),),
      body: Center(
        child: Column(
          children: [
            TextField(controller: controller, keyboardType: TextInputType.text,),
            SizedBox(height: 20,),
            Text(_changeText, style: TextStyle(fontSize: 20),),
            const SizedBox( height: 20, ),
            ElevatedButton(onPressed: () {
              _decodeText(_changeText);
            }, child: const Text('디코딩하기')),
            const SizedBox( height: 20, ),
            Text(_reChangedText, style: const TextStyle(fontSize: 20),),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sendData(controller.value.text);
        }, child: Text('변환'),
      ),
    );
  }

  Future<void> _sendData(String text) async {
    final String result = await platform.invokeMethod('getEncrypto', text); // 네이티브로 전달할 데이터 지정.
    print('SendData : $result');
    setState(() {
      _changeText = result;
    });
  }

  void _decodeText(String changeText) async {
    final String result = await platform.invokeMethod('getDecode', changeText); // 네이티브로 전달할 데이터 지정.
    print('Decode Data: $result');
    setState(() {
      _reChangedText = result;
    });
  }
}