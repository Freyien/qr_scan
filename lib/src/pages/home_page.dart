import 'dart:io';

import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:qr_scan/src/pages/directions_page.dart';
import 'package:qr_scan/src/pages/maps_page.dart';
import 'package:qr_scan/src/utils/utils.dart' as utils;

import 'package:qr_scan/src/bloc/scan_bloc.dart';
import 'package:qr_scan/src/models/scan_model.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scanBloc = new ScanBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _callPage(currentIndex),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('QR Scanner'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever), 
          onPressed: scanBloc.deleteAllScans
        )
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => _scanQR(context)
    );
  }

  _scanQR(BuildContext context) async {
    //https://google.com
    //geo:19.546215591946453,-99.21018352317792

    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString != null){
      final scanModel = ScanModel(value: futureString);
      scanBloc.addScan(scanModel);

      if ( Platform.isIOS ) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(context, scanModel);    
        });
      } else {
        utils.openScan(context, scanModel);
      }

    }
  }

  Widget _callPage(int currentIndex) {
    switch (currentIndex) {
      case 0: return MapsPage();
      case 1: return DirectionsPage();
      default: return MapsPage();
    }
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          title: Text('Páginas web')
        )
      ]
    );
  }
}
