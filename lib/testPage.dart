
import 'package:flutter/material.dart';
import 'package:safer_entry/covidPlace.dart';
import 'fecthdata.dart';


class TestPage extends StatefulWidget {
  // This widget is the root of your application.


  
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

    List<CovidData>testCovList = [
    new CovidData(
      date: '1 jan',
      time: '7pm',
      place: 'xyz',
      lat: 10.1,
      lon: 12.3
    ),
     new CovidData(
      date: '2 jan',
      time: '7pm',
      place: 'abc',
      lat: 10.1,
      lon: 12.3
    ),
     new CovidData(
      date: '3 jan',
      time: '7pm',
      place: 'def',
      lat: 10.1,
      lon: 12.3
    ),

  ];

  Iterable l ;

  List<CovidData> outlist;
  @override
  Widget build(BuildContext context) {
  //  var z  = d[0].lat;
        return Scaffold(
          
    body:Center(
      child: FlatButton(
        onPressed: ()async{
          await addCovidListToSF('tlc',testCovList);
          print(testCovList);
          


        }, 
        child: Text('data'),
    ),),

    

    

    floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          // print('press');
          // // var s = json.encode(testCovList);
          // // l = await getStoreCovidList('tlc'); 
          // // outlist = List<CovidData>.from(l.map((e) => CovidData.fromJson(e)));
          // outlist = await getStoreCovidList('tlc');

          // print(outlist[0].date);
          var df = await getStoredUpdatedTime();
          print(df);

        }),
    );
  }
}









