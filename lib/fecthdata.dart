
import 'dart:async';
import 'dart:convert';
import 'covidPlace.dart';
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

