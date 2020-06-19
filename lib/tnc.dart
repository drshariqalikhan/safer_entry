
import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:safer_entry/main.dart';
import 'package:safer_entry/urls.dart';
import 'fecthdata.dart';


class Tnc extends StatefulWidget {
  @override
  TncState createState() => new TncState();
}

class TncState extends State<Tnc> with AfterLayoutMixin<Tnc> {
  Future checkSeen()async{
     bool seen = await getStoredTNC();
     if(seen!=null){
       Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MyHomePage()));
     }
  }

 @override
  void afterFirstLayout(BuildContext context) => checkSeen();


  @override
  Widget build(BuildContext context) {
 
    return TncWidget();
  }
}

class TncWidget extends StatelessWidget {
  const TncWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
        child: Container(
          child: Column(
            children:[
              Container(child: Image.asset('assets/images/icon.png')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('DISCLAIMER'),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(text:TextSpan(text:tnc),textAlign: TextAlign.justify,),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:Column(children:[ 
                  Text('By clicking on agree , you accept the above terms and conditions of use.'),
                  RaisedButton(child: Text('I Agree'),onPressed: ()async
                  { //setSPF
                    var res = await addTNCToSF(true);
                    Navigator.of(context).push(
        
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'yopppp!',)),
                              );}),
                  
                  ]),
              ),
              
            ]
          ),
        ),
      ),
    );
  }
}