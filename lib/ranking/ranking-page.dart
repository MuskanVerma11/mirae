import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mirae/map/world_map.dart';
import 'package:country_picker/country_picker.dart';

class RankerType {
  String name;
  String imageUrl;
  String flag;
  int points;
  int discardCount;
  int pingCount;

  RankerType(
      {this.name,
      this.imageUrl,
      this.flag,
      this.points,
      this.discardCount,
      this.pingCount});

  RankerType.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        imageUrl = snapshot.value["imageUrl"],
        flag = snapshot.value["country"],
        points = snapshot.value["point"],
        discardCount = snapshot.value["discard"],
        pingCount = snapshot.value["ping"];

  toJson() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "country": flag,
      "point": points,
      "discardCount": discardCount,
      "ping": pingCount
    };
  }
}

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<RankerType> rankerList = [];
  final dbRef = FirebaseDatabase.instance.reference();
  Country selectedCountry;

  @override
  void initState() {
    super.initState();
  }

  Widget _renderProfile(BuildContext context, index) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.032 * width),
          child: Container(
            width: 0.16 * width,
            height: 0.16 * width,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(rankerList[index].imageUrl),
            ),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Color.fromRGBO(66, 178, 97, 1),
                width: 2.0,
              ),
            ),
          ),
        ),
        Container(
          width: 0.245 * width,
          child: Column(
            children: [
              Text(rankerList[index].name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 0.053 * width,
                      fontFamily: 'GoogleSans',
                      fontWeight: FontWeight.w700)),
              Row(
                children: [
                  Text(
                    countryCodeToEmoji(rankerList[index].flag),
                    style: TextStyle(fontSize: 0.037 * width),
                  ),
                  Text("  ${rankerList[index].points} pts",
                      style: TextStyle(
                          color: Color.fromRGBO(66, 178, 97, 1),
                          fontSize: 0.037 * width,
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderTypeItem(BuildContext context, index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.03 * width, vertical: 0.007 * height),
        child: GestureDetector(
            onTap: () => {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${index + 1}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 0.053 * width,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w700)),
                _renderProfile(context, index),
                Image.asset('assets/ic_loc_discard.png', width: 0.14 * width),
                Text('${rankerList[index].discardCount}',
                    style: TextStyle(
                        color: Color.fromRGBO(66, 178, 97, 1),
                        fontSize: 0.042 * width,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w700)),
                Image.asset('assets/ic_loc_ping.png', width: 0.14 * width),
                Text('${rankerList[index].pingCount}',
                    style: TextStyle(
                        color: Color.fromRGBO(244, 198, 35, 1),
                        fontSize: 0.042 * width,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w700)),
              ],
            )));
  }

  Widget _renderHeaderContent() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0.014 * height),
                child: Text('DISCARD',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 0.053 * width,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w700))),
            Padding(
              padding: EdgeInsets.only(left: 0.016 * width),
              child: Row(
                children: [
                  Image.asset('assets/ic_loc_discard.png', width: 0.16 * width),
                  Text('3050',
                      style: TextStyle(
                          color: Color.fromRGBO(66, 178, 97, 1),
                          fontSize: 0.074 * width,
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: 0.014 * height, left: 0.016 * width),
                child: Text('PING',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 0.053 * width,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w600))),
            Row(
              children: [
                Image.asset('assets/ic_loc_ping.png', width: 0.16 * width),
                Text('10208',
                    style: TextStyle(
                        color: Color.fromRGBO(244, 198, 35, 1),
                        fontSize: 0.074 * width,
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w600))
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderHandlinedTitle() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.03 * height),
      width: 0.67 * width,
      child: Column(
        children: [
          Text("World Ranking",
              style: TextStyle(
                  fontSize: 0.074 * width,
                  color: Color.fromRGBO(66, 178, 97, 1),
                  fontFamily: 'GoogleSans',
                  fontWeight: FontWeight.w700)),
          Image.asset(
            'assets/underline.png',
            width: 0.54 * width,
            height: 0.01 * height,
            color: Color(0xff42B261),
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "MAP",
            style:
                TextStyle(color: Color(0xff31AC53), fontFamily: 'GoogleSans'),
          ),
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () => Get.to(() => WorldMap()),
              child: Container(
                height: 0.35 * height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg_ranking.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: _renderHeaderContent(),
              ),
            ),
            Expanded(
              child: ListView(children: [
                FutureBuilder(
                    future: dbRef.child("user").orderByChild("point").once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        rankerList.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        print(values);
                        values.forEach((key, values) {
                          print(values);
                          rankerList.add(RankerType(
                              name: values["name"],
                              imageUrl: values["ImageUrl"],
                              flag: values["country"],
                              discardCount: values["discard"],
                              pingCount: values["ping"],
                              points: values["point"]));
                        });
                        Comparator<RankerType> pointComparator =
                            (a, b) => b.points.compareTo(a.points);
                        rankerList.sort(pointComparator);
                        print(rankerList.length);
                        return new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: rankerList.length + 1,
                            itemBuilder: (BuildContext context, index) {
                              return index == 0
                                  ? _renderHandlinedTitle()
                                  : _renderTypeItem(context, index - 1);
                            });
                      }
                      return CircularProgressIndicator();
                    }),
              ]),
            ),
          ],
        ));
  }

  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
