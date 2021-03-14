import 'package:qr_reader_app/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

openScan(BuildContext context, ScanModel scan) async {
  if (scan.type == 'http') {
    final url = scan.value;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
