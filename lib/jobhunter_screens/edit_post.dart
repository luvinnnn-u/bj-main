// import 'package:bluejobs/model/posts_model.dart';
// import 'package:bluejobs/provider/auth_provider.dart';
// import 'package:bluejobs/provider/posts_provider.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../styles/custom_theme.dart';

// class EditPost extends StatefulWidget {
//   final String postId;

//   const EditPost({super.key, required this.postId});

//   @override
//   State<EditPost> createState() => _EditPostState();
// }

// class _EditPostState extends State<EditPost> {
//   late final AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     fetchPostById(widget.postId);
//   }

//   final _formKey = GlobalKey<FormState>();
//   String? _description;
//   String? _type;
//   String? _rate;
//   bool _isLoading = true;
//   Post? _post;

//   // fetch specific post
//   Future<void> fetchPostById(String postId) async {
//     try {
//       final postRef =
//           FirebaseFirestore.instance.collection('Posts').doc(postId);
//       final docRef = await postRef.get();

//       if (docRef.exists) {
//         final post = Post.fromMap(docRef.data() ?? {});
//         if (post.ownerId == _authProvider.uid) {
//           setState(() {
//             _post = post;
//             _description = _post?.description;
//             _type = _post?.type;
//             // _rate = _post?.rate;
//             _isLoading = false;
//           });
//         } else {
//           debugPrint("You don't have permission to edit this post!");
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       } else {
//         debugPrint("No post found!");
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching post: $e");
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 30),
//                       Text(
//                         'Edit Post',
//                         style: CustomTextStyle.semiBoldText.copyWith(
//                           color: Colors.black,
//                           fontSize: responsiveSize(context, 0.07),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       TextFormField(
//                         initialValue: _description,
//                         decoration: customInputDecoration('Description'),
//                         maxLines: 20,
//                         minLines: 1,
//                         keyboardType: TextInputType.multiline,
//                         onSaved: (value) => _description = value,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         initialValue: _type,
//                         decoration: customInputDecoration('Type of Job'),
//                         maxLines: 10,
//                         minLines: 1,
//                         keyboardType: TextInputType.multiline,
//                         onSaved: (value) => _type = value,
//                       ),

//                       const SizedBox(height: 20),

//                       Row(
//                         children: [
//                           ElevatedButton(
//                               child: const Text('Cancel'),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               }),
//                           ElevatedButton(
//                             onPressed: () => _savePost(),
//                             child: const Text('Save'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   // update post method
//   Future<void> _savePost() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       try {
//         final post = Post(
//           id: widget.postId,
//           description: _description ?? _post?.description,
//           type: _type ?? _post?.type,
//         );

//         final postsProvider =
//             Provider.of<PostsProvider>(context, listen: false);
//         await postsProvider.updatePost(post);

//         Navigator.pop(context);
//       } catch (e) {
//         debugPrint("Error saving post: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error saving post: $e")),
//         );
//       }
//     }
//   }
// }

import 'package:bluejobs/model/posts_model.dart';
import 'package:bluejobs/provider/auth_provider.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles/custom_theme.dart';

class EditPost extends StatefulWidget {
  final String postId;

  const EditPost({super.key, required this.postId});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    fetchPostById(widget.postId);
  }

  final _formKey = GlobalKey<FormState>();
  String? _description;
  String? _type;
  String? _rate;
  bool _isLoading = true;
  Post? _post;

  // fetch specific post
  Future<void> fetchPostById(String postId) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('Posts').doc(postId);
      final docRef = await postRef.get();

      if (docRef.exists) {
        final post = Post.fromMap(docRef.data() ?? {});
        if (post.ownerId == _authProvider.uid) {
          setState(() {
            _post = post;
            _description = _post?.description;
            _type = _post?.type;
            // _rate = _post?.rate;
            _isLoading = false;
          });
        } else {
          debugPrint("You don't have permission to edit this post!");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        debugPrint("No post found!");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching post: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 7, 30, 47),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context)
                  .size
                  .height, // Set the height to the full height of the screen
              color: Color.fromARGB(255, 7, 30, 47),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Edit Post',
                            style: CustomTextStyle.semiBoldText.copyWith(
                              fontSize: responsiveSize(context, 0.05),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _description,
                          decoration: customInputDecoration('Description'),
                          cursorColor: Colors.white,
                          style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),
                          maxLines: 20,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => _description = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _type,
                          decoration: customInputDecoration('Type of Job'),
                          cursorColor: Colors.white,
                          style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),
                          maxLines: 10,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => _type = value,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            CustomButton(
                              onPressed: () => _savePost(),
                              buttonText: 'Save',
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 53,
                              width: 400,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  backgroundColor:
                                      const Color.fromARGB(255, 7, 30, 47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: CustomTextStyle.regularText
                                      .copyWith(color: Colors.orange),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }


// update post method
  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final post = Post(
          id: widget.postId,
          description: _description ?? _post?.description,
          type: _type ?? _post?.type,
        );

        if (_description != null &&
            _description!.isNotEmpty &&
            _type != null &&
            _type!.isNotEmpty) {
          final postsProvider =
              Provider.of<PostsProvider>(context, listen: false);
          await postsProvider.updatePost(post);

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Post updated successfully",
                  style: CustomTextStyle.regularText
                      .copyWith(fontSize: responsiveSize(context, 0.04))),
              backgroundColor: Color.fromARGB(255, 243, 107, 4),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("I'm sorry. You can't make an empty post :< .",
                  style: CustomTextStyle.regularText
                      .copyWith(fontSize: responsiveSize(context, 0.04))),
              backgroundColor: Color.fromARGB(255, 243, 107, 4),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error saving post: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving post: $e",
                style: CustomTextStyle.regularText
                    .copyWith(fontSize: responsiveSize(context, 0.04))),
            backgroundColor: Color.fromARGB(255, 243, 107, 4),
          ),
        );
      }
    }
  }
}
