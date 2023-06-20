import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services.dart';
import '../services/location_service.dart';
import '../widgets/custom_text_form_field.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool _search = false;
   final _apiService = ApiService();
   final _formKey = GlobalKey<FormState>();
  Marker _currentMarker = const Marker(markerId: MarkerId('currentLocation'));
  final Set<Marker> _markers = <Marker>{};
  int _markerIdCounter = 1;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void init() async{
     final data = await _apiService.getBranches();
    List<dynamic> branches = json.decode(data);
    _updateMarkers(branches);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            //markers: _markers..add(_currentMarker),
            //polylines: _polylines,
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
                      onTapSearchButton: () async {
                        var place = await LocationService()
                            .getPlace(_searchController.text);
                        //_userLocation(place);
                      },
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
    );
  }

  //Ir a las coordenadas ingresadas
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

//Dibujar el marcador en el mapa
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

  //Dibujar los marcadores de las branches
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
}
