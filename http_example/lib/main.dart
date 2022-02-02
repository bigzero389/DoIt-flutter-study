import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HttpApp(title: 'Http Example'),
    );
  }
}

class HttpApp extends StatefulWidget {
  const HttpApp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result = '';
  List? books;
  TextEditingController? _editingController;
  ScrollController? _scrollController;
  int page = 1;

  @override
  void initState() {
    super.initState();
    books = List.empty(growable: true);
    _editingController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >= _scrollController!.position.maxScrollExtent && !_scrollController!.position.outOfRange) {
        print('bottom');
        page++;
        getJSONData();
      } else {
        print('??????????????????');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(hintText: '책 제목을 입력하세요'),
        ),
      ),
      body: Center(
        child: books!.isEmpty
            ? const Text( '데이터가 없습니다.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center, )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Image.network( books![index]['thumbnail'], height: 100, width: 100, fit: BoxFit.contain, ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                books![index]['title'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(books![index]['authors'].toString()),
                            Text(books![index]['sale_price'].toString()),
                            Text(books![index]['status'].toString()),
                          ],
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  );
                },
                itemCount: books!.length,
                controller: _scrollController,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page = 1;
          books!.clear();
          getJSONData();
        },
        tooltip: '',
        child: const Icon(Icons.file_download),
      ),
    );
  }

  Future<String> getJSONData() async {
    // var titleCondition = 'doit';
    var titleCondition = _editingController!.value.text;
    var url = 'https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=' + Uri.encodeComponent(titleCondition);
    var response = await http.get( Uri.parse(url), headers: {"Authorization": "KakaoAK 4039efd532cb071900793ee4864019ef"}, );
    setState(() {
      var dataConvertedToJson = json.decode(response.body);
      List result = dataConvertedToJson['documents'];
      print(result);
      books!.addAll(result);
    });
    return response.body;
  }
}
