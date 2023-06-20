import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _showCoordinates = false;

  TextEditingController _searchController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Búsqueda",
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Realizar acción de búsqueda aquí
                String searchTerm = _searchController.text;
                print("Búsqueda realizada: $searchTerm");
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: _showCoordinates,
              onChanged: (value) {
                setState(() {
                  _showCoordinates = value!;
                });
              },
            ),
            Text('Agregar coordenadas'),
          ],
        ),
        if (_showCoordinates)
          Column(
            children: [
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: "Latitud",
                ),
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: "Longitud",
                ),
              ),
            ],
          ),
      ],
    );
  }
}
