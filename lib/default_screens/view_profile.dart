import 'package:bluejobs/chats/messaging_roompage.dart';
import 'package:bluejobs/default_screens/comment.dart';
import 'package:bluejobs/provider/mapping/location_service.dart';
import 'package:bluejobs/provider/notifications/notifications_provider.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 200;
  final double profileHeight = 100;

  final _commentTextController = TextEditingController();
  Map<String, dynamic>? userData;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (userDoc.exists) {
      setState(() {
        userData = userDoc.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String firstName = userData?['firstName'] ?? '';
    String middleName = userData?['middleName'] ?? '';
    String lastName = userData?['lastName'] ?? '';
    String suffix = userData?['suffix'] ?? '';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        //  backgroundColor: Color.fromARGB(255, 7, 30, 47),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 7, 30, 47),),
          onPressed: () => Navigator.of(context).pop(),
        ),
          title:  Text('Profile', style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),),
          actions: [
            auth.currentUser?.uid != userData?['uid']
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: IconButton(
                      icon: const Icon(Icons.message, color: Color.fromARGB(255, 7, 30, 47),),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagingBubblePage(
                              receiverName:
                                  '$firstName $middleName $lastName $suffix',
                              receiverId: userData?['uid'],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
        body: Container(
      //   color:  Color.fromARGB(255, 7, 30, 47),
        child:userData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          buildProfilePicture(),
                          const SizedBox(height: 20),
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
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundImage: userData?['profilePic'] != null
          ? NetworkImage(userData!['profilePic'])
          : null,
      backgroundColor: Colors.white,
      child: userData?['profilePic'] == null
          ? Icon(Icons.person, size: profileHeight / 2)
          : null,
    );
  }

  Widget buildProfile() {
    String firstName = userData?['firstName'] ?? '';
    String middleName = userData?['middleName'] ?? '';
    String lastName = userData?['lastName'] ?? '';
    String suffix = userData?['suffix'] ?? '';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$firstName $middleName $lastName $suffix',
            style: CustomTextStyle.semiBoldText,
          ),
          Text(
            userData?['role'] ?? '',
            style: CustomTextStyle.typeRegularText,
          ),
        ],
      ),
    );
  }

  

  Widget buildTabBar() => Container(
  alignment: Alignment.center,
  child: TabBar(
    isScrollable: true,
    tabs: [
      SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: const Tab(text: 'Posts'),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: const Tab(text: 'About'),
      ),
    ],
    labelColor: const Color.fromARGB(255, 0, 0, 0), // White when selected
    unselectedLabelColor: const Color.fromARGB(255, 124, 118, 118), // Gray when not selected
    labelStyle: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
    indicator: BoxDecoration( // White indicator
      border: Border(
        bottom: BorderSide(
          color: const Color.fromARGB(255, 7, 30, 47),
          width: 2,
        ),
      ),
    ),
  ),
);

  Widget buildTabBarView() => TabBarView(
        children: [
          buildPostsTab(),
          buildAboutTab(userData?['uid'] ?? ''),
        ],
      );

  Widget buildPostsTab() {
    bool _isApplied = false;
    bool _isSaved = false;
    final PostsProvider postDetails = Provider.of<PostsProvider>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final PostsProvider postsProvider = PostsProvider();

    void showCommentDialog(String postId, BuildContext context) {
      showDialog(
        context: context,
        builder: (dialogContext) => CommentScreen(postId: postId),
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream: postsProvider.getSpecificPostsStream(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No posts available", style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                String name = post['name'];
                String userId = post['ownerId'];
                String role = post['role'];
                String profilePic = post['profilePic'] ?? '';
                String title = post['title'] ?? ''; // for job post
                String description = post['description'];
                String type = post['type'];
                String location = post['location'] ?? ''; // for job post

                String startDate = post['startDate'] ?? '';

                String workingHours =
                    post['workingHours'] ?? ''; // for job post

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                  //  color: const Color.fromARGB(255, 7, 30, 47),
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
                                    style:
                                        CustomTextStyle.semiBoldText.copyWith(
                            
                                      fontSize: responsiveSize(context, 0.04),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 55.0),
                                    child: Text(
                                      role,
                                      style: CustomTextStyle.typeRegularText.copyWith(
                            
                                      fontSize: responsiveSize(context, 0.04),)
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
                                  style: CustomTextStyle.semiBoldText,
                                )
                              : Container(),
                          const SizedBox(height: 15),
                          Text(
                            description,
                            style: CustomTextStyle.regularText,
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
                                      child: Text("Location: $location",
                                          style:  CustomTextStyle.regularText
                                              ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Text(
                            "Type of Job: $type",
                            style: CustomTextStyle.regularText.copyWith(
                            
                                      fontSize: responsiveSize(context, 0.04)),
                          ),

                          role == 'Employer'
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Working Hours: $workingHours",
                                          style: CustomTextStyle.regularText,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Start Date: $startDate",
                                          style: CustomTextStyle.regularText,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 20),
                          // comment section and like
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                role == 'Job Hunter'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final postId = post.id;
                                              final userId =
                                                  auth.currentUser!.uid;

                                              final postDoc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Posts')
                                                      .doc(postId)
                                                      .get();

                                              if (postDoc.exists) {
                                                final data = postDoc.data()
                                                    as Map<String, dynamic>;

                                                if (data.containsKey('likes')) {
                                                  final likes = (data['likes']
                                                          as List<dynamic>)
                                                      .map((e) => e as String)
                                                      .toList();

                                                  if (likes.contains(userId)) {
                                                    likes.remove(userId);
                                                  } else {
                                                    likes.add(userId);
                                                  }

                                                  await postDoc.reference
                                                      .update({'likes': likes});
                                                } else {
                                                  await postDoc.reference
                                                      .update({
                                                    'likes': [userId]
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.thumb_up_alt_rounded,
                                                  color: post.data() != null &&
                                                          (post.data() as Map<
                                                                  String,
                                                                  dynamic>)
                                                              .containsKey(
                                                                  'likes') &&
                                                          ((post.data() as Map<
                                                                      String,
                                                                      dynamic>)['likes']
                                                                  as List<
                                                                      dynamic>)
                                                              .contains(
                                                                  auth.currentUser!.uid)
                                                      ? const Color.fromARGB(255, 243, 107, 4)
                                                      : const  Color.fromARGB(255, 7, 30, 47),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  'Like (${(post.data() as Map<String, dynamic>)['likes']?.length ?? 0})',
                                                  style: CustomTextStyle
                                                      .regularText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 25),
                                          InkWell(
                                            onTap: () {
                                              showCommentDialog(
                                                  post.id, context);
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.comment, color:  Color.fromARGB(255, 7, 30, 47),),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Remarks',
                                                  style: CustomTextStyle
                                                      .regularText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 50,
                                          )
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(width: 5),
                                userId == auth.currentUser!.uid
                                    ? Container()
                                    : role == 'Employer'
                                        ? Expanded(
                                            child: FutureBuilder<bool>(
                                              future: _checkApplicationStatus(
                                                  post.id,
                                                  auth.currentUser!.uid),
                                              builder: (context, snapshot) {
                                                bool isApplied =
                                                    snapshot.data ?? false;
                                                return FutureBuilder<bool>(
                                                    future: _isPostUnavailable(
                                                        post.id),
                                                    builder: (context,
                                                        postSnapshot) {
                                                      bool isApplicationFull =
                                                          postSnapshot.data ??
                                                              false;
                                                      return GestureDetector(
                                                        onTap: isApplied ||
                                                                isApplicationFull
                                                            ? null
                                                            : () async {
                                                                final notificationProvider =
                                                                    Provider.of<
                                                                            NotificationProvider>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                String
                                                                    receiverId =
                                                                    userId;
                                                                String
                                                                    applicantName =
                                                                    auth.currentUser!
                                                                            .displayName ??
                                                                        'Unknown';
                                                                String
                                                                    applicantId =
                                                                    auth.currentUser!
                                                                        .uid;

                                                                await notificationProvider
                                                                    .someNotification(
                                                                  receiverId:
                                                                      receiverId,
                                                                  senderId: auth
                                                                      .currentUser!
                                                                      .uid,
                                                                  senderName:
                                                                      applicantName,
                                                                  title:
                                                                      'New Application',
                                                                  notif:
                                                                      ', applied to your job entitled "$title"',
                                                                );
                                                                await Provider.of<
                                                                            PostsProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyJob(
                                                                  post.id,
                                                                  title,
                                                                  description,
                                                                  userId,
                                                                  name,
                                                                );

                                                                await Provider.of<
                                                                            PostsProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .addApplicant(
                                                                        post.id,
                                                                        applicantId,
                                                                        applicantName);

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Successfully applied')),
                                                                );

                                                                setState(() {
                                                                  _isApplied =
                                                                      true;
                                                                });
                                                              },
                                                        child: Container(
                                                          height: 53,
                                                          width: 165,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: isApplied ||
                                                                      isApplicationFull
                                                                  ? Colors.grey
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      7,
                                                                      30,
                                                                      47),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Color.fromARGB(255, 7, 30, 47),
                                                          ),
                                                      child: Center(
                                                            child: Text(
                                                              isApplicationFull
                                                                  ? 'Unavailable'
                                                                  : postDetails
                                                                          .isJobPostAvailable
                                                                      ? (isApplied
                                                                          ? 'Applied'
                                                                          : 'Apply Job')
                                                                      : 'Apply Job',
                                                              style:
                                                                  CustomTextStyle
                                                                      .semiBoldText
                                                                      .copyWith(
                                                                color: isApplied ||
                                                                        isApplicationFull
                                                                    ? Colors
                                                                        .grey
                                                                    : const Color.fromARGB(255, 255, 255, 255),
                                                                fontSize:
                                                                    responsiveSize(
                                                                        context,
                                                                        0.03),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                          )
                                        : Container(),
                                const SizedBox(width: 10),
                                userId == auth.currentUser!.uid
                                    ? Container()
                                    : role == 'Employer'
                                        ? Expanded(
                                            child: FutureBuilder<bool>(
                                              future: _isPostAlreadySaved(
                                                  post.id,
                                                  auth.currentUser!.uid),
                                              builder: (context, snapshot) {
                                                bool isSaved =
                                                    snapshot.data ?? false;
                                                return GestureDetector(
                                                  onTap: isSaved
                                                      ? null
                                                      : () async {
                                                          final isSaved =
                                                              await postDetails
                                                                  .isPostSaved(
                                                                      post.id,
                                                                      auth.currentUser!
                                                                          .uid);
                                                          if (!isSaved) {
                                                            await postDetails
                                                                .savePost(
                                                                    post.id,
                                                                    auth.currentUser!
                                                                        .uid);
                                                            setState(() {
                                                              _isSaved = true;
                                                            });
                                                          }
                                                        },
                                                  child: Container(
                                                    height: 53,
                                                    width: 165,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: isSaved
                                                            ? Colors.grey
                                                            : Colors.orange,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: const Color.fromARGB(255, 243, 107, 4) ,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        isSaved
                                                            ? 'Saved'
                                                            : 'Save for Later',
                                                        style: CustomTextStyle
                                                            .semiBoldText
                                                            .copyWith(
                                                          color: isSaved
                                                              ? Colors.grey
                                                              : const Color.fromARGB(255, 255, 255, 255),
                                                          fontSize:
                                                              responsiveSize(
                                                                  context,
                                                                  0.03),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  // adding a comment
  void addComment(BuildContext context, String postId) async {
    if (_commentTextController.text.isNotEmpty) {
      String comment = _commentTextController.text;

      try {
        await Provider.of<PostsProvider>(context, listen: false)
            .addComment(comment, postId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment added successfully', style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e',style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)), )),
        );
      }
    }
  }

  Future<bool> _checkApplicationStatus(String postId, String userId) async {
    final postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);
    final postDoc = await postRef.get();
    final applicants = postDoc.get('applicants') as List<dynamic>?;
    return applicants != null && applicants.contains(userId);
  }

  Future<bool> _isPostAlreadySaved(String postId, String userId) async {
    final savedPostsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('saved')
        .doc(postId);
    final savedPostsDoc = await savedPostsRef.get();
    return savedPostsDoc.exists;
  }

  Future<bool> _isPostUnavailable(String postId) async {
    final postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);
    final postDoc = await postRef.get();
    final isApplicationFull = postDoc.get('isApplicationFull') as bool?;
    return isApplicationFull ?? false;
  }

  Widget buildAboutTab(String ratedUserId) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('users').doc(ratedUserId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final rating = userData['rating'] ?? 0;

          showRatingDialog() {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color.fromARGB(255, 7, 30, 47),
                  title: Text('Rate this user', style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),),
                  content: RatingBar(
                    initialRating: rating.toDouble(),
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Icon(Icons.star, color: Colors.orange),
                      half: Icon(Icons.star_half, color: Colors.orange),
                      empty: Icon(Icons.star_border, color: Colors.orange),
                    ),
                    onRatingUpdate: (rating) async {
                      await updateRating(rating, ratedUserId);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details',
                      style: CustomTextStyle.typeRegularText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveSize(context, 0.04))),
                  const SizedBox(height: 10),
                  buildResumeItem('Name', userData['firstName'] ?? ''),
                  buildResumeItem(
                      'Contact Number', userData['phoneNumber'] ?? ''),
                  buildResumeItem('Sex', userData['sex'] ?? ''),
                  buildResumeItem('Address', userData['address'] ?? ''),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(ratedUserId)
                        .collection('ratings')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final ratings = snapshot.data!.docs;
                        final rating = ratings.isEmpty
                            ? 0
                            : ratings
                                    .map((doc) => doc.data()['stars'])
                                    .reduce((a, b) => a + b) /
                                ratings.length;

                        return Column(
                          children: [
                            Text('Ratings',
                                style: CustomTextStyle.typeRegularText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: responsiveSize(context, 0.04))),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                final rating = 5 - index;
                                final ratingCount = ratings.where((doc) {
                                  final ratingValue = doc.data()['stars'];
                                  return ratingValue.toInt() == rating;
                                }).length;

                                return ListTile(
                                  title: Text(
                                    '$rating stars ($ratingCount)',
                            
                                    style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04))),
                                  
                                );
                              },
                            ),
                            Text('Average Rating: $rating',style: CustomTextStyle.semiBoldText, ),
                            const SizedBox(height: 10),

                            CustomButton(
  onPressed: showRatingDialog,
  buttonText: 'Rate this user',

),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> updateRating(double rating, String ratedUserId) async {
    try {
      final ratedUserRef =
          FirebaseFirestore.instance.collection('users').doc(ratedUserId);
      final ratingsRef = ratedUserRef.collection('ratings');

      await ratingsRef
          .where('raterId', isEqualTo: widget.userId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          ratingsRef.doc(doc.id).delete();
        });
      });

      await ratingsRef.add({
        'stars': rating,
        'raterId': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final ratedUserData =
          (await ratedUserRef.get()).data() as Map<String, dynamic>?;
      if (ratedUserData != null) {
        if (ratedUserData.containsKey('rating')) {
          final totalRating = ratedUserData['totalRating'] ?? 0;
          final ratingCount = ratedUserData['ratingCount'] ?? 0;

          await ratedUserRef.update({
            'totalRating': totalRating + rating - ratedUserData['rating'],
            'ratingCount': ratingCount,
            'rating': rating,
          });
        } else {
          await ratedUserRef.update({
            'totalRating': rating,
            'ratingCount': 1,
            'rating': rating,
          });
        }
      }
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  Widget buildResumeItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: CustomTextStyle.semiBoldText.copyWith(
               
                fontSize: responsiveSize(context, 0.04),
              ),
            ),
            TextSpan(
              text: content,
              style: CustomTextStyle.regularText.copyWith(
                fontSize: responsiveSize(context, 0.04),
              ),
            ),
          ],
        ),
      ),
    );
  }
}