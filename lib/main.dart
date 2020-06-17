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


  SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    
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

// final Completer<WebViewController> _controller = Completer<WebViewController>();  
WebViewController webView;
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

bool showButton = true;
  @override
  Widget build(BuildContext context) {
    return   Container(
        child: Scaffold(
      appBar: AppBar( 
        leading: IconButton(icon: Icon(Icons.autorenew),onPressed:(){setState(() {
          
        });}),
        flexibleSpace: IconButton(icon: Icon(Icons.info), onPressed: ()async{
          await showDialog(
            context: context,
            builder: (_)=>ImageDialog()
                        );
                    }),
                  ),
                  body: WillPopScope(
                    onWillPop: ()async{ return false;},
                            child: Container(
                              child: FutureBuilder<String>(
                                future:scanQR(),
                                builder: (ctx,snapsh){
                                  if (snapsh.hasError) print(snapsh.error);
                    
                                  
                    
                                  return snapsh.hasData?Container(
                                    child:(snapsh.data.startsWith('http'))?WebView(
                                      initialUrl: '${snapsh.data}',
                                      javascriptMode: JavascriptMode.unrestricted ,
                                      onWebViewCreated: (WebViewController webViewController) {
                                  _controller.complete(webViewController);} ,
                                    ):Center(child: Text('Failed to scan')),
                                      )
                                    :CircularProgressIndicator();
                    
                                }
                             )
                            ),
                          ),
                      
                    
                    
                          // body: Container(
                          //   child: FutureBuilder<String>(
                          //     future:scanQR(),
                          //     builder: (ctx,snapsh){
                          //       if (snapsh.hasError) print(snapsh.error);
                    
                                
                    
                          //       return snapsh.hasData?Container(
                          //         child:(snapsh.data.startsWith('http'))?WebView(
                          //           initialUrl: '${snapsh.data}',
                          //           javascriptMode: JavascriptMode.unrestricted ,
                          //           onWebViewCreated: (WebViewController webViewController) {
                          //       _controller.complete(webViewController);} ,
                          //         ):Center(child: Text('Failed to scan')),
                          //           )
                          //         :CircularProgressIndicator();
                    
                          //     }
                          //   )
                          // ),
                        
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
                    
                          // floatingActionButton: FloatingActionButton(onPressed: () {
                          //   setState(() {
                              
                          //   });
                          // },),
                        ),
                          );
                      }
                    
              //         Future<bool> _onBackPressed()async {
            
              //           // bool goback;
              //           var value = await webView.canGoBack();
              //           print('the val is $value');
              //           if(value){
              //             webView.goBack();
              //             return value;
              //           }else{
              //             Navigator.of(context).pop(true);
              //             return value;
              //           }
              // }
            }
            
            class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // width: 200,
        // height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/splash.png'),
            fit: BoxFit.cover
          )
        ),
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




