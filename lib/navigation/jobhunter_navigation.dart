// import 'package:bluejobs/chats/messaging_page.dart';
// import 'package:bluejobs/default_screens/search.dart';
// import 'package:bluejobs/jobhunter_screens/create_post.dart';
// import 'package:bluejobs/jobhunter_screens/jobhunter_home.dart';
// import 'package:bluejobs/jobhunter_screens/jobhunter_profile.dart';
// import 'package:flutter/material.dart';

// class JobhunterNavigation extends StatefulWidget {
//   const JobhunterNavigation({super.key});

//   @override
//   State<JobhunterNavigation> createState() => _JobhunterNavigationState();
// }

// class _JobhunterNavigationState extends State<JobhunterNavigation> {
//   int _selectedIndex = 0;
//   List<Widget> defaultScreens = <Widget>[
//     const JobHunterHomePage(),
//     const SearchPage(),
//     const PostPage(),
//     const MessagingPage(),
//     const JobHunterProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: defaultScreens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search_rounded),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_box),
//             label: 'Create ',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.message),
//             label: 'Chats',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         unselectedItemColor: const Color.fromARGB(255, 19, 8, 8),
//         selectedItemColor: const Color.fromARGB(255, 7, 16, 69),
//         currentIndex: _selectedIndex,
//         onTap: (value) {
//           setState(() {
//             _selectedIndex = value;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//       ),
//     );
//   }
// }



import 'package:bluejobs/chats/messaging_page.dart';
import 'package:bluejobs/default_screens/search.dart';
import 'package:bluejobs/jobhunter_screens/create_post.dart';
import 'package:bluejobs/jobhunter_screens/jobhunter_home.dart';
import 'package:bluejobs/jobhunter_screens/jobhunter_profile.dart';
import 'package:flutter/material.dart';

class JobhunterNavigation extends StatefulWidget {
  const JobhunterNavigation({super.key});

  @override
  State<JobhunterNavigation> createState() => _JobhunterNavigationState();
}

class _JobhunterNavigationState extends State<JobhunterNavigation> {
  int _selectedIndex = 0;
  List<Widget> defaultScreens = <Widget>[
    const JobHunterHomePage(),
    const SearchPage(),
    const PostPage(),
    const MessagingPage(),
    const JobHunterProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: defaultScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const  Color.fromARGB(255, 7, 30, 47),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? const Color.fromARGB(255, 243, 107, 4) : const Color.fromARGB(255, 255, 255, 255)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded, color: _selectedIndex == 1 ? Color.fromARGB(255, 243, 107, 4) : const Color.fromARGB(255, 255, 255, 255)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: _selectedIndex == 2 ? Color.fromARGB(255, 243, 107, 4) : const Color.fromARGB(255, 255, 255, 255)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: _selectedIndex == 3 ? Color.fromARGB(255, 243, 107, 4) : const Color.fromARGB(255, 255, 255, 255)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _selectedIndex == 4 ? Color.fromARGB(255, 243, 107, 4) : const Color.fromARGB(255, 255, 255, 255)),
            label: '',
          ),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}