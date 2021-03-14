import 'dart:io';

import 'package:qr_reader_app/models/scan_model.dart';
export 'package:qr_reader_app/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')');
    });
  }

  // Create registers

  newScan(ScanModel newScan) async {
    final db = await database;
    final ans = await db.rawInsert("INSERT INTO Scans (id, type, value)"
        "VALUES ( ${newScan.id},  '${newScan.type}', '${newScan.value}')");
    return ans;
  }

  newScans(ScanModel newScan) async {
    final db = await database;
    final ans = db.insert('Scans', newScan.toJson());
    return ans;
  }

  // SELECT - Obtain information
  getScanId(int id) async {
    final db = await database;
    final ans = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return ans.isNotEmpty ? ScanModel.fromJson(ans.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final ans = await db.query('Scans');
    // final ans = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$()");
    List<ScanModel> list =
        ans.isNotEmpty ? ans.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScansPerType(String type) async {
    final db = await database;
    final ans = await db.rawQuery("SELECT * FROM Scans WHERE type='$type");
    List<ScanModel> list =
        ans.isNotEmpty ? ans.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  // Update registers
  Future<int> updateScans(ScanModel newScan) async {
    final db = await database;
    final ans = await db
        .update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: []);
    return ans;
  }

  // Delete registers
  Future<int> deleteScan(int id) async {
    final db = await database;
    final ans = db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return ans;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final ans = db.delete('Scans');
    return ans;
  }
}
