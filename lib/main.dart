import 'dart:async';
// import 'dart:js';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:safer_entry/testPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:safer_entry/mtechQr.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'urls.dart';
import 'covidPlace.dart';
import 'fecthdata.dart';
import 'package:safer_entry/tnc.dart';


bool showTnc;
void main(){
  runApp(MyApp());
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
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData.dark(),
      home:Tnc(),
      // home:TestPage(),
      // home:Tnc(),

      
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
Color alertColor = Colors.black;

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
        leading:IconButton(icon: Icon(Icons.center_focus_strong),onPressed:(){setState(() {});}),

        actions:<Widget>[
          IconButton(icon: Icon(Icons.assignment),onPressed:()async{
            
            List<CovidData> allList;
            try{
            allList = await getStoreCovidList('latestCovidList');
            }catch(e){}
            showDialog(
                        context: context,
                        builder: (BuildContext context) {

                           return (allList!=null)?AlertDialog(
                                            title: Text('Nearby Places recently visited by covid cases'),
                                            content: dialogAllContent(allList),
                                        ):AlertDialog(
                                          title: Text('loading....')
                                          );             
                                        }
                                      );
          
          }),//list
          IconButton(icon: Icon(Icons.info_outline),onPressed:(){

              showDialog(
                context: context,
                builder:(BuildContext context){
                 return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 500,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                     Container(child: Image.asset('assets/images/icon.png')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('DISCLAIMER',style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(text:TextSpan(text:tnc,style: TextStyle(fontSize: 15.0,fontWeight:FontWeight.bold)),textAlign: TextAlign.justify,),
                // child: Text(tnc),
              ),
                    
                  ],
                ),
              ),
            )
            );
                }
                );

          }),//disclaimer
        ],

        
        
        
        
        ),
      
        
        body: WillPopScope(
                    onWillPop: ()async{ return false;},
                            child: Container(
                              child: FutureBuilder<String>(
                                future:scanQR(),
                                builder: (ctx,snapsh){
                                  if (snapsh.hasError) print(snapsh.error);
                    
                                  
                    
                                  return snapsh.hasData?Container(
                                    child:(snapsh.data.startsWith(safeEntryUrl))?WebView(
                                      initialUrl: '${snapsh.data}',
                                      javascriptMode: JavascriptMode.unrestricted ,
                                      onWebViewCreated: (WebViewController webViewController) {
                                  _controller.complete(webViewController);} ,
                                    ):Center(child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(noScanMsg),
                                    ),))
                                      
                                    :CircularProgressIndicator();
                    
                                }
                             )
                            ),
                          ),
                      
                    
                    
                        
                          bottomNavigationBar: FutureBuilder(
                            future: covidScanner(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);

                              // print('Pos: ${snapshot.data['Statment']}');
                              if(snapshot.hasData){
                                if(snapshot.data['NearbyHotPlaces'].length>0){
                                  alertColor = Colors.redAccent;
                                }else{
                                  alertColor = Colors.greenAccent;
                                }
                              }
                              return snapshot.hasData
                                  ? FlatButton(child:Text(snapshot.data['Statment'],style: TextStyle(color: Colors.black),),color: alertColor,onPressed: (){
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
                    
                    
                    
                    
                    
                          
                        ),
                          );
                      }
                    
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

Widget dialogAllContent(List<CovidData> placesList){
  // List<CovidData> placesList= await getStoreCovidList('latestCovidList');

   return (placesList==null)?Container():Container(
     height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: placesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(placesList[index].place),
            leading: Text(placesList[index].date)
          );
        },
      ),

  );
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




