// import 'package:flutter/material.dart';
// import 'package:safer_entry/covidPlace.dart';
// import 'fecthdata.dart';
// // import 'package:barcode_scan/barcode_scan.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';





// class TestPage extends StatefulWidget {
//   // This widget is the root of your application.

//   @override
//   _TestPageState createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   var qrText = '';
//   var flashState = 'FLASH ON';
//   var cameraState = 'BACK CAMERA';
//   QRViewController controller;
//  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         qrText = scanData;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(),
//         body: Column(children: [
//           QRView(key: qrKey, onQRViewCreated: _onQRViewCreated,),
//           // FutureBuilder(
//           //   future: QR(),
//           //   builder: (context,snapshot){
//           //     var res = snapshot.data;
//           //     return snapshot.hasData?Container(child: Text(res)):CircularProgressIndicator();
//           //   }
//           //   ),
//           Card(child: FlatButton(child: Text('again'),onPressed: (){setState(() {
            
//           });},)),
//         ]),
//       ),
//     );
//   }
// }
