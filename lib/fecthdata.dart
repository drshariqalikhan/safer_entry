
import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';

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
Future <double> distanceBetween(Position positionCurrent, List positionTarget)async{
  double distanceInMeters = await Geolocator().distanceBetween(positionCurrent.latitude, positionCurrent.longitude, positionTarget[0], positionTarget[1]);
  return distanceInMeters;
}

Future <double> currenttoTarget()async{
  Position current = await getCurrentLocation();
  double targetLat = 1.33;
  double targetLon = 107.5;
  double res = await distanceBetween(current, [targetLat,targetLon]);
  return res;
}