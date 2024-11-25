import 'package:bluejobs/chats/messaging_roompage.dart';
import 'package:bluejobs/default_screens/comment.dart';
import 'package:bluejobs/employer_screens/find_others.dart';
import 'package:bluejobs/default_screens/view_profile.dart';
import 'package:bluejobs/provider/notifications/notifications_provider.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bluejobs/default_screens/notification.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:provider/provider.dart';


class EmployerHomePage extends StatefulWidget {
  const EmployerHomePage({super.key});

  @override
  State<EmployerHomePage> createState() => _EmployerHomePageState();
}

class _EmployerHomePageState extends State<EmployerHomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final _commentTextController = TextEditingController();
 // int _postsToShow = 5;
  bool _isLoading = false;
  bool _isScrollAtEnd = false;

  void showCommentDialog(String postId, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommentScreen(postId: postId),
    );
  }

  // void _loadMorePosts() {
  //   setState(() {
  //     _postsToShow += 5;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        _isScrollAtEnd = true;
      } else {
        _isScrollAtEnd = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PostsProvider postDetails = Provider.of<PostsProvider>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
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
                        return CircularProgressIndicator();
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
                                    color: Colors.red,
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
                MaterialPageRoute(builder: (context) => const FindOthersPage()),
              );
            },
          )
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        // color: const Color.fromARGB(255, 212, 205, 205),
       // color: const Color.fromARGB(255, 7, 30, 47),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
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
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return  Center(
                      child: Text("No posts available", style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),),
                    );
                  }

                  final posts = snapshot.data!.docs;

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            // itemCount: _postsToShow < posts.length
                            //     ? _postsToShow
                            //     : posts.length,
                             itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];

                              String name = post['name'];

                              String userId = post['ownerId'];
                              String role = post['role'];
                              String profilePic = post['profilePic'] ?? '';
                              String title = post['title'] ?? '';
                              String description = post['description'];
                              String type = post['type'];

                              return role == 'Job Hunter'
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        // color: const Color.fromARGB(
                                        //     255, 7, 30, 47),
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        elevation: 4.0,
                                        // margin: const EdgeInsets.fromLTRB(
                                        //     0.0, 10.0, 0.0, 10.0),
                                         margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.0),
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
                                                        NetworkImage(
                                                            profilePic),
                                                    radius: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePage(
                                                                      userId:
                                                                          userId),
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
                                                                        context,
                                                                        0.04),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 1),
                                                            auth.currentUser
                                                                        ?.uid !=
                                                                    userId
                                                                ? IconButton(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .message,
                                                                      color: Color.fromARGB(255, 7, 30, 47),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
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
                                                            .regularText,
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
                                                      style: CustomTextStyle
                                                          .semiBoldText,
                                                    )
                                                  : Container(), // return empty 'title belongs to employer'
                                              const SizedBox(height: 5),
                                              Text(
                                                "$description",
                                                style:
                                                    CustomTextStyle.regularText,
                                              ),

                                              Text(
                                                "Type of Job: $type",
                                                style:
                                                    CustomTextStyle.regularText,
                                              ),

                                              const SizedBox(height: 15),

                                              // comment section and like
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    role == 'Job Hunter'
                                                        ? 
                                                        Expanded(
                  
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final postId =
                                                                        post.id;
                                                                    final userId = auth
                                                                        .currentUser!
                                                                        .uid;

                                                                    final postDoc = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Posts')
                                                                        .doc(
                                                                            postId)
                                                                        .get();

                                                                    if (postDoc
                                                                        .exists) {
                                                                      final data = postDoc
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>;

                                                                      if (data.containsKey(
                                                                          'likes')) {
                                                                        final likes = (data['likes']
                                                                                as List<dynamic>)
                                                                            .map((e) => e as String)
                                                                            .toList();

                                                                        if (likes
                                                                            .contains(userId)) {
                                                                          likes.remove(
                                                                              userId);
                                                                        } else {
                                                                          likes.add(
                                                                              userId);
                                                                        }

                                                                        await postDoc
                                                                            .reference
                                                                            .update({
                                                                          'likes':
                                                                              likes
                                                                        });
                                                                      } else {
                                                                        await postDoc
                                                                            .reference
                                                                            .update({
                                                                          'likes':
                                                                              [
                                                                            userId
                                                                          ]
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .thumb_up_alt_rounded,
                                                                        color: post.data() != null && (post.data() as Map<String, dynamic>).containsKey('likes') && ((post.data() as Map<String, dynamic>)['likes'] as List<dynamic>).contains(auth.currentUser!.uid)
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                243,
                                                                                107,
                                                                                4)
                                                                            :  Color.fromARGB(255, 7, 30, 47),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              3),
                                                                      Text(
                                                                        'Like (${(post.data() as Map<String, dynamic>)['likes']?.length ?? 0})',
                                                                        style: CustomTextStyle
                                                                            .regularText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // const SizedBox(
                                                                //     width: 3),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final postId =
                                                                        post.id;
                                                                    final userId = auth
                                                                        .currentUser!
                                                                        .uid;

                                                                    final postDoc = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Posts')
                                                                        .doc(
                                                                            postId)
                                                                        .get();

                                                                    if (postDoc
                                                                        .exists) {
                                                                      final data = postDoc
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>;

                                                                      if (data.containsKey(
                                                                          'dislikes')) {
                                                                        final dislikes = (data['dislikes']
                                                                                as List<dynamic>)
                                                                            .map((e) => e as String)
                                                                            .toList();

                                                                        if (dislikes
                                                                            .contains(userId)) {
                                                                          dislikes
                                                                              .remove(userId);
                                                                        } else {
                                                                          dislikes
                                                                              .add(userId);
                                                                        }

                                                                        await postDoc
                                                                            .reference
                                                                            .update({
                                                                          'dislikes':
                                                                              dislikes
                                                                        });
                                                                      } else {
                                                                        await postDoc
                                                                            .reference
                                                                            .update({
                                                                          'dislikes':
                                                                              [
                                                                            userId
                                                                          ]
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .thumb_down_alt_rounded,
                                                                        color: post.data() != null && (post.data() as Map<String, dynamic>).containsKey('dislikes') && ((post.data() as Map<String, dynamic>)['dislikes'] as List<dynamic>).contains(auth.currentUser!.uid)
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                243,
                                                                                107,
                                                                                4)
                                                                            : const Color.fromARGB(255, 7, 30, 47),
                                                                      ),
                                                                   //   const SizedBox(
                                                                      //    width:
                                                                        //      3),
                                                                      Text(
                                                                        'Dislike (${(post.data() as Map<String, dynamic>)['dislikes']?.length ?? 0})',
                                                                        style: CustomTextStyle
                                                                            .regularText,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 3),
                                                                InkWell(
                                                                  onTap: () {
                                                                    showCommentDialog(
                                                                        post.id,
                                                                        context);
                                                                  },
                                                                  child:
                                                                      FutureBuilder(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Posts')
                                                                        .doc(post
                                                                            .id)
                                                                        .collection(
                                                                            'Comments')
                                                                        .get(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        final commentCount = snapshot
                                                                            .data!
                                                                            .docs
                                                                            .length;
                                                                        return Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.comment,
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                            ),
                                                                         //   const SizedBox(width: 3),
                                                                            Text(
                                                                              'Remarks ($commentCount)',
                                                                              style: CustomTextStyle.regularText,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      } else {
                                                                        return const Row(
                                                                          children: [
                                                                            Icon(Icons.comment,
                                                                                color: Color.fromARGB(255, 0, 0, 0)),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              'Comments (0)',
                                                                              style: CustomTextStyle.regularText,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 50),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                    const SizedBox(width: 5),
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
                        ),
                        // if (_isScrollAtEnd && _postsToShow < posts.length)
                        //   ElevatedButton(
                        //     onPressed: _loadMorePosts,
                        //     child: const Text('See More'),
                        //   ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // adding a comment
  void addComment(BuildContext context, String postId) async {
    if (_commentTextController.text.isNotEmpty) {
      String comment = _commentTextController.text;

      try {
        await Provider.of<PostsProvider>(context, listen: false)
            .addComment(comment, postId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _refreshIndicatorKey.currentState?.show();

    final PostsProvider postDetails =
        Provider.of<PostsProvider>(context, listen: false);
    postDetails.refreshPosts();
  }
}
