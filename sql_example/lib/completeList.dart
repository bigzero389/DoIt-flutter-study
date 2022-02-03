import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'todo.dart';

class CompleteListApp extends StatefulWidget {
  Future<Database> database;
  CompleteListApp(this.database);

  @override
  State<StatefulWidget> createState() => _CompleteListApp();
}

class _CompleteListApp extends State<CompleteListApp> {
  Future<List<Todo>>? completeList;

  @override
  void initState() {
    super.initState();
    completeList = getCompleteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('완료한 일'),
      ),
      body: Center(
        child: FutureBuilder(builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none: return CircularProgressIndicator();
              case ConnectionState.waiting: return CircularProgressIndicator();
              case ConnectionState.active: return CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Todo todo = (snapshot.data as List<Todo>)[index];
                      return ListTile(
                        title: Text( todo.title!, style: TextStyle(fontSize: 20), ),
                        subtitle: Column(
                          children: [
                            Text(todo.content!),
                            Container( height: 1, color: Colors.blue, ),
                          ],
                        ),
                      );
                    },
                    itemCount: (snapshot.data as List<Todo>).length);
                }
            }
            return const Text('No Data');
          }, future: completeList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('완료한 일 삭제'),
              content: Text('완료한 일을 모두 삭제할까요?'),
              actions: [
                TextButton(onPressed: () { Navigator.of(context).pop(true); }, child: Text('예')),
                TextButton(onPressed: () { Navigator.of(context).pop(false); }, child: Text('아니오')),
              ],
            );
          });
          if (result) {
            _removeCompleteTodos();
          }
        }, child: Icon(Icons.remove),
      ),
    );
  }

  Future<List<Todo>> getCompleteList() async {
    final Database database = await widget.database;
    List<Map<String, dynamic>> maps = await database.rawQuery('select title, content, id from todos where active=1');
    return List.generate(maps.length, (i) {
      return Todo(
        title: maps[i]['title'].toString(),
        content: maps[i]['content'].toString(),
        id: maps[i]['id'],
      );
    });
  }

  void _removeCompleteTodos() async {
    final Database database = await widget.database;
    database.rawDelete('delete from todos where active = 1');
    setState(() {
      completeList = getCompleteList();
    });

  }

}