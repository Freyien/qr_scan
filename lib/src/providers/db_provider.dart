import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_scan/src/models/scan_model.dart';
export 'package:qr_scan/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE scans( '
            'id INTEGER PRIMARY KEY, '
            'type TEXT, '
            'value TEXT'
          ')'
        );
      }
    );

  }

  //CREATE
  addScanRaw(ScanModel scanModel) async{
    final db = await database;
    final response = await db.rawInsert(
      "INSERT INTO scans (id, type, value) "
      "VALUES( ${scanModel.id}, '${scanModel.type}', '${scanModel.value}' ) "
    );

    return response;
  }

  addScan( ScanModel scanModel ) async {
    final db = await database;
    final response = await db.insert('scans', scanModel.toJson());

    return response;
  }

  //SELECT
  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final response = await db.query('scans', 
                                      where: 'id = ?', 
                                      whereArgs: [id] );

    return response.isNotEmpty ? ScanModel.fromJson(response.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final response = await db.query('scans');

    List<ScanModel> list = response.isNotEmpty 
                              ? response.map((scan) => ScanModel.fromJson(scan)).toList() 
                              : [];

    return list;
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await database;
    final response = await db.query('scans', where: 'type = ?', whereArgs: [type]);

    List<ScanModel> list = response.isNotEmpty 
                              ? response.map((scan) => ScanModel.fromJson(scan)).toList() 
                              : [];

    return list;
  }

  //UPDATE
  Future<int> updateScan(ScanModel scanModel) async {
    final db = await database;
    final response = await db.update('scans', scanModel.toJson(), where: 'id = ?', whereArgs: [scanModel.id]);

    return response;
  }

  //DELETE
  Future<int> deleteScan(ScanModel scanModel) async {
    final db = await database;
    final response = await db.delete('scans', where: 'id = ?', whereArgs: [scanModel.id]);

    return response;
  }
  
  //DELETE ALL
  Future<int> deleteAllScans() async {
    final db = await database;
    final response = await db.delete('scans');

    return response;
  }
}