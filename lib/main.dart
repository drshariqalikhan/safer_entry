import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
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
      home:MyHomePage(title:'test'),
      // home:TestPage(),


      
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

// ScanResult scanResult;

//   final _flashOnController = TextEditingController(text: "Flash on");
//   final _flashOffController = TextEditingController(text: "Flash off");
//   final _cancelController = TextEditingController(text: "Cancel");

//   var _aspectTolerance = 0.00;
//   // var _numberOfCameras = 0;
//   var _selectedCamera = -1;
//   var _useAutoFocus = true;
//   var _autoEnableFlash = false;


//  Future scan() async {
//     try {
//       // var options = ScanOptions(
//       //   strings: {
//       //     "cancel": _cancelController.text,
//       //     "flash_on": _flashOnController.text,
//       //     "flash_off": _flashOffController.text,
//       //   },
//       //   restrictFormat: selectedFormats,
//       //   useCamera: _selectedCamera,
//       //   autoEnableFlash: _autoEnableFlash,
//       //   android: AndroidOptions(
//       //     aspectTolerance: _aspectTolerance,
//       //     useAutoFocus: _useAutoFocus,
//       //   ),
//       // );

//       var result = await BarcodeScanner.scan();
//       // var result = await BarcodeScanner.scan(options: options);

//       setState(() => scanResult = result);
//     } on PlatformException catch (e) {
//       // var result = ScanResult(
//       //   type: ResultType.Error,
//       //   format: BarcodeFormat.unknown,
//       // );

//       // if (e.code == BarcodeScanner.cameraAccessDenied) {
//       //   setState(() {
//       //     result.rawContent = 'The user did not grant the camera permission!';
//       //   });
//       // } else {
//       //   result.rawContent = 'Unknown error: $e';
//       }
//       setState(() {
//         scanResult = result;
//       });
//     }
//   }
// }

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

            // return snapsh.hasData?Container(
            //   child: Text(snapsh.data),
            // ):FlatButton(child: Text('data'),onPressed: () {
            //   setState(() {
                
            //   });
            // },);

            


            return snapsh.hasData?Container(
              child:(snapsh.data.startsWith('http'))?WebView(
                initialUrl: '${snapsh.data}',
                javascriptMode: JavascriptMode.unrestricted ,
                onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);} ,
              ):Center(child: FlatButton(onPressed: ()async{ await scanQR();}, child: Text('Tap to try again'))),
                )
              :CircularProgressIndicator();

          }
        )
      ),
    
      bottomNavigationBar: FutureBuilder(
        future: covidScanner(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          // print('Pos: ${snapshot.data['Statment']}');
          return snapshot.hasData
              ? FlatButton(child:Text(snapshot.data['Statment']),onPressed: (){
                if (snapshot.data['NearbyHotPlaces'].length > 0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('Nearby Places recently visited by covid cases'),
                        content: dialogContent(snapshot.data),
                    );
                    }
                  );
              }
              }
              ,)
              : CircularProgressIndicator();
        },
      ),





      // bottomNavigationBar: FutureBuilder<BaseJson>(
      //   future: fetchCovidList(http.Client()),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) print(snapshot.error);

      //     print('Num ${snapshot.data}');
      //     return snapshot.hasData
      //         ? PhotosList(covids: snapshot.data)
      //         : CircularProgressIndicator();
      //   },
      // ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          
        });
      },),
    ),
      );
  }
}


Widget dialogContent(dynamic snapData) {
   
    List<CovidData> nearbyPlacesList=snapData['NearbyHotPlaces'];
    List<double> nearbyDistances = snapData['distances'];
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: nearbyPlacesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(nearbyPlacesList[index].place),
            trailing: Text('${nearbyDistances[index].floor()}m'),
            leading: Text(nearbyPlacesList[index].date)
          );
        },
      ),
    );
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




