import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:load_frontend/services/area_service.dart';
import 'package:load_frontend/stores/user_store.dart';
import 'package:provider/provider.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import '../models/building_data.dart';

List<Color> generateDistinctColors(int count) {
  List<Color> colors = [];
  for (int i = 0; i < count; i++) {
    Color color = Colors.primaries[i % Colors.primaries.length].withOpacity(0.8);
    colors.add(color);
  }
  return colors;
}

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({Key? key}) : super(key: key);

  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  late GoogleMapController mapController;
  LatLng _center = LatLng(36.36405586, 127.3561363);
  LatLng newPosition = LatLng(36.36405586, 127.3561363);
  List<BuildingData> _buildingData = [];
  Set<Circle> _circles = {};
  // Set<Polyline> _polylines = {}; // Polyline set 추가
  List<MarkerData> _customMarkers = [];
  bool _mapControllerInitialized = false;
  List<Color> distinctColor = [];// distinctColor를 동적으로 생성하기 위해 리스트 초기화

  @override
  void initState() {
    super.initState();
    _loadBuildingData();
  }

  Future<void> _loadBuildingData() async {
    AreaService areaService = AreaService();
    UserStore userStore = Provider.of<UserStore>(context, listen: false);
    List<BuildingData> buildingdata = await areaService.getBuildingPriority(userStore.token);

    setState(() {
      _buildingData = buildingdata;
      distinctColor = generateDistinctColors(buildingdata.length); // 건물 데이터의 길이에 맞게 색상 생성
      _circles = _markCircles(buildingdata);
      _customMarkers = _getCustomMarkers(buildingdata);
      // _polylines = _createPolyline(buildingdata); // Polyline 생성
      if (_mapControllerInitialized) {
        _moveCamera(newPosition);
      }
    });
  }

  Set<Circle> _markCircles(List<BuildingData> buildings) {
    Set<Circle> circles = {};
    double new_latitude = 0;
    double new_longitude = 0;
    for (int i = 0; i < buildings.length; i++) {
      new_latitude += buildings[i].latitude;
      new_longitude += buildings[i].longitude;

      circles.add(
        Circle(
          circleId: CircleId(buildings[i].buildingId.toString()+"black"),
          center: LatLng(buildings[i].latitude,buildings[i].longitude),
          radius: 10,
          fillColor: Colors.black,
          strokeWidth: 3,
          strokeColor: Colors.transparent,
        ),
      );
      circles.add(
        Circle(
          circleId: CircleId(buildings[i].buildingId.toString()),
          center: LatLng(buildings[i].latitude,buildings[i].longitude),
          radius: 9,
          fillColor: distinctColor[i],
          strokeWidth: 3,
          strokeColor: Colors.transparent,
        ),
      );
    }
    if (buildings.isNotEmpty) {
      new_latitude = new_latitude / buildings.length;
      new_longitude = new_longitude / buildings.length;
      newPosition = LatLng(buildings[1].latitude,buildings[1].longitude);
    }
    return circles;
  }

  // Set<Polyline> _createPolyline(List<BuildingData> buildings) {
  //   Set<Polyline> polylines = {};
  //   for (int i = 0; i < buildings.length - 1; i++) {
  //     polylines.add(
  //       Polyline(
  //         polylineId: PolylineId(buildings[i].buildingId.toString()),
  //         points: [
  //           LatLng(buildings[i].latitude, buildings[i].longitude),
  //           LatLng(buildings[i + 1].latitude, buildings[i + 1].longitude),
  //         ],
  //         color: Colors.blue,
  //         width: 3,
  //       ),
  //     );
  //   }
  //   return polylines;
  // }

  List<MarkerData> _getCustomMarkers(List<BuildingData> buildings) {
    List<MarkerData> markers = [];
    for (int i = 0; i < buildings.length; i++) {
      markers.add(
        MarkerData(
          marker: Marker(
            markerId: MarkerId(buildings[i].buildingId.toString()),
            position: LatLng(buildings[i].latitude,buildings[i].longitude),
            infoWindow: InfoWindow(
              title: "배송 상품 개수 : ${buildings[i].totalGoods}",
              snippet: "${buildings[i].buildingName}",
            ),
          ),
          child: _customMarkerWidget(buildings[i],i),
        ),
      );
    }
    return markers;
  }

  Widget _customMarkerWidget(BuildingData building,int index) {

    final String fIndexStr = "F${(index).toString().padLeft(3, '0')}";
    return Container(
      //color: Colors.white.withOpacity(0.5),
      child:
          Text(
            fIndexStr,
            style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
    );
  }

  void _setMapStyle() async {
    String style = jsonEncode([
      {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
          { "visibility": "off" }
        ]
      }
    ]);
    mapController.setMapStyle(style);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
    _mapControllerInitialized = true;
    if (_buildingData.isNotEmpty) {
      _moveCamera(newPosition);
    }
  }

  void _moveCamera(LatLng target) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom:17.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: MaterialApp(
        home: Scaffold(
          body: CustomGoogleMapMarkerBuilder(
            customMarkers: _customMarkers,
            builder: (BuildContext context, Set<Marker>? markers) {
              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 20.0,
                ),
                circles: _circles,
                markers: markers ?? Set<Marker>(),
                // polylines: _polylines, // Polyline 추가
              );
            },
          ),
        ),
      ),
    );
  }
}