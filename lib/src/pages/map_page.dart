import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qr_scan/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController controller = MapController();
  String mapType = 'streets';
  final zoom = 15.0;

  @override
  Widget build(BuildContext context) {
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              controller.move(scanModel.getLatLng(), zoom);
            }
          )
        ],
      ),
      body: _flutterMap(scanModel),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _flutterMap(ScanModel scanModel) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        center: scanModel.getLatLng(),
        zoom: zoom
      ),
      layers: [
        _drawMap(),
        _drawMarkers(scanModel)
      ],
    );
  }

  LayerOptions _drawMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiZnJleWllbiIsImEiOiJjazlqMGphM2wwMHNnM2VwNzVmYnV0ZXFvIn0.o-Xr66TkC3JZdwCVfacaaw',
        'id': 'mapbox.$mapType' //streets, dark, light, outdoors, satellite
      }
    );
  }

  LayerOptions _drawMarkers(ScanModel scanModel) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          point: scanModel.getLatLng(),
          builder: (BuildContext context) => Icon(
            Icons.location_on, 
            size: 50, 
            color: Theme.of(context).primaryColor
          )
        )
      ]
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        //streets, dark, light, outdoors, satellite
        if ( mapType == 'streets' )
          mapType = 'dark';
        else if ( mapType == 'dark' )
          mapType = 'light';
        else if ( mapType == 'light' )
          mapType = 'outdoors';
        else if ( mapType == 'outdoors' )
          mapType = 'satellite';
        else
          mapType = 'streets';

        setState(() {});
      },
      child: Icon(Icons.map),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}