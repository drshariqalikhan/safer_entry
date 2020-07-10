import 'package:flutter/material.dart';

class CalPage extends StatefulWidget {

  CalPage({this.dateString});
  final String dateString;

  @override
  _CalPageState createState() => _CalPageState();
}

class _CalPageState extends State<CalPage> {
  
  
  @override
  Widget build(BuildContext context) {
    // var d = widget.dateString.toUpperCase().substring(2);
    // var e = widget.dateString.substring(0,2);
    var d = 'DD';
    var e = 'MOM';
    return Card(
      child:Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        //  crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
                            child: FractionallySizedBox(
                heightFactor: 0.33,
                widthFactor: 1.0,
                child: Card(color: Colors.red,child:Center(child: Text(d,style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white,fontSize:100.0),))),
              ),
            ),
            Flexible(
                            child: FractionallySizedBox(
                heightFactor: 0.66,
                widthFactor: 1.0,
                child: Card(color: Colors.white,child:Center(child: Text(e,style: TextStyle(color: Colors.black,fontSize:200.0),))),
              ),
            ),

          ],
      ) 
    );
  }
}