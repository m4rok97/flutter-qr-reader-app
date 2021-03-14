import 'dart:async';

import 'package:qr_reader_app/bloc/validators.dart';
import 'package:qr_reader_app/models/scan_model.dart';
import 'package:qr_reader_app/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {}

  final _scansController = StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>> get scansStreamGeo =>
      _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController.close();
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAll();
    getScans();
  }
}
