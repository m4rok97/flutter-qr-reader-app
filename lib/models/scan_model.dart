import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String type;
  String value;

  ScanModel({
    this.id,
    this.type,
    this.value,
  }) {
    if (this.value.contains('local')) {
      this.type = 'geo';
    } else {
      this.type = 'http';
    }
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };

  LatLng getLatLong() {
    value = value.substring(value.indexOf('=') + 1);
    List<double> latLong =
        value.split(',').map((e) => double.parse(e)).toList();
    return LatLng(latLong[0], latLong[1]);
  }
}
