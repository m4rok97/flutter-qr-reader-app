import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader_app/models/scan_model.dart';

class MapPage extends StatelessWidget {
  final MapController mapController = new MapController();

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Codenates'),
          actions: [
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapController.move(scan.getLatLong(), 10);
              },
            )
          ],
        ),
        body: _createFlutterMap(scan));
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLong(),
        zoom: 10,
      ),
      layers: [_createMap(), _createMarkers(scan)],
    );
  }

  _createMap() {
    return TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']);

    // return TileLayerOptions(
    //     urlTemplate: 'https://api.mapbox.com/v4/'
    //         '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
    //     additionalOptions: {
    //       'accessToken':
    //           'pk.eyJ1IjoibTRyb2s5NyIsImEiOiJja20wMTlyOGQxZXVqMnByejcxbDBzOHB3In0.EY_DuPu5sokxtP2dFmudiw',
    //       'id': 'mapbox.satellite',
    //     });
  }

  _createMarkers(ScanModel scan) {
    return MarkerLayerOptions(markers: [
      Marker(
          width: 100,
          height: 100,
          point: scan.getLatLong(),
          builder: (context) => Container(
                  child: Icon(
                Icons.location_on,
                size: 70,
                color: Theme.of(context).primaryColor,
              ))),
    ]);
  }
}
