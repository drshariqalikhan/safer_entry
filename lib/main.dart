import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:safer_entry/testPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:safer_entry/mtechQr.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'covidPlace.dart';
import 'fecthdata.dart';


void main(){
//   print('hi');


//  await addCovidListToSF('tlc',testCovList);

// //read
//  List<CovidData> outlist = await getStoreCovidList('tlc'); 
  
//  print('out list : ${outlist.length}');
  
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
      // theme: ThemeData(
        
      //   primarySwatch: Colors.blue,
        
       
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      theme: ThemeData.dark(),
      // home:MyHomePage(title:'test'),
      home:TestPage(),


      
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

final Completer<WebViewController> _controller = Completer<WebViewController>();  

Future <String> scanQR()async{
 

  String out = '';
  try{
    out =  await BarcodeScanner.scan();

  }catch(e){
    out = '$e';

  }

  return out;
   }



  @override
  Widget build(BuildContext context) {
    return   Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text('${((DateTime.now().toUtc()).millisecondsSinceEpoch)/1000}')
      ),
      body: Container(
        child: FutureBuilder<String>(
          future:scanQR(),
          builder: (ctx,snapsh){
            if (snapsh.hasError) print(snapsh.error);

            return snapsh.hasData?Container(
              child:WebView(
                initialUrl: '${snapsh.data}',
                javascriptMode: JavascriptMode.unrestricted ,
                onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);} ,
              )
                )
              :CircularProgressIndicator();

          }
        )
      ),
      // bottomNavigationBar: FutureBuilder<double>(
      //   future: currenttoTarget(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) print(snapshot.error);

      //     print('Pos: ${snapshot.data.toString()}');
      //     return snapshot.hasData
      //         ? Text(snapshot.data.toString())
      //         : CircularProgressIndicator();
      //   },
      // ),
      bottomNavigationBar: FutureBuilder<BaseJson>(
        future: fetchCovidList(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          print('Num ${snapshot.data}');
          return snapshot.hasData
              ? PhotosList(covids: snapshot.data)
              : CircularProgressIndicator();
        },
      ),
    ),
      );
  }
}

class PhotosList extends StatelessWidget {
  final covids;

  PhotosList({Key key, this.covids}) : super(key: key);
  // var a = ;
  // print(a);

  @override
  Widget build(BuildContext context) {
    // print(DateTime.parse(covids.timeUpdated));
    return Container(child: Text('${covids.timeUpdated}',style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),color: Colors.amber,);

  }
}




