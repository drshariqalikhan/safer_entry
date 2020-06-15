
import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'covidPlace.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future <BaseJson> fetchCovidList(http.Client client) async {
  final response =
      await client.get('https://infinite-tor-43156.herokuapp.com/cov');

  // Use the compute function to run parsePhotos in a separate isolate.
  // print('${response.body} resp');
  
  return compute(parseCovid, response.body);

}

// // A function that converts a response body into a List<CovidData>.



  BaseJson parseCovid (String responseBody){
  final parsed = BaseJson.fromJson(jsonDecode(responseBody));
  // final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return  parsed;
  // return parsed.map<CovidData>((json) => CovidData.fromJson(json)).toList();
}


// get current location
Future <Position> getCurrentLocation()async{
  Position res = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return res;
}

// get distance between two Positions
Future <double> distanceBetween({Position positionCurrent, Position positionTarget})async{
  double currentLat= positionCurrent.latitude;
  double currentLon=  positionCurrent.longitude;
  double targetLat = positionTarget.latitude;
  double targetLon = positionTarget.longitude;

  double distanceInMeters = await Geolocator().distanceBetween(currentLat,currentLon, targetLat, targetLon);
  return distanceInMeters;
}



Future<String> covidScanner()async{
  
  bool isDataCurrent;
  String finalStatement;
  List<CovidData> latestCovidList;
  double latestUpdateTime;
  Position currentPosition;
  List nearCovidPlacesList;
  BaseJson apiData;
  
//Run Once
  if(await getStoredUpdatedTime()==null){
    //fetch new data
      apiData = await fetchCovidList(http.Client());
      latestCovidList = apiData.data;
      latestUpdateTime = apiData.timeUpdated;
  
      //store latestCovidlist
      await addCovidListToSF('latestCovidList', latestCovidList);
      
      //store latestUpdateTime 
      await addUpdateTimeToSF(latestUpdateTime);

  }

  //extract stored time from sharedrefs
  latestUpdateTime = await getStoredUpdatedTime();

  
  
    // check IsDataCurrent
    isDataCurrent = checkIsDataCurrent(latestUpdateTime);
  
    //if  isDataCurrent is false -> fetch new data
    if (!isDataCurrent){
      //fetch new data
      apiData = await fetchCovidList(http.Client());
      latestCovidList = apiData.data;
      latestUpdateTime = apiData.timeUpdated;
  
      //store latestCovidlist
      await addCovidListToSF('latestCovidList', latestCovidList);
      
      //store latestUpdateTime 
      await addUpdateTimeToSF(latestUpdateTime);
  
  
    }else{
      //if isDataCurrent is true -> fetch stored data
      latestCovidList = await getStoreCovidList('latestCovidList');
      latestUpdateTime = await getStoredUpdatedTime();
    }
    
    //get current location
    currentPosition = await getCurrentLocation();
  
    //iterate through latestCovidList and make a nearCovidPlacesList
    nearCovidPlacesList = await makeNearCovidPlacesList(currentPosition:currentPosition , latestCovidList:  latestCovidList);
    
    //statement
    if(nearCovidPlacesList.length>0){
      finalStatement = 'ALERT: You are in a Covid Risk Area , ${nearCovidPlacesList.length} nearby covid location(s)';
    }else{
      finalStatement = 'Low Covid Risk Area';
    }  
       
    return finalStatement;  
        
        
     }







  Future<List<CovidData>> makeNearCovidPlacesList({List<CovidData> latestCovidList, Position currentPosition})async {
    List<CovidData> results=[];
    latestCovidList.asMap().forEach((index, covidplace)async {
      // print('ind :$index  obj :${covidplace.place}');
      // if(covidplace.lat >2){
      //   results.add(covidplace);
      // }
     //add nearby places to results
      // position of place
      Position targetpos = Position(longitude: covidplace.lon,latitude: covidplace.lat);
      double distance = await distanceBetween(positionCurrent: currentPosition, positionTarget: targetpos);
      //check and add
      if(distance<1001){
        results.add(covidplace);
      }
    });

    return results;

}






  


  bool checkIsDataCurrent(double storedTime) {

    bool res;
    var currentTime = ((DateTime.now().toUtc()).millisecondsSinceEpoch)/1000;

    if(currentTime-storedTime>45000){
      res = false;
    }else{
      res = true;
    }


    return res;
} 


addUpdateTimeToSF(double value) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setDouble('latestUpdateTime', value);

}

  
  Future<double> getStoredUpdatedTime()async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  double doubleValue = prefs.getDouble('latestUpdateTime');

  return doubleValue;
}

addCovidListToSF(String key,val)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var setString = prefs.setString(key, json.encode(val));

}


  
Future <List<CovidData>> getStoreCovidList(String key)async {

  final prefs = await SharedPreferences.getInstance();

  Iterable l = json.decode(prefs.getString(key));


  return List<CovidData>.from(l.map((e) => CovidData.fromJson(e)));

}
