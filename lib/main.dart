import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:safer_entry/mtechQr.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
      // theme: ThemeData(
        
      //   primarySwatch: Colors.blue,
        
       
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      theme: ThemeData.dark(),
      home:MyHomePage(title:'test'),



      
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
      bottomNavigationBar: FutureBuilder<BaseJson>(
        future: fetchCovidList(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);


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

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(covids.timeUpdated.toString(),style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),color: Colors.amber,);

  }
}




