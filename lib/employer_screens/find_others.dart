import 'package:bluejobs/employer_screens/workers_map.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindOthersPage extends StatefulWidget {
  const FindOthersPage({super.key});

  @override
  State<FindOthersPage> createState() => _FindOthersPageState();
}

class _FindOthersPageState extends State<FindOthersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final usersSnapshot = await usersRef.get();
    List<Map<String, dynamic>> allUsers = usersSnapshot.docs
        .where((doc) => doc.get('role') == 'Job Hunter')
        .map((doc) {
      return {
        'id': doc.id,
        'firstName': doc.get('firstName') ?? '',
        'middleName': doc.get('middleName') ?? '',
        'lastName': doc.get('lastName') ?? '',
        'suffix': doc.get('suffix') ?? '',
        'profilePic': doc.get('profilePic') ?? '',
        'role': doc.get('role') ?? '',
        'uid': doc.get('uid') ?? '',
        'skills': (doc.get('skills') as List<dynamic>).join(', ') ?? '',
      };
    }).toList();
    setState(() {
      _allUsers = allUsers;
      _filteredUsers = allUsers;
    });
  }

  void _filterUsersBySkill(String query) {
    List<Map<String, dynamic>> filteredUsers = _allUsers.where((user) {
      return user['skills'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredUsers = filteredUsers;
    });
  }

  Widget build(BuildContext context) {
   // final appBarColor = Color.fromARGB(255, 7, 30, 47);

    return Scaffold(
      appBar: AppBar(
    //    backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 7, 30, 47)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Find Others',
          style: CustomTextStyle.semiBoldText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ),
      ),
      body: Container(
     //   color: Color.fromARGB(255, 7, 30, 47),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Connect with everyone easily!',
                  style: CustomTextStyle.semiBoldText
                      .copyWith(fontSize: responsiveSize(context, 0.04)),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NearWorkers(),
                      ),
                    );
                  },
                  buttonText: 'Find workers near me',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
