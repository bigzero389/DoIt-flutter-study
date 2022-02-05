import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import './data/user.dart';

class SignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignPage();
}

class _SignPage extends State<SignPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL = 'https://modutour-flutter-study-default-rtdb.firebaseio.com/';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckTextController;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database?.reference().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join'),),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: _idTextController,
                maxLines: 1,
                decoration: const InputDecoration(hintText: '4자이상 입력해 주세요', labelText: 'ID', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox( height: 20,),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _pwTextController,
                obscureText: true,
                maxLines: 1,
                decoration: const InputDecoration(hintText: '6자이상 입력해 주세요', labelText: 'PASSWORD', border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _pwCheckTextController,
                obscureText: true,
                maxLines: 1,
                decoration: const InputDecoration(hintText: '6자이상 입력해 주세요', labelText: 'PASSWORD CHECK', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              if (_idTextController!.value.text .length >= 4 && _pwTextController!.value.text.length >= 6) {
                if (_pwTextController!.value.text == _pwCheckTextController!.value.text) {
                  var bytes = utf8.encode(_pwTextController!.value.text);
                  var digest = sha1.convert(bytes);
                  User user = User(_idTextController!.value.text, digest.toString(), DateTime.now().toIso8601String());
                  reference!
                    .child(_idTextController!.value.text)
                    .push()
                    .set(user.toJson())
                    .then((_) {
                      Navigator.of(context).pop();
                    });
                }
              } else {
                makeDialog('Check ID or PW size');
              }
            }, child: const Text('JOIN', style: TextStyle(color: Colors.white),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  void makeDialog(String text) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Text(text),
      );
    });
  }}
