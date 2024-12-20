import 'package:bluejobs/employer_screens/applicants.dart';
import 'package:bluejobs/employer_screens/edit_jobpost.dart';
import 'package:bluejobs/employer_screens/verification.dart';
import 'package:bluejobs/jobhunter_screens/edit_post.dart';
import 'package:bluejobs/provider/mapping/location_service.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/screens_for_auth/edit_user_information.dart';
import 'package:bluejobs/screens_for_auth/signin.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:bluejobs/provider/auth_provider.dart' as auth_provider;

class EmployerProfilePage extends StatefulWidget {
  const EmployerProfilePage({super.key});

  @override
  State<EmployerProfilePage> createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  final double coverHeight = 200;
  final double profileHeight = 100;

  @override
  Widget build(BuildContext context) {
    final userLoggedIn =
        Provider.of<auth_provider.AuthProvider>(context, listen: false);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      buildProfilePicture(),
                      const SizedBox(height: 10),
                      buildProfile(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                buildTabBar(),
                SizedBox(
                  height: 500,
                  child: buildTabBarView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfilePicture() {
    final userLoggedIn =
        Provider.of<auth_provider.AuthProvider>(context, listen: false);
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundImage: userLoggedIn.userModel.profilePic != null
          ? NetworkImage(userLoggedIn.userModel.profilePic!)
          : null,
      backgroundColor: Colors.white,
      child: userLoggedIn.userModel.profilePic == null
          ? Icon(Icons.person, size: profileHeight / 2)
          : null,
    );
  }

  Widget buildProfile() {
    final userLoggedIn =
        Provider.of<auth_provider.AuthProvider>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${userLoggedIn.userModel.firstName} ${userLoggedIn.userModel.middleName} ${userLoggedIn.userModel.lastName} ${userLoggedIn.userModel.suffix}",
            style: CustomTextStyle.semiBoldText,
          ),
          Text(
            userLoggedIn.userModel.role,
            style: CustomTextStyle.typeRegularText,
          ),
        ],
      ),
    );
  }

  Widget buildTabBar() => Container(
 // color: Color.fromARGB(255, 7, 30, 47),
  alignment: Alignment.center,
  child: TabBar(
    isScrollable: true,
    indicatorColor: const Color.fromARGB(255, 49, 38, 38),
    indicatorWeight: 2,
    tabs: [
      Tab(
        text: 'My Posts',
      ),
      Tab(
        text: 'Applicants',
      ),
      Tab(
        text: 'About',
      ),
    ],
    labelStyle: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
    labelColor: const Color.fromARGB(255, 0, 0, 0),
    unselectedLabelColor: const Color.fromARGB(255, 124, 118, 118),
  ),
);

  Widget buildTabBarView() => TabBarView(
        children: [
          buildMyPostsTab(),
          buildApplicantsTab(),
          buildAboutTab(context),
        ],
      );

  Widget buildMyPostsTab() {
    final PostsProvider postsProvider = PostsProvider();
    return StreamBuilder<QuerySnapshot>(
      stream: _userId != null
          ? postsProvider.getSpecificPostsStream(_userId)
          : const Stream.empty(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white,),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}", style:  CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No posts available", style:  CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
          );
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            String name = post['name'];
            String role = post['role'];
            String postId = post.id;
            String profilePic = post['profilePic'];
            String title = post['title'] ?? ''; // for job post
            String description = post['description'];
            String type = post['type'];
            String location = post['location'] ?? ''; // for job post

            String startDate = post['startDate'] ?? '';

            String workingHours = post['workingHours'] ?? ''; // for job post

            bool isApplicationFull = post['isApplicationFull'] ?? false;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
               // color: Color.fromARGB(255, 7, 30, 47),
               color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4.0,
                // margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(profilePic),
                            radius: 35.0,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: CustomTextStyle.semiBoldText.copyWith(
                                  fontSize: responsiveSize(context, 0.04),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 55.0),
                                child: Text(
                                  role,
                                  style: CustomTextStyle.typeRegularText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      role == 'Employer'
                          ? Text(
                              title,
                              style: CustomTextStyle.semiBoldText.copyWith(
                                fontSize: responsiveSize(context, 0.04),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 15),
                      Text(
                        description,
                        style: CustomTextStyle.regularText.copyWith(
                          fontSize: responsiveSize(context, 0.04),
                        ),
                      ),
                      const SizedBox(height: 20),
                      role == 'Employer'
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final locations =
                                        await locationFromAddress(location);
                                    final lat = locations[0].latitude;
                                    final lon = locations[0].longitude;
                                    showLocationPickerModal(
                                        context,
                                        TextEditingController(
                                            text: '$lat, $lon'));
                                  },
                                  child: Text(
                                    location,
                                    style: CustomTextStyle.regularText.copyWith(
                                      fontSize: responsiveSize(context, 0.04),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      // Text(
                      //   "Type of Job: $type",
                      //   style: CustomTextStyle.regularText.copyWith(
                      //     fontSize: responsiveSize(context, 0.04),
                      //   ),
                      // ),
                      // Text(
                      //   "Working Hours: $workingHours",
                      //   style: CustomTextStyle.regularText.copyWith(
                      //     fontSize: responsiveSize(context, 0.04),
                      //   ),
                      // ),
                      // Text(
                      //   "Start Date: $startDate",
                      //   style: CustomTextStyle.regularText.copyWith(
                      //     fontSize: responsiveSize(context, 0.04),
                      //   ),
                      // ),
                      Row(
  children: [
    Text(
      "Type of Job: ",
      style: CustomTextStyle.semiBoldText.copyWith(
        fontSize: responsiveSize(context, 0.04),
      ),
    ),
    Text(
      type,
      style: CustomTextStyle.regularText.copyWith(
        fontSize: responsiveSize(context, 0.04),
      ),
    ),
  ],
),
Row(
  children: [
    Text(
      "Working Hours: ",
      style: CustomTextStyle.semiBoldText.copyWith(
        fontSize: responsiveSize(context, 0.04),
      ),
    ),
    Text(
      workingHours,
      style: CustomTextStyle.regularText.copyWith(
        fontSize: responsiveSize(context, 0.04),
      ),
    ),
  ],
),
Row(
  children: [
    Text(
      "Start Date: ",
      style: CustomTextStyle.semiBoldText.copyWith(
        fontSize: responsiveSize(context, 0.04),
      ),
    ),
    Text(
      startDate,
      style: CustomTextStyle.regularText.copyWith(
        fontSize: responsiveSize(context, 0.04),
      ),
    ),
  ],
),
                      const SizedBox(height: 15),
                      Row(
                        children: [

Row(
  children: [
    CustomButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplicantsPage(jobId: postId),
          ),
        );
      },
      buttonText: 'View Applicants',
      width: 320, // Specify a fixed width
      isLoading: false,
    ),
  ],
),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildApplicantsTab() {
    final PostsProvider postsProvider = PostsProvider();
    return StreamBuilder<QuerySnapshot>(
      stream: _userId != null
          ? postsProvider.getSpecificPostsStream(_userId)
          : const Stream.empty(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: //CircularProgressIndicator(),
            CircularProgressIndicator(color: Colors.white,),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}",  style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No job posts available", style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
          );
        }

        final jobPosts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: jobPosts.length,
          itemBuilder: (context, index) {
            final jobPost = jobPosts[index];

            String title = jobPost['title'];
            String description = jobPost['description'];
            bool isApplicationFull = jobPost['isApplicationFull'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                //color: const Color.fromARGB(255, 7, 30, 47),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4.0,
                margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: CustomTextStyle.semiBoldText.copyWith(
                          fontSize: responsiveSize(context, 0.04),
                        ),
                      ),
                      Text(
                        description,
                        style: CustomTextStyle.regularText.copyWith(
                          fontSize: responsiveSize(context, 0.04),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          CustomButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ApplicantsPage(jobId: jobPost.id),
                                ),
                              );
                            },
                            buttonText: 'View Applicants',
                        
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          // Container(
                          //   width: double.infinity,
                          //   height: 50,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //         color:
                          //             const Color.fromARGB(255, 7, 30, 47)),
                                      
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: TextButton(
                          //     onPressed: isApplicationFull
                          //         ? () async {
                          //             await Provider.of<PostsProvider>(context,
                          //                     listen: false)
                          //                 .setJobPostAsAvailable(jobPost.id);
                          //             setState(() {
                          //               isApplicationFull = false;
                          //             });
                          //           }
                          //         : () async {
                          //             await Provider.of<PostsProvider>(context,
                          //                     listen: false)
                          //                 .setJobPostAsUnavailable(jobPost.id);
                          //             setState(() {
                          //               isApplicationFull = true;
                          //             });
                          //           },
                          //     child: Text(
                          //       isApplicationFull
                          //           ? 'Make Available'
                          //           : 'Set as Unavailable',
                          //       style: CustomTextStyle.semiBoldText.copyWith(
                          //           fontSize: responsiveSize(context, 0.04),
                          //           color: const Color.fromARGB(255, 253, 253, 253)),
                          //     ),
                          //   ),
                          // ),

                          Container(
  width: double.infinity,
  height: 50,
  decoration: BoxDecoration(
    border: Border.all(color: const Color.fromARGB(255, 7, 30, 47)),
    borderRadius: BorderRadius.circular(15),
  ),
  child: TextButton(
    onPressed: isApplicationFull
        ? () async {
            await Provider.of<PostsProvider>(context, listen: false)
                .setJobPostAsAvailable(jobPost.id);
            setState(() {
              isApplicationFull = false;
            });
          }
        : () async {
            await Provider.of<PostsProvider>(context, listen: false)
                .setJobPostAsUnavailable(jobPost.id);
            setState(() {
              isApplicationFull = true;
            });
          },
    style: TextButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 7, 30, 47), // Set background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Match the container's border radius
      ),
    ),
    child: Text(
      isApplicationFull ? 'Make Available' : 'Set as Unavailable',
      style: CustomTextStyle.semiBoldText.copyWith(
        fontSize: responsiveSize(context, 0.04),
        color: const Color.fromARGB(255, 253, 253, 253), // Text color
      ),
    ),
  ),
),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  // Widget buildAboutTab(BuildContext context) {
  //   final userLoggedIn =
  //       Provider.of<auth_provider.AuthProvider>(context, listen: false);

  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         ListTile(
  //           leading: const Icon(Icons.settings,
  //               color: Color.fromARGB(255, 7, 30, 47)),
  //           title: Text(
  //             'Edit Profile',
  //             style: CustomTextStyle.semiBoldText.copyWith(
  //               fontSize: responsiveSize(context, 0.04),
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const EditUserInformation()),
  //             );
  //           },
  //           contentPadding: const EdgeInsets.all(10),
  //         ),
  //         if (userLoggedIn.isUserActivated == false)
  //           ListTile(
  //             leading: const Icon(Icons.check_circle_outline,
  //                 color: Color.fromARGB(255, 7, 30, 47)),
  //             title: Text(
  //               'Verify Account',
  //               style: CustomTextStyle.semiBoldText.copyWith(
  //                 fontSize: responsiveSize(context, 0.04),
  //               ),
  //             ),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => const VerificationForm()),
  //               );
  //             },
  //             contentPadding: const EdgeInsets.all(10),
  //           ),
  //         ListTile(
  //           leading: const Icon(Icons.logout_rounded,
  //               color: Color.fromARGB(255, 7, 30, 47)),
  //           title: Text(
  //             'Log Out',
  //             style: CustomTextStyle.semiBoldText.copyWith(
  //               fontSize: responsiveSize(context, 0.04),
  //             ),
  //           ),
  //           onTap: () {
  //             _showLogoutConfirmationDialog(context);
  //           },
  //           contentPadding: const EdgeInsets.all(10),
  //         ),
  //       ],
  //     ),
  //   );
  // }



  Widget buildAboutTab(BuildContext context) {
  final userLoggedIn =
      Provider.of<auth_provider.AuthProvider>(context, listen: false);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.settings,
              color: Color.fromARGB(255, 7, 30, 47)),
          title: Text(
            'Edit Profile',
            style: CustomTextStyle.semiBoldText.copyWith(
              fontSize: responsiveSize(context, 0.04),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditUserInformation()),
            );
          },
          contentPadding: const EdgeInsets.all(10),
        ),
        ListTile(
          leading: const Icon(Icons.check_circle_outline,
              color: Color.fromARGB(255, 7, 30, 47)),
          title: Text(
            'Verify Account',
            style: CustomTextStyle.semiBoldText.copyWith(
              fontSize: responsiveSize(context, 0.04),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VerificationForm()),
            );
          },
          contentPadding: const EdgeInsets.all(10),
        ),
        ListTile(
          leading: const Icon(Icons.logout_rounded,
              color: Color.fromARGB(255, 7, 30, 47)),
          title: Text(
            'Log Out',
            style: CustomTextStyle.semiBoldText.copyWith(
              fontSize: responsiveSize(context, 0.04),
            ),
          ),
          onTap: () {
            _showLogoutConfirmationDialog(context);
          },
          contentPadding: const EdgeInsets.all(10),
        ),
      ],
    ),
  );
}


  void _showLogoutConfirmationDialog(BuildContext context) {
    final userLoggedIn =
        Provider.of<auth_provider.AuthProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         // backgroundColor: Color.fromARGB(255, 7, 30, 47),
          title: Text('Log out',
              style: CustomTextStyle.semiBoldText
                  .copyWith(fontSize: responsiveSize(context, 0.04))),
          content: Text(
            'Are you sure you want to log out?',
            style: CustomTextStyle.regularText
                .copyWith(fontSize: responsiveSize(context, 0.04)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Hmm, no',
                style: CustomTextStyle.semiBoldText,
              ),
            ),
            TextButton(
              onPressed: () {
                userLoggedIn.userSignOut().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      ),
                    );
              },
              child: Text(
                'Yes, Im sure! ',
                style:
                    CustomTextStyle.semiBoldText.copyWith(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

}
