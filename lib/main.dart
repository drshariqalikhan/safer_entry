import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fecthdata.dart';
import 'homepage.dart';


List d ;
void main()async {
  d = await fetchCovidList(http.Client());

  runApp(MyApp());
  // print(d);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  
  @override
  Widget build(BuildContext context) {
   int z  = d.length;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(msg: '${z.toString()}',scannerWidget: Card(child: Text('placeholder'),),),
    );
  }
}


