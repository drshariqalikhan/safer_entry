


// class CovidData {
//   String date;
//   String time;
//   String place;
//   double lat;
//   double lon;

//   CovidData({this.date, this.time, this.place, this.lat, this.lon});

//   CovidData.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     time = json['time'];
//     place = json['place'];
//     lat = json['lat'];
//     lon = json['lon'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     data['time'] = this.time;
//     data['place'] = this.place;
//     data['lat'] = this.lat;
//     data['lon'] = this.lon;
//     return data;
//   }
// }

class BaseJson {
  List<CovidData> data;
  int num;
  var timeUpdated;

  BaseJson({this.data, this.num, this.timeUpdated});

  BaseJson.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = new List<CovidData>();
      json['Data'].forEach((v) {
        data.add(new CovidData.fromJson(v));
      });
    }
    num = json['Num'];
    timeUpdated = json['TimeUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Num'] = this.num;
    data['TimeUpdated'] = this.timeUpdated;
    return data;
  }
}

class CovidData {
  String date;
  double lat;
  double lon;
  String place;
  String time;

  CovidData({this.date, this.lat, this.lon, this.place, this.time});

  CovidData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    lat = json['lat'];
    lon = json['lon'];
    place = json['place'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['place'] = this.place;
    data['time'] = this.time;
    return data;
  }
}