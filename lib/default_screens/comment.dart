import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// class CommentScreen extends StatefulWidget {
//   final String postId;

//   const CommentScreen({super.key, required this.postId});

//   @override
//   State<CommentScreen> createState() => _CommentScreenState();
// }

// class _CommentScreenState extends State<CommentScreen> {
//   final _commentTextController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 7, 30, 47),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,
//               color: Color.fromARGB(255, 255, 255, 255)),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Find Others',
//           style: CustomTextStyle.semiBoldText
//               .copyWith(fontSize: responsiveSize(context, 0.04)),
//         ),
//       ),
//       body: Container(
//         color: Color.fromARGB(255, 7, 30, 47),
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('Posts')
//                     .doc(widget.postId)
//                     .collection('Comments')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     QuerySnapshot commentsSnapshot = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: commentsSnapshot.docs.length,
//                       itemBuilder: (context, index) {
//                         DocumentSnapshot commentSnapshot =
//                             commentsSnapshot.docs[index];
//                         // time stmp
//                         Timestamp createdAt = commentSnapshot['createdAt'];
//                         String formattedTime =
//                             DateFormat.jm().format(createdAt.toDate());

//                         final currentUserId =
//                             FirebaseAuth.instance.currentUser?.uid;

//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage:
//                                 NetworkImage(commentSnapshot['profilePic']),
//                             radius: 30,
//                           ),
//                           title: Text(
//                             commentSnapshot['username'],
//                             style: CustomTextStyle.semiBoldText.copyWith(
//                                 fontSize: responsiveSize(context, 0.04)),
//                           ),
//                           subtitle: Text(
//                             commentSnapshot['commentText'],
//                             style: CustomTextStyle.regularText.copyWith(
//                                 fontSize: responsiveSize(context, 0.04)),
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(formattedTime),
//                               commentSnapshot['userId'] == currentUserId
//                                   ? IconButton(
//                                       icon: const Icon(
//                                         Icons.delete,
//                                         color: Colors.white,
//                                       ),
//                                       onPressed: () {
//                                         deleteComment(commentSnapshot.id);
//                                       },
//                                     )
//                                   : Container(),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   } else {
//                     return const Center(
//                         child: CircularProgressIndicator(
//                       color: Colors.white,
//                     ));
//                   }
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//           children: [
//   Expanded(
//     child: TextField(
//       controller: _commentTextController,
//       decoration: customInputDecoration('Add a comment'),
//       cursorColor: Colors.white,
//       style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),
//     ),
//   ),
//   IconButton(
//     icon: const Icon(Icons.send, color: Color.fromARGB(255, 243, 107, 4)),
//     onPressed: () async {
//       if (_commentTextController.text.isNotEmpty) {
//         addComment(context, widget.postId);
//         _commentTextController.clear();
//       }
//     },
//   ),
// ],
//               )
//               )
//           ]
//         )
//       )
//     );
    
//   }

// //   void addComment(BuildContext context, String postId) async {
// //     if (_commentTextController.text.isNotEmpty) {
// //       String comment = _commentTextController.text;

// //       try {
// //         await Provider.of<PostsProvider>(context, listen: false)
// //             .addComment(comment, postId);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Comment added successfully', style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)))),

// //         );
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Failed to add comment: $e')),
// //         );
// //       }
// //     }
// //   }

// //   void deleteComment(String commentId) async {
// //     try {
// //       await FirebaseFirestore.instance
// //           .collection('Posts')
// //           .doc(widget.postId)
// //           .collection('Comments')
// //           .doc(commentId)
// //           .delete();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Comment deleted successfully')),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to delete comment: $e')),
// //       );
// //     }
// //   }
// // }

//   void addComment(BuildContext context, String postId) async {
//     if (_commentTextController.text.isNotEmpty) {
//       String comment = _commentTextController.text;

//       try {
//         await Provider.of<PostsProvider>(context, listen: false)
//             .addComment(comment, postId);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Color.fromARGB(255, 243, 107, 4),
//             content: Text(
//               'Comment added successfully',
//               style: CustomTextStyle.regularText.copyWith(
//                 fontSize: responsiveSize(context, 0.04),
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Color.fromARGB(255, 243, 107, 4),
//             content: Text(
//               'Failed to add comment: $e',
//               style: CustomTextStyle.regularText.copyWith(
//                 fontSize: responsiveSize(context, 0.04),
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   void deleteComment(String commentId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Posts')
//           .doc(widget.postId)
//           .collection('Comments')
//           .doc(commentId)
//           .delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Color.fromARGB(255, 243, 107, 4),
//           content: Text(
//             'Comment deleted successfully',
//             style: CustomTextStyle.regularText.copyWith(
//               fontSize: responsiveSize(context, 0.04),
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Color.fromARGB(255, 243, 107, 4),
//           content: Text(
//             'Failed to delete comment: $e',
//             style: CustomTextStyle.regularText.copyWith(
//               fontSize: responsiveSize(context, 0.04),
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }


class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 30, 47),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Find Others',
          style: CustomTextStyle.semiBoldText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 7, 30, 47),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Posts')
                    .doc(widget.postId)
                    .collection('Comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot commentsSnapshot = snapshot.data!;
                    return ListView.builder(
                      itemCount: commentsSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot commentSnapshot =
                            commentsSnapshot.docs[index];
                        // time stmp
                        Timestamp createdAt = commentSnapshot['createdAt'];
                        String formattedTime =
                            DateFormat.jm().format(createdAt.toDate());

                        final currentUserId =
                            FirebaseAuth.instance.currentUser?.uid;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(commentSnapshot['profilePic']),
                            radius: 30,
                          ),
                          title: Text(
                            commentSnapshot['username'],
                            style: CustomTextStyle.semiBoldText.copyWith(
                                fontSize: responsiveSize(context, 0.04)),
                          ),
                          subtitle: Text(
                            commentSnapshot['commentText'],
                            style: CustomTextStyle.regularText.copyWith(
                                fontSize: responsiveSize(context, 0.04)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formattedTime,
                                style: CustomTextStyle.regularText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                              ),
                              commentSnapshot['userId'] == currentUserId
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        deleteComment(commentSnapshot.id);
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentTextController,
                      decoration: customInputDecoration('Add a comment'),
                      cursorColor: Colors.white,
                      style: CustomTextStyle.regularText.copyWith(
                          fontSize: responsiveSize(context, 0.04)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 243, 107, 4)),
                    onPressed: () async {
                      if (_commentTextController.text.isNotEmpty) {
                        addComment(context, widget.postId);
                        _commentTextController.clear();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addComment(BuildContext context, String postId) async {
    if (_commentTextController.text.isNotEmpty) {
      String comment = _commentTextController.text;

      try {
        await Provider.of<PostsProvider>(context, listen: false)
            .addComment(comment, postId);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 243, 107, 4),
            content: Text(
              'Comment added successfully',
              style: CustomTextStyle.regularText.copyWith(
                fontSize: responsiveSize(context, 0.04),
                color: Colors.white,
              ),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 243, 107, 4),
            content: Text(
              'Failed to add comment: $e',
              style: CustomTextStyle.regularText.copyWith(
                fontSize: responsiveSize(context, 0.04),
                color: Colors.white,
              ),
            ),
 ),
        );
      }
    }
  }

  void deleteComment(String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(commentId)
          .delete();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 243, 107, 4),
          content: Text(
            'Comment deleted successfully',
            style: CustomTextStyle.regularText.copyWith(
              fontSize: responsiveSize(context, 0.04),
              color: Colors.white,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 243, 107, 4),
          content: Text(
            'Failed to delete comment: $e',
            style: CustomTextStyle.regularText.copyWith(
              fontSize: responsiveSize(context, 0.04),
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}