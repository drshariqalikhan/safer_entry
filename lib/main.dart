import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:safer_entry/mtechQr.dart';

import 'covidPlace.dart';
import 'fecthdata.dart';


void main(){
  // d = await fetchCovidList(http.Client());

  runApp(MyApp());
  // print(d);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  
  
  @override
  Widget build(BuildContext context) {
  //  var z  = d[0].lat;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home:MyHomePage(title:'test'),
      home:QrHome(),

      
    );
  }
}

























class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Text('QR widget here')
      ),
      bottomNavigationBar: FutureBuilder<BaseJson>(
        future: fetchCovidList(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);


          return snapshot.hasData
              ? PhotosList(covids: snapshot.data)
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final covids;

  PhotosList({Key key, this.covids}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(covids.timeUpdated.toString(),style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),color: Colors.amber,);

  }
}




