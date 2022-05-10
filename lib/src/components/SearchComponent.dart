import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:wte_today/src/models/PhotoRefModel.dart';
import 'package:wte_today/src/models/PlacesModel.dart';
import 'package:google_maps_webservice/places.dart' as web_gmaps;
import '../providers/LocationProvider.dart';
import 'SetLocationComponent.dart';
import 'package:geocoding/geocoding.dart' as geo;

class SearchComponent extends StatefulWidget {
  const SearchComponent({Key? key}) : super(key: key);

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  static String googlePlacesAPIKey = 'AIzaSyB2EQRPjxCCuvlI6lXLp8yrvwurDmejgV4';
  final web_gmaps.GoogleMapsPlaces _places =
      web_gmaps.GoogleMapsPlaces(apiKey: googlePlacesAPIKey);
  List<web_gmaps.PlacesSearchResult> places = [];
  late GoogleMapController _controller;
  final Location _location = Location();
  late PlacesModel restaurant;
  List<PlacesModel> restaurants = [];

  List<PlacesModel> restaurantList = <PlacesModel>[];
  LatLng? latLng;

  getNearbyPlaces() {
    _location.getLocation().then(setCurrentLocation, onError: (e) {
      handleError(e);
    }).catchError(handleError);
  }

  FutureOr setCurrentLocation(LocationData value) async {
    latLng = LatLng(value.latitude!, value.longitude!);
    // _controller.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(target: latLng, zoom: 15),
    //   ),
    // );
    final location =
        web_gmaps.Location(lat: latLng!.latitude, lng: latLng!.longitude);
    // context.read<LocationProvider>().updateLocation(location);
    // Provider.of<LocationProvider>(context, listen: false)
    // .updateLocation(location);

    List<geo.Placemark> placemark =
        await geo.placemarkFromCoordinates(location.lat, location.lng);
    final String currentLocationStreetName =
        '현재 위치 : ' + placemark[0].street.toString();
    context.read<LocationProvider>().updateLocation(currentLocationStreetName);

    final result = await _places
        .searchNearbyWithRadius(location, 2500)
        .then(setNearbyPlaces, onError: (e) {
      handleError(e);
    }).catchError(handleError);
  }

  FutureOr setNearbyPlaces(web_gmaps.PlacesSearchResponse value) {
    for (web_gmaps.PlacesSearchResult result in value.results) {
      List<PhotoRefModel> photos = [];
      if (result.types.contains('restaurant')) {
        for (var photo in result.photos) {
          photos.add(
              PhotoRefModel(photo.height, photo.width, photo.photoReference));
        }
        restaurant = PlacesModel(
            result.placeId,
            result.name,
            result.rating as double,
            result.geometry!.location.lat,
            result.geometry!.location.lng,
            photos);
        restaurantList.add(restaurant);
      }
    }
    context.read<LocationProvider>().updateNearbyPlaces(restaurantList);

    // setState(() {
    //   restaurants = restaurantList;
    // });
  }

  void handleError(e) {
    print(e.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Expanded(
        //   child: TextField(
        //       decoration: const InputDecoration(
        //         hintText: '위치를 설정하세요',
        //         // labelText: context.read<LocationProvider>().location.toString(),
        //       ),
        //       keyboardType: TextInputType.text,
        //       onChanged: (text) {
        //         setState(() {
        //           inputText = text;
        //         });
        //       },
        //       // controller: searchController,
        //       // textInputAction: TextInputAction.go,
        //       onSubmitted: (value) {
        //         if (inputText != '') {
        //           // context.read<LocationProvider>().updateData(inputText);
        //           // Provider.of<LocationProvider>(context, listen: false)
        //           //     .updateData(value);
        //         } else {}
        //       }),
        // ),
        Text(context.watch<LocationProvider>().currentLocation),
        IconButton(
            onPressed: getNearbyPlaces,
            // () {
            //   if (inputText != '') {
            //     // context.read<LocationProvider>().updateData(inputText);
            //     // Provider.of<LocationProvider>(context, listen: false)
            //     //     .updateData(searchController.text);
            //   } else {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) {
            //       return const SetLocationComponent();
            //     }));
            //   }
            // },
            icon: const Icon(Icons.search))
      ]),
    );
  }
}
