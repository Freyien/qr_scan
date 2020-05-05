import 'dart:async';

import 'package:qr_scan/src/models/scan_model.dart';

class Validators {
  final validateGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {
      final List<ScanModel> geoScans = scans.where((s) => s.type == 'geo').toList();
      sink.add(geoScans);
    }
  );

  final validateHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {
      final List<ScanModel> geoScans = scans.where((s) => s.type == 'http').toList();
      sink.add(geoScans);
    }
  );
}