import 'package:flutter/material.dart';
import 'package:qr_reader_app/bloc/scan_bloc.dart';
import 'package:qr_reader_app/models/scan_model.dart';
import 'package:qr_reader_app/pages/data_page.dart';
import 'package:qr_reader_app/utils/utils.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataPage('geo');
  }
}
