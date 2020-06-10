


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
