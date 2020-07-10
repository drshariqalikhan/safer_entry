import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'covidPlace.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'urls.dart';



Future covidScanner() async {
  bool isDataCurrent;
  String finalStatement;
  List<CovidData> latestCovidList;
  double latestUpdateTime;
  Position currentPosition;
  List<CovidData> nearCovidPlacesList;
  BaseJson apiData;
  List<double> distlist;

//Run Once
  if (await getStoredUpdatedTime() == null) {
    //fetch new data
    apiData = await fetchCovidList(http.Client());
    // latestCovidList = apiData.data;
    latestCovidList = await addLatLonToCovidData(apiData.data);
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
  if (!isDataCurrent) {
    //fetch new data
    apiData = await fetchCovidList(http.Client());
    // latestCovidList = apiData.data;
    latestCovidList = await addLatLonToCovidData(apiData.data);
    latestUpdateTime = apiData.timeUpdated;

    //store latestCovidlist
    await addCovidListToSF('latestCovidList', latestCovidList);

    //store latestUpdateTime
    await addUpdateTimeToSF(latestUpdateTime);
  } else {
    //if isDataCurrent is true -> fetch stored data
    latestCovidList = await getStoreCovidList('latestCovidList');
    latestUpdateTime = await getStoredUpdatedTime();
  }
  //test 
  // print(latestCovidList);
  //get current location
  currentPosition = await getCurrentLocation();
  // currentPosition = Position(latitude:1.311474 ,longitude:103.856145 );

  //iterate through latestCovidList and make a nearCovidPlacesList
  List out = await makeNearCovidPlacesList(
      currentPosition: currentPosition, latestCovidList: latestCovidList);

  nearCovidPlacesList = out[0];
  distlist = out[1];

  // statement
  if (nearCovidPlacesList.length > 0) {
    finalStatement = 'High Covid Risk Area';
  } else {
    finalStatement = 'Low Covid Risk Area';
  }

  // finalStatement;
  return {
    'NearbyHotPlaces': nearCovidPlacesList,
    'Statment': finalStatement,
    'distances': distlist,
    'cl': currentPosition,
    'latestCovidList' :latestCovidList,
    
  };
}



///
///HELPERS
///




Future<BaseJson> fetchCovidList(http.Client client) async {
  final response = await client.get(apiUrl);

  return compute(parseCovid, response.body);
}

// // A function that converts a response body into a List<CovidData>.

BaseJson parseCovid(String responseBody) {
  final parsed = BaseJson.fromJson(jsonDecode(responseBody));
  return parsed;
}

// get current location
Future<Position> getCurrentLocation() async {
  Position res = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return res;
}

// get distance between two Positions
Future<double> distanceBetween(
    {Position positionCurrent, Position positionTarget}) async {
  double currentLat = positionCurrent.latitude;
  double currentLon = positionCurrent.longitude;
  double targetLat = positionTarget.latitude;
  double targetLon = positionTarget.longitude;

  // try{
    
  // double distanceInMeters = await Geolocator()
  //     .distanceBetween(currentLat, currentLon, targetLat, targetLon);
  // return distanceInMeters;
  // }catch(s){
  //   return 1002;

  // }

  double distanceInMeters = await Geolocator()
      .distanceBetween(currentLat, currentLon, targetLat, targetLon);
  return distanceInMeters;
}



Future makeNearCovidPlacesList(
    {List<CovidData> latestCovidList, Position currentPosition}) async {
  List<CovidData> results = [];
  List<double> covidist = [];
  double distance = 1002;

  for (CovidData covidplace in latestCovidList) {
    //   // position of place
    Position targetpos =
        Position(longitude: covidplace.lon, latitude: covidplace.lat);
    
    if(covidplace.lon!=null){
      
    distance = await distanceBetween(
        positionCurrent: currentPosition, positionTarget: targetpos);
    }
    // double distance = await distanceBetween(
    //     positionCurrent: currentPosition, positionTarget: targetpos);
    //check and add
    if (distance < 1001) {
      print('adding..${covidplace.place}');
      results.add(covidplace);
      covidist.add(distance);
    }
  }
  return [results, covidist];
}

bool checkIsDataCurrent(double storedTime) {
  bool res;
  var currentTime = ((DateTime.now().toUtc()).millisecondsSinceEpoch) / 1000;

  if (currentTime - storedTime > 45000) {
    res = false;
  } else {
    res = true;
  }

  return res;
}

addUpdateTimeToSF(double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setDouble('latestUpdateTime', value);
}

Future<double> getStoredUpdatedTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  double doubleValue = prefs.getDouble('latestUpdateTime');

  return doubleValue;
}

addTNCToSF(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setBool('TNC', value);
}

Future<bool> getStoredTNC() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool value = prefs.getBool('TNC');

  return value;
}

addCovidListToSF(String key, val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var setString = prefs.setString(key, json.encode(val));
}

Future<List<CovidData>> getStoreCovidList(String key) async {
  final prefs = await SharedPreferences.getInstance();

  Iterable l = json.decode(prefs.getString(key));

  return List<CovidData>.from(l.map((e) => CovidData.fromJson(e)));
}

Future<List<Placemark>> getLatLonFrom(String address)async{
  //get string from ( )
  String fineAddress = '';
  try{
    fineAddress = address.substring(address.indexOf('(') + 1, address.indexOf(')'));
  }catch(e){
    fineAddress = '';
  }
  List<Placemark> placemark = await Geolocator().placemarkFromAddress('$fineAddress,Singapore');
  return placemark;
}

Future<List<CovidData>> addLatLonToCovidData(List<CovidData> rawCovidDataList)async{
  List<CovidData> outlist = [];
  for (CovidData covidData in rawCovidDataList){
    List<Placemark> pos = await getLatLonFrom(covidData.place.toString()); 
    covidData.lat = pos[0].position.latitude;
    covidData.lon = pos[0].position.longitude;
    outlist.add(covidData);
  }

  return outlist;
}
