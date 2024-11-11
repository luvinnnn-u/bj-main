import 'package:bluejobs/chats/messaging_roompage.dart';
import 'package:bluejobs/default_screens/comment.dart';
import 'package:bluejobs/default_screens/side_nav.dart';
import 'package:bluejobs/default_screens/view_post.dart';
import 'package:bluejobs/jobhunter_screens/find_jobs.dart';
import 'package:bluejobs/default_screens/view_profile.dart';
import 'package:bluejobs/provider/notifications/notifications_provider.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bluejobs/default_screens/notification.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:provider/provider.dart';

class JobHunterHomePage extends StatefulWidget {
  const JobHunterHomePage({super.key});

  @override
  State<JobHunterHomePage> createState() => _JobHunterHomePageState();
}

class _JobHunterHomePageState extends State<JobHunterHomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  // bool _isApplied = false;
  // bool _isSaved = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void showCommentDialog(String postId, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommentScreen(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PostsProvider postDetails = Provider.of<PostsProvider>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
     // drawer: SideBar(),
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 7, 30, 47),
        leading: GestureDetector(
          onTap: () {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
          child: Image.asset('assets/images/prev.png'),
        ),
        actions: <Widget>[
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return Stack(
                children: <Widget>[
                  StreamBuilder(
                    stream: notificationProvider.getNotificationsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(color: Color.fromARGB(255, 7, 30, 47),);
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        int unreadNotifications = snapshot.data!.docs
                            .where((doc) => !doc['isRead'])
                            .length;

                        return Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsPage(),
                                  ),
                                );
                              },
                            ),
                            if (unreadNotifications > 0)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 243, 107, 4),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                  if (notificationProvider.unreadNotifications > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.find_in_page),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FindJobsPage()),
              );
            },
          )
        ],
      ),
    //  backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        color: Colors.white,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: postDetails.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}", style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No posts available", style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
                  );
                }

                final posts = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];

                      String name = post['name'];
                      String postId = post.id;
                      String userId = post['ownerId'];
                      String role = post['role'];
                      String profilePic = post['profilePic'] ?? '';
                      String title = post['title'] ?? '';
                      String description = post['description'];

                      return role == 'Employer'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                 
                                 side: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                  
                                ),
                                elevation: 4.0,
                                // margin: const EdgeInsets.fromLTRB(
                                //     0.0, 10.0, 0.0, 10.0),
                                 margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.0), // Adju
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(profilePic),
                                            radius: 30.0,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              userId: userId),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "$name",
                                                      style: CustomTextStyle
                                                          .semiBoldText
                                                          .copyWith(
                                                       
                                                        fontSize:
                                                            responsiveSize(
                                                                context, 0.04),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 1),
                                                    auth.currentUser?.uid !=
                                                            userId
                                                        ? IconButton(
                                                            icon: const Icon(
                                                                Icons.message, color: Color.fromARGB(255, 7, 30, 47)),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MessagingBubblePage(
                                                                    receiverName:
                                                                        name,
                                                                    receiverId:
                                                                        userId,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "$role",
                                                style: CustomTextStyle
                                                    .roleRegularText
                                                    .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      // post description
                                      role == 'Employer'
                                          ? Text(
                                              "$title",
                                              style:
                                                  CustomTextStyle.semiBoldText
                                                      .copyWith(fontSize: responsiveSize(context, 0.04)),
                                            )
                                          : Container(), // return empty 'title belongs to employer'
                                      const SizedBox(height: 5),
                                      Text(
                                        "$description",
                                        style: CustomTextStyle.regularText
                                            .copyWith(fontSize: responsiveSize(context, 0.04)),
                                      ),

                                      const SizedBox(height: 20),

                                      // view more, next page


                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewPostPage(
                                                            postId: post.id),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 53,
                                                width: 302,
                                                decoration: BoxDecoration(
                                                  
                                                  border: Border.all(
                                                    
                                                    color: Color.fromARGB(255, 243, 107, 4),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  
                                                  color: Color.fromARGB(255, 243, 107, 4),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'View More Details',
                                                    style: CustomTextStyle
                                                        .semiBoldText
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: responsiveSize(
                                                          context, 0.04),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

  
                                    ],
                                  ),
                                ),
                              ),
                            )

                            
                          : Container();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _refreshIndicatorKey.currentState?.show();

    final PostsProvider postDetails =
        Provider.of<PostsProvider>(context, listen: false);
    postDetails.refreshPosts();
  }
}