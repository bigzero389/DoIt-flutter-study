import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:modu_tour/data/tour.dart';
import 'package:modu_tour/data/listData.dart';
import 'package:sqflite/sqflite.dart';
import 'tourDetailPage.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  MapPage({Key? key, this.databaseReference, this.db, this.id}): super(key: key);

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage> with SingleTickerProviderStateMixin {
  List<DropdownMenuItem<Item>> list = List.empty(growable: true);
  List<DropdownMenuItem<Item>> sublist = List.empty(growable: true);
  List<TourData> tourData = List.empty(growable: true);
  ScrollController? _scrollController;
  String authKey = '6tiT3fV%2BTthzx547gnR5%2BU46INCNNEHTCN0GcTtah4BRP4gIJlhxWx8pz4u%2FIcSVNvyNxsk10liobmmkzm34rg%3D%3D';
  Item? area;
  Item? kind;
  int page = 1;

  @override
  void initState() {
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;
    area = list[0].value;
    kind = sublist[0].value;
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      // 스크롤 offset 이 스크롤의 최대확장값 보다 크거나, 스크롤이 범위를 벗어나지 않으면 페이지를 추가한다.
      if ((_scrollController!.offset >= _scrollController!.position.maxScrollExtent) && !_scrollController!.position.outOfRange) {
        page++;
        getAreaList(area: area!.value, contentTypeId: kind!.value, page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('검색하기'), ),
      body: Center(
        child: Column(
          children: <Widget>[
            // 검색조건 입력 부분 만들기.
            Row(
              children: <Widget>[
                DropdownButton<Item>( value: area,
                  items: list,
                  onChanged: (value) { Item selectedItem = value!;
                    setState(() { area = selectedItem;
                    });
                  },
                ),
                const SizedBox( width: 10, ),
                DropdownButton<Item>( value: kind,
                  items: sublist,
                  onChanged: (value) { Item selectedItem = value!;
                    setState(() { kind = selectedItem;
                    });
                  },
                ),
                const SizedBox( width: 10, ),
                // 검색하기 버튼.
                MaterialButton(
                  child: const Text( '검색하기', style: TextStyle(color: Colors.white), ),
                  color: Colors.blueAccent,
                  onPressed: () { tourData.clear();
                    page = 1;
                    getAreaList( area: area!.value, contentTypeId: kind!.value, page: page);
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            // 리스트뷰를 동적으로 늘어나게 하려면 Expanded를 사용해야 한다.
            Expanded(
              child: ListView.builder(
                itemCount: tourData.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Card(
                      // 별도의 제스처를 제공하지 않는 경우 InkWell 을 사용할 수 있다.
                    child: InkWell(
                      child: Row(
                          children: <Widget>[
                            // Hero 는 화면전환이 애니메이션을 제공한다.(편하게 자동으로...)
                            Hero( tag: 'tourinfo$index',
                              child: Container( margin: const EdgeInsets.all(10),
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration( shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 1),
                                  image: DecorationImage(fit: BoxFit.fill, image: getImage(tourData[index].imagePath),),
                                ),
                              ),
                            ),
                            const SizedBox( width: 20, ),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text( tourData[index].title!,
                                    style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text('주소 : ${tourData[index].address}'),
                                  tourData[index].tel != null ? Text('전화 번호 : ${tourData[index].tel}') : Container(),
                                ],
                              ),
                              // 좌측 이미지 사이즈를 제외하고 우측의 컨텐츠 공간을 동적으로 확보한다.
                              width: MediaQuery.of(context).size.width - 150,
                            )
                          ],
                        ),
                        onTap: () {
                          // 탭하면 상세화면으로 전환한다.
                          Navigator.of(context).push(MaterialPageRoute( builder: (context) {
                            return TourDetailPage( id: widget.id,
                              tourData: tourData[index],
                              index: index,
                              databaseReference: widget.databaseReference,
                            );
                          },));
                        },
                        onDoubleTap: () {
                          // 더블탭하면 여행정보를 즐겨찾기에 저장한다.
                          insertTour(widget.db!, tourData[index]);
                        },
                      ),
                    );
                  },
                )
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }

  // 즐겨찾기 등록.
  void insertTour(Future<Database> db, TourData info) async {
    final Database database = await db;
    await database.insert('place', info.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('즐겨찾기에 추가되었습니다')));
    });
  }

  ImageProvider getImage(String? imagePath) {
    if (imagePath != null) {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('repo/images/map_location.png');
    }
  }

  void getAreaList({required int area, required int contentTypeId, required int page}) async {
    var url = 'http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?ServiceKey=$authKey&MobileOS=AND&MobileApp=ModuTour&_type=json&areaCode=1&numOfRows=10&sigunguCode=$area&pageNo=$page';
    if (contentTypeId != 0) {
      url = url + '&contentTypeId=$contentTypeId';
    }
    print(url);

    var response = await http.get(Uri.parse(url));
    String body = utf8.decode(response.bodyBytes);
    print(body);

    var json = jsonDecode(body);
    if (json['response']['header']['resultCode'] == "0000") {
      if (json['response']['body']['items'] == '') {
        showDialog( context: context,
          builder: (context) {
            return const AlertDialog( content: Text('마지막 데이터 입니다'), );
          },
        );
      } else {
        List jsonArray = json['response']['body']['items']['item'];
        for (var s in jsonArray) {
          setState(() { tourData.add(TourData.fromJson(s));
          });
        }
      }
    } else {
      print('error');
    }
  }
}