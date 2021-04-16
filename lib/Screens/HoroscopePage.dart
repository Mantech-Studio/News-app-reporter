import 'package:flutter/material.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:news_app_reporter/Screens/HoroscopeDataPage.dart';

class HoroscopePage extends StatefulWidget {
  @override
  _HoroscopePageState createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  List<String> months = [
    'aquarius',
    'pisces',
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius',
    'capricorn'
  ];
  late String data;
  DateTime currentDate = DateTime.now();
  String uid = FirebaseDb().getuid().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(months.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HoroscopeData(months[index])));
            },
            child: Container(
                child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/${months[index]}.jpg'),
                ),
                Text(months[index])
              ],
            )),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          for (int i = 0; i < 12; i++) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(children: [
                      Container(
                          width: 100,
                          height: 100,
                          child: Image.asset('assets/${months[i]}.jpg')),
                      Text(months[i])
                    ]),
                    content: TextField(
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          data = value;
                        });
                      },
                      decoration: InputDecoration(hintText: "Enter the data"),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text('upload'),
                        onPressed: () async {
                          await FirebaseDb().addzodiacdata(
                              data,
                              currentDate.toString().split(' ')[0],
                              months[i],
                              uid);
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
