import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.msg,this.scannerWidget}) : super(key: key);
  final Widget msg;
  final Widget scannerWidget;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        
        body: Center(
          child: widget.scannerWidget,
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){}),
        bottomNavigationBar: Container(
          child: Text('${widget.msg}',style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),
          color: Colors.deepOrange,
          ),
      ),
    );
  }
}
 