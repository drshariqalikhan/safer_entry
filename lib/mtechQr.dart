import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
// import 'package:barcode_scan/barcode_scan.dart';



class QrHome extends StatefulWidget {

  @override
  _QrHomeState createState() => _QrHomeState();
}

class _QrHomeState extends State<QrHome> {
 String res = 'hi';


 Future _scanQR()async{
   try{
     String qrResult = await BarcodeScanner.scan();

     setState(() {
       res = qrResult;
     });
     

   }catch(e){
     print('err is $e');


   }

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child:Text(res)),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR),
            );
          }
}