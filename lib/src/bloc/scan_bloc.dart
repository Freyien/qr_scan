import 'dart:async';

import 'package:qr_scan/src/bloc/validator.dart';
import 'package:qr_scan/src/providers/db_provider.dart';

class ScanBloc with Validators{
  static final ScanBloc _singleton = ScanBloc._internal();

  factory ScanBloc() {
    return _singleton;
  }

  ScanBloc._internal() {
    //Obtener Scans de la base de datos
    getScans();
  }

  final _scanController = new StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scanStream => _scanController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scanStreamHttp => _scanController.stream.transform(validateHttp);

  dispose() {
    _scanController?.close();
  }

  getScans() async {
    _scanController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel scanModel) async {
    await DBProvider.db.addScan(scanModel);

    getScans();
  }

  deleteScan(ScanModel scanModel) async {
    await DBProvider.db.deleteScan(scanModel);
    
    getScans();
  }

  deleteAllScans() async{
    await DBProvider.db.deleteAllScans();

    getScans();
  }
}
