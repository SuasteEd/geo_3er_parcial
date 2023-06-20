import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geo_3er_parcial/services/api_services.dart';
import 'package:geo_3er_parcial/widgets/custom_text_form_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Intancia de API
  final _apiService = ApiService();
  bool _search = false;
  Marker _currentMarker = const Marker(markerId: MarkerId('currentLocation'));
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final Set<Marker> _markers = <Marker>{};
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polylines = <Polyline>{};
  final List<LatLng> _polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;
  int _markerIdCounter = 1;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final data = await _apiService.getBranches();
    List<dynamic> branches = json.decode(data);
    _updateMarkers(branches);
    _setPolyline(branches
        .map((branch) => PointLatLng(double.parse(branch['latitude']),
            double.parse(branch['longitude'])))
        .toList());
   // _setPolygon();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: const CameraPosition(
              target: LatLng(21.15774731319369, -101.70571275200567),
              zoom: 12.4746,
            ),
            markers: _markers..add(_currentMarker),
            polylines: _polylines,
            //polygons: _polygons,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
              top: size.height / 20,
              left: 0,
              right: 0,
              child: !_search
                  ? CustomTextFormField(
                      keyboardType: TextInputType.text,
                      controller: _searchController,
                      labelText: "Búsqueda",
                      hintText: "Escribe aquí tu búsqueda",
                      onTapChangeButton: () {
                        setState(() {
                          _search = !_search;
                        });
                      },
                      onTapSearchButton: () {},
                    )
                  : AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      //height: size.height / 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextFormField(
                              keyboardType: TextInputType.number,
                              controller: _originController,
                              labelText: 'Latitud',
                              hintText: 'Escribe aquí la latitud',
                              onTapChangeButton: () {
                                setState(() {
                                  _search = !_search;
                                });
                              },
                              onTapSearchButton: () async {
                                if (_formKey.currentState!.validate()) {
                                 await _goToTheCoordinates();
                               
                                }
                              },
                            ),
                            const Divider(color: Colors.black),
                            CustomTextFormField(
                              keyboardType: TextInputType.number,
                              controller: _destinationController,
                              labelText: 'Longitud',
                              hintText: 'Escribe aquí la longitud',
                              onTapChangeButton: () {
                                setState(() {
                                  _search = !_search;
                                });
                              },
                              onTapSearchButton: () {
                                if (_formKey.currentState!.validate()) {
                                  print('Latitud: ${_originController.text}');
                                  print(
                                      'Longitud: ${_destinationController.text}');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
        ],
      ),
      //floatingActionButton: MenuSpeedDial(),
    );
  }

  Future<void> _goToTheCoordinates() async {
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(double.parse(_originController.text),
          double.parse(_destinationController.text)),
      zoom: 19,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    _setMarker(
        LatLng(double.parse(_originController.text),
            double.parse(_destinationController.text)),
        BitmapDescriptor.defaultMarker);
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    CameraPosition kPlaceCameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: 12);
    controller.animateCamera(CameraUpdate.newCameraPosition(
      kPlaceCameraPosition,
    ));
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));
    _setMarker(LatLng(lat, lng), BitmapDescriptor.defaultMarker);
  }

  void _setMarker(LatLng point, BitmapDescriptor icon) {
    setState(() {
      final String markerIdVal = 'marker_$_markerIdCounter';
      _markerIdCounter++;
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: point,
          icon: icon,
        ),
      );
    });
  }

  void _createRoute(LatLng origin, LatLng destination) async {
     PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> result = [];

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      ApiConstants.key,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (polylineResult.points.isNotEmpty) {
      polylineResult.points.forEach((PointLatLng point) {
        result.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  void _updateMarkers(List<dynamic> branches) async {
    ByteData imageData = await rootBundle.load('assets/images/marker.gif');
    BitmapDescriptor customMarker =
        BitmapDescriptor.fromBytes(imageData.buffer.asUint8List());

    setState(() {
      _markers.clear();
      for (var branch in branches) {
        final latitude = double.parse(branch['latitude']);
        final longitude = double.parse(branch['longitude']);
        String branchName = branch['name'];
        // Agregar el marcador al conjunto de marcadores
        _markers.add(
          Marker(
            markerId: MarkerId(branchName),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: branchName),
            icon: customMarker,
          ),
        );
      }

      _markers.add(_currentMarker);
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: _polygonLatLngs,
      strokeWidth: 2,
      fillColor: Colors.transparent,
    ));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
      ),
    );
  }
}

//CALCULAR DISTANCIA ENTRE DOS PUNTOS
  double _calculateDistance(LatLng origin, LatLng destination) {
    double lat1 = origin.latitude;
    double lng1 = origin.longitude;
    double lat2 = destination.latitude;
    double lng2 = destination.longitude;

    const int radius = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

class MenuSpeedDial extends StatelessWidget {
  const MenuSpeedDial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: SpeedDial(
        backgroundColor: Colors.green.withOpacity(0.8),
        tooltip: 'Menú',
        animatedIcon: AnimatedIcons.menu_home,
        //overlayColor: Colors.transparent,
        children: [
          SpeedDialChild(
            child: const Icon(CupertinoIcons.location),
            backgroundColor: Colors.amber.withOpacity(0.7),
            label: 'Búsqueda por coordenadas',
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'welcome', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
