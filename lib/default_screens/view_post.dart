import 'package:bluejobs/chats/messaging_roompage.dart';
import 'package:bluejobs/default_screens/comment.dart';
import 'package:bluejobs/default_screens/view_profile.dart';
import 'package:bluejobs/jobhunter_screens/resume_form.dart';
import 'package:bluejobs/provider/mapping/location_service.dart';
import 'package:bluejobs/provider/notifications/notifications_provider.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class ViewPostPage extends StatefulWidget {
  final String postId;

  const ViewPostPage({super.key, required this.postId});

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  bool _isSaved = false;
  bool _isApplied = false;
  final _commentTextController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void showCommentDialog(String postId, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommentScreen(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PostsProvider postDetails = Provider.of<PostsProvider>(context);
    return Scaffold(
      
      appBar: AppBar(
  
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 7, 30, 47)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'View Post',
          style: CustomTextStyle.semiBoldText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Posts')
              .doc(widget.postId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("No post available"),
              );
            }

            final post = snapshot.data!;

            String name = post['name'];
            String userId = post['ownerId'];
            String role = post['role'];
            String profilePic = post['profilePic'];
            String title = post['title'] ?? ''; // for job post
            String description = post['description'];
            String type = post['type'];
            String location = post['location'] ?? ''; // for job post

            String startDate = post['startDate'] ?? '';

            String workingHours = post['workingHours'] ?? ''; // for job post

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePic),
                          radius: 27.0,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(userId: userId),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "$name",
                                    style:
                                        CustomTextStyle.semiBoldText.copyWith(
                                      fontSize: responsiveSize(context, 0.04),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  auth.currentUser?.uid != userId
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.message,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MessagingBubblePage(
                                                  receiverName: name,
                                                  receiverId: userId,
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
                              style: CustomTextStyle.regularText,
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
                            style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
                          )
                        : Container(), // return empty 'title belongs to employer'
                    const SizedBox(height: 5),
                    Text(
                      "$description",
                      style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),
                    ),
                    const SizedBox(height: 15),
                    role == 'Employer'
                        ? Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: Color.fromARGB(255, 243, 107, 4),
                              ),
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
                                child: Text("$location ",
                                    style: CustomTextStyle.regularText,
                                            ),
                              ),
                            ],
                          )
                        : Container(),
                    Text(
                      "Type of Job: $type",
                      style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
                    ),
                    role == 'Employer'
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Working Hours: $workingHours",
                                    //style: CustomTextStyle.regularText,
                                    style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Start Date: $startDate",
                                  style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 20),
                    // comment section and like
                   // Padding(
                     // padding: const EdgeInsets.all(1.0),
                    //  child:
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          role == 'Job Hunter'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final postId = post.id;
                                        final userId = auth.currentUser!.uid;

                                        final postDoc = await FirebaseFirestore
                                            .instance
                                            .collection('Posts')
                                            .doc(postId)
                                            .get();

                                        if (postDoc.exists) {
                                          final data = postDoc.data()
                                              as Map<String, dynamic>;

                                          if (data.containsKey('likes')) {
                                            final likes =
                                                (data['likes'] as List<dynamic>)
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
                                            await postDoc.reference.update({
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
                                                    (post.data() as Map<String,
                                                            dynamic>)
                                                        .containsKey('likes') &&
                                                    ((post.data() as Map<String,
                                                                    dynamic>)[
                                                                'likes']
                                                            as List<dynamic>)
                                                        .contains(auth
                                                            .currentUser!.uid)
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'React (${(post.data() as Map<String, dynamic>)['likes']?.length ?? 0})',
                                            style: CustomTextStyle.regularText,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    InkWell(
                                      onTap: () {
                                        showCommentDialog(post.id, context);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.comment),
                                          SizedBox(width: 5),
                                          Text(
                                            'Comments',
                                            style: CustomTextStyle.regularText,
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
                                  ? StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(auth.currentUser!.uid)
                                          .collection('resume')
                                          .doc(auth.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          bool hasResume =
                                              snapshot.data!.exists;
                                          return FutureBuilder<bool>(
                                            future: _checkApplicationStatus(
                                                post.id, auth.currentUser!.uid),
                                            builder:
                                                (context, applicationSnapshot) {
                                              bool isApplied =
                                                  applicationSnapshot.data ??
                                                      false;
                                              return FutureBuilder<bool>(
                                                future:
                                                    _isPostUnavailable(post.id),
                                                builder:
                                                    (context, postSnapshot) {
                                                  bool isApplicationFull =
                                                      postSnapshot.data ??
                                                          false;
                                                  return GestureDetector(
                                                    onTap: hasResume &&
                                                            !isApplied &&
                                                            !isApplicationFull
                                                        ? () async {
                                                            final userRef =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users')
                                                                    .doc(auth
                                                                        .currentUser!
                                                                        .uid);
                                                            final notificationProvider =
                                                                Provider.of<
                                                                        NotificationProvider>(
                                                                    context,
                                                                    listen:
                                                                        false);
                                                            String receiverId =
                                                                userId;
                                                            String
                                                                applicantName =
                                                                auth.currentUser!
                                                                        .displayName ??
                                                                    'Unknown';
                                                            String applicantId =
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
                                                              applicantName,
                                                            );

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                           SnackBar(
                                                                backgroundColor:
                                                                    Color.fromARGB(255, 243, 107, 41),
                                                                content: Text(
                                                                    'Successfully applied', style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04,), color: Colors.white),),
                                                              ),
                                                            );

                                                            setState(() {
                                                              _isApplied = true;
                                                            });
                                                          }
                                                        : hasResume
                                                            ? null
                                                            : () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (dialogContext) =>
                                                                          AlertDialog(
                                                                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                                    title: Text(
                                                                      'Oops!',
                                                                      style: CustomTextStyle
                                                                          .semiBoldText
                                                                          .copyWith(
                                                                              fontSize: responsiveSize(context, 0.04)),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      'Looks like your resume is empty or not updated. Consider updating it first before applying to jobs.',
                                                                      style: CustomTextStyle
                                                                          .regularText
                                                                          .copyWith(
                                                                              fontSize: responsiveSize(context, 0.04)),
                                                                    ),
                                                                    actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              dialogContext);
                                                                        },
                                                                        child: Text(
                                                                            'Cancel', style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04))),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => ResumeForm(),
                                                                            ),
                                                                          ).then(
                                                                              (_) {
                                                                            setState(() {});
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                            'Proceed' , style: CustomTextStyle.typeRegularText.copyWith(fontSize: responsiveSize(context, 0.04), fontWeight: FontWeight.bold)),
                                                                      ),
                                                                    ],
                                                                  ),

//                                                                   AlertDialog(
//   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//   title: Text(
//     'Oops!',
//     style: CustomTextStyle.semiBoldText.copyWith(
//       fontSize: responsiveSize(context, 0.04),
//     ),
//   ),
//   content: Text(
//     'Looks like your resume is empty or not updated. Consider updating it first before applying to jobs.',
//     style: CustomTextStyle.regularText.copyWith(
//       fontSize: responsiveSize(context, 0.03),
//     ),
//   ),
//   actions: [
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color.fromARGB(255, 7, 30, 47), // Set your button color here
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Adjust padding as needed
//         textStyle: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),
//       ),
//       onPressed: () {
//         Navigator.pop(dialogContext);
//       },
//       child: Text('Cancel'),
//     ),
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color.fromARGB(255, 7, 30, 47), // Set your button color here
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Adjust padding as needed
//         textStyle: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),
//       ),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResumeForm(),
//           ),
//         ).then((_) {
//           setState(() {});
//         });
//       },
//       child: Text('Proceed'),
//     ),
//   ],
// ),
                                                                );
                                                              },

                                                    child: Container(
                                                      height: 53,
                                                      width: 155,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: !isApplied &&
                                                                  !isApplicationFull
                                                              ? const Color
                                                                  .fromARGB(255, 243, 107, 4)
                                                              : Colors.grey,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: const Color.fromARGB(255, 243, 107, 4),
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
                                                          style: CustomTextStyle
                                                              .semiBoldText
                                                              .copyWith(
                                                            color: !isApplied &&
                                                                    !isApplicationFull
                                                                ? const Color.fromARGB(255, 255, 255, 255)
                                                                : Colors.grey,
                                                            fontSize:
                                                                responsiveSize(
                                                                    context,
                                                                    0.04),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    )
                                    
                                  : Container(),
                          const SizedBox(width: 5),
                          userId == auth.currentUser!.uid
                              ? Container()
                              : role == 'Employer'
                                  ? FutureBuilder<bool>(
                                      future: _isPostAlreadySaved(
                                          post.id, auth.currentUser!.uid),
                                      builder: (context, snapshot) {
                                        bool isSaved = snapshot.data ?? false;
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
                                                    await postDetails.savePost(
                                                        post.id,
                                                        auth.currentUser!.uid);
                                                    setState(() {
                                                      _isSaved = true;
                                                    });
                                                  }
                                                },
                                          child: Container(
                                            height: 53,
                                            width: 155,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isSaved
                                                    ? Colors.grey
                                                    :  Color.fromARGB(255, 7, 30, 47),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color.fromARGB(255, 7, 30, 47),
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
                                                      ? const Color.fromARGB(255, 255, 255, 255)
                                                      : const Color.fromARGB(255, 255, 255, 255),
                                                  fontSize: responsiveSize(
                                                      context, 0.04),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(),
                        ],
                      ),
                  //  ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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

  // adding a comment
  void addComment(BuildContext context, String postId) async {
    if (_commentTextController.text.isNotEmpty) {
      String comment = _commentTextController.text;

      try {
        await Provider.of<PostsProvider>(context, listen: false)
            .addComment(comment, postId);
        // You can add a success message here if you want
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment added successfully', style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),),
          backgroundColor: Color.fromARGB(255, 243, 107, 4),
          ),

        );
      } catch (e) {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          
          SnackBar(content: Text('Failed to add comment: $e', style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04))),
          backgroundColor: Color.fromARGB(255, 243, 107, 4),
          ),
        );
      }
    }
  }
}





