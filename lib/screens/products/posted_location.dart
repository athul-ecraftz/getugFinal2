// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationMapScreen extends StatefulWidget {
//   @override
//   _LocationMapScreenState createState() => _LocationMapScreenState();
// }

// class _LocationMapScreenState extends State<LocationMapScreen> {
//   late String locationName;
//   late double latitude;
//   late double longitude;
//   late bool isLoading;

//   Future<void> fetchDataFromAPI() async {
//     String apiUrl =
//         '{{baseApiUrl}}fetchProductSinglePageLoad?ProductId=368'; // Your API endpoint
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         locationName =
//             data['address']; // Extracting address from the API response
//         final coordinates =
//             data['coordinates']; // Assuming your API provides coordinates
//         latitude = coordinates['lat']; // Extract latitude from API response
//         longitude = coordinates['lng']; // Extract longitude from API response
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       print('Error: $error');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     isLoading = true;
//     fetchDataFromAPI();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Map'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(latitude, longitude),
//                 zoom: 15,
//               ),
//               markers: {
//                 Marker(
//                   markerId: MarkerId('Location Marker'),
//                   position: LatLng(latitude, longitude),
//                   infoWindow: InfoWindow(title: locationName),
//                 ),
//               },
//               onMapCreated: (GoogleMapController controller) {},
//             ),
//     );
//   }
// }
