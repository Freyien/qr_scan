import 'package:flutter/material.dart';

import 'package:qr_scan/src/bloc/scan_bloc.dart';
import 'package:qr_scan/src/models/scan_model.dart';
import 'package:qr_scan/src/utils/utils.dart' as utils;

class DirectionsPage extends StatelessWidget {
  final scanBloc = new ScanBloc();

  @override
  Widget build(BuildContext context) {
    scanBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scanBloc.scanStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if ( !snapshot.hasData )
          return Center(child: CircularProgressIndicator());
        
        final scans = snapshot.data;
        if (scans.length == 0)
          return Center(child: Text('No hay información'));

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            onDismissed: (dismissDirection) => scanBloc.deleteScan(scans[i]),
            background: Container( color: Colors.red, ),
            key: UniqueKey(), 
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),  
              title: Text(scans[i].value),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.openScan(context, scans[i])
            )
          )
        );

      },
    );
  }
}