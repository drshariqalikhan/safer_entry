
import 'dart:async';
import 'dart:convert';
import 'covidPlace.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<CovidData>> fetchCovidList(http.Client client) async {
  final response =
      await client.get('https://infinite-tor-43156.herokuapp.com/cov');

  // Use the compute function to run parsePhotos in a separate isolate.
  // print('${response.body} resp');
  
  return compute(parseCovid, response.body);

}

// // A function that converts a response body into a List<CovidData>.



  BaseJson parseCovid(String responseBody){
  final parsed = BaseJson.fromJson(jsonDecode(responseBody));
  // final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return  parsed;
  // return parsed.map<CovidData>((json) => CovidData.fromJson(json)).toList();
}

