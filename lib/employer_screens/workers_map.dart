

import 'package:bluejobs/default_screens/view_profile.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class NearWorkers extends StatefulWidget {
  @override
  _NearWorkersState createState() => _NearWorkersState();
}

class _NearWorkersState extends State<NearWorkers> {
  final List<Marker> _markers = [];
  late LatLng _userLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = userDoc.data();
        if (data != null && data.containsKey('address')) {
          final address = data['address'];
          final coordinates = await _getCoordinatesFromAddress(address);
          if (coordinates != null) {
            setState(() {
              _userLocation = coordinates;
            });
          }
        }
      }
      await _loadPostMarkers();
    } catch (e) {
      print('Error loading user location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPostMarkers() async {
    try {
      final users = await FirebaseFirestore.instance.collection('users').get();
      if (users.docs.isEmpty) {
        print('No users found in Firestore.');
        return;
      }

      for (var doc in users.docs) {
        final data = doc.data();
        if (data['role'] == 'Job Hunter') {
          final address = data['address'];
          final coordinates = await _getCoordinatesFromAddress(address);
          if (coordinates != null) {
            final String title = data['firstName'] ?? 'Untitled User';
            final String userId = doc.id;
            final String profileImageUrl = data['profilePic'] ?? '';

            // setState(() {
            //   _markers.add(
            //     Marker(
            //       point: coordinates,
            //       width: 80.0,
            //       height: 80.0,
            //       child: GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => ProfilePage(userId: userId),
            //             ),
            //           );
            //         },
            //         child: Column(
            //           children: [
            //             CircleAvatar(
            //               backgroundImage: profileImageUrl.isNotEmpty
            //                   ? NetworkImage(profileImageUrl)
            //                   : const AssetImage('assets/default_avatar.jpg')
            //                       as ImageProvider,
            //               radius: 25,
            //             ),
            //             const SizedBox(height: 5),
            //             Text(
            //               title,
            //               style: const TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //             const Icon(
            //               Icons.location_on,
            //               color: Colors.redAccent,
            //               size: 50.0,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   );
            // });

            setState(() {
  _markers.add(
    Marker(
      point: coordinates,
      width: 80.0,
      height: 80.0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(userId: userId),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure it adapts to content size
          children: [
            CircleAvatar(
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : const AssetImage('assets/default_avatar.jpg') as ImageProvider,
              radius: 25,
            ),
            const SizedBox(height: 5),
            Flexible( // Prevent text overflow
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Truncate long text
              ),
            ),
            const Icon(
              Icons.location_on,
              color:  Color.fromARGB(255, 243, 107, 4),
              size: 25.0, // Reduced size to fit
            ),
          ],
        ),
      ),
    ),
  );
});

          } else {
            print('Failed to get coordinates for user: $data');
          }
        }
      }
    } catch (e) {
      print('Error loading user markers: $e');
    }
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final coordinates = locations.first;
        return LatLng(coordinates.latitude, coordinates.longitude);
      }
      return null;
    } catch (e) {
      print('Error occurred while getting coordinates: $e');
      return null;
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//      //   backgroundColor: Color.fromARGB(255, 7, 30, 47),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,
//               color: Color.fromARGB(255, 7, 30, 47),),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Find Others',
//           style: CustomTextStyle.semiBoldText
//               .copyWith(fontSize: responsiveSize(context, 0.04)),
//         ),
//          actions: [
//           IconButton(
//             icon: const Icon(Icons.my_location, color: Color.fromARGB(255, 7, 30, 47),),
//             onPressed: () {
//               setState(() {
//                 _loadUserLocation();
//               });
//             },
//           ),
//         ],
//       ),  
    
  
//    // backgroundColor: Color.fromARGB(255, 7, 30, 47), // Set the background color of the Scaffold
//     body: _isLoading
//         ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 7, 30, 47),))
//         : Container( // Wrap the Stack with a Container
//           height: MediaQuery.of(context).size.height - AppBar().preferredSize.height, // Set the height of the Container
//           child: Stack(
//             children: [
//               FlutterMap(
//                 options: MapOptions(
//                   center: _userLocation,
//                   zoom: 14.0,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     subdomains: ['a', 'b', 'c'],
//                   ),
//                   MarkerLayer(markers: _markers),
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         point: _userLocation,
//                         child: Icon(
//                           Icons.location_on,
//                           color: Colors.blueAccent,
//                           size: 50.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//        floatingActionButton: FloatingActionButton(
//     onPressed: _loadUserLocation,
//     child: const Icon(Icons.center_focus_strong),
//     tooltip: 'Center Map',
//   ),
//   );
// }



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 7, 30, 47)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Find Others',
        style: CustomTextStyle.semiBoldText.copyWith(
          fontSize: responsiveSize(context, 0.04),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.my_location, color: Color.fromARGB(255, 7, 30, 47)),
          onPressed: () {
            setState(() {
              _loadUserLocation();
            });
          },
        ),
      ],
    ),
    body: SafeArea(
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color.fromARGB(255, 7, 30, 47)),
            )
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: _userLocation,
                    zoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: _markers),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _userLocation,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _loadUserLocation,
      child: const Icon(Icons.center_focus_strong),
      tooltip: 'Center Map',
    ),
  );
}

}
   