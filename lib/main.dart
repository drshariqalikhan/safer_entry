import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safer_entry/qr_scanner.dart';
import 'covidPlace.dart';
import 'fecthdata.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


// List<CovidData> d ;
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
      home:HomePage(title:'test'),
      // home: MyHomePage(
      //   msg: FutureBuilder<List<CovidData>>(
      //     future: fetchCovidList(http.Client()),
      //     builder: (context,snapshot)
      //     {
      //       if (snapshot.hasError) print(snapshot.error);
      //       if(snapshot.hasData){
      //         print(snapshot.data[0].lat);
      //       }
      //       return snapshot.hasData
      //         ? Text('${snapshot.data}')
      //         : Center(child: CircularProgressIndicator());
      //     }),
      // scannerWidget: Card(child: Text('placeholder'),),
      // ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: QrApp(),
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
    // return GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //   ),
    //   itemCount: covids.data.length,
    //   itemBuilder: (context, index) {
    //     print(covids.data[index].place.toString());
    //     return Text(covids.data[index].place??'load..');
    //   },
    // );
  }
}





// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<List<Photo>> fetchPhotos(http.Client client) async {
//   final response =
//       await client.get('https://jsonplaceholder.typicode.com/photos');

//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parsePhotos, response.body);
// }

// // A function that converts a response body into a List<Photo>.
// List<Photo> parsePhotos(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
// }

// class Photo {
//   final int albumId;
//   final int id;
//   final String title;
//   final String url;
//   final String thumbnailUrl;

//   Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

//   factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(
//       albumId: json['albumId'] as int,
//       id: json['id'] as int,
//       title: json['title'] as String,
//       url: json['url'] as String,
//       thumbnailUrl: json['thumbnailUrl'] as String,
//     );
//   }
// }

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final appTitle = 'Isolate Demo';

//     return MaterialApp(
//       title: appTitle,
//       home: MyHomePage(title: appTitle),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final String title;

//   MyHomePage({Key key, this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: FutureBuilder<List<CovidData>>(
//         future: fetchCovidList (http.Client()),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) print(snapshot.error);
//           // print(snapshot.data.toString());
//           return snapshot.hasData
//           ? Card(child: Text(snapshot.data[0].lat.toString()))
//               : Center(child: CircularProgressIndicator());
//               // ? PhotosList(photos: snapshot.data)
//               // : Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

// class PhotosList extends StatelessWidget {
//   final List<Photo> photos;

//   PhotosList({Key key, this.photos}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
      
//         return Image.network(photos[index].thumbnailUrl);
//       },
//     );
//   }
// }
