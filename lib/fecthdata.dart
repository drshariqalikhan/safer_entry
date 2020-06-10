
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<CovidData>> fetchCovidList(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseCovid, response.body);

}

// // A function that converts a response body into a List<CovidData>.



List<CovidData> parseCovid(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CovidData>((json) => CovidData.fromJson(json)).toList();
}

class CovidData {
  String date;
  String time;
  String place;
  double lat;
  double lon;

  CovidData({this.date, this.time, this.place, this.lat, this.lon});

  CovidData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    place = json['place'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['place'] = this.place;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
