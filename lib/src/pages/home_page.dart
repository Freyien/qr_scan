import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:qr_scan/src/pages/directions_page.dart';
import 'package:qr_scan/src/pages/maps_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      centerTitle: true,
      title: Text('QR Scanner'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.delete_forever), onPressed: (){})
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _scanQR
    );
  }

  _scanQR() async{
    //https://google.com
    //geo:19.546215591946453,-99.21018352317792

    String futureString = '';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    // print('Future String: $futureString');

    // if (futureString != null)
    //   print('Tenemos info');
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
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        )
      ]
    );
  }
}
